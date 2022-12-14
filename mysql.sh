LOG_FILE=/tmp/mysql
 source common.sh

 if [ -z "${ROBOSHOP_MYSQL_PASSWORD}" ]; then
   echo -e "\e[31m ROBOSHOP_MYSQL_PASSWORD env Variable is Needed\e[0m"
   exit 1
   fi

 echo "setting up  MySQL Repo file"
curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG_FILE
statuscheck $?
echo "Disable MY SQL Default Module to enable 5.7  MY SQL"
dnf module disable mysql -y &>>$LOG_FILE
statuscheck $?

 echo "Install MY SQL"
 yum install mysql-community-server -y &>>$LOG_FILE
 statuscheck $?

 echo "Start My SQL Service"
 systemctl enable mysqld &>>$LOG_FILE
 systemctl start mysqld &>>$LOG_FILE
 statuscheck $?

 DEFAULT_PASSWORD=$(grep 'A temporary password' /var/log/mysqld.log | awk '{print $NF}')

 echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${ROBOSHOP_MYSQL_PASSWORD}');
 FLUSH PRIVILEGES;" >/tmp/root-pass.sql

 echo "show databases;" |mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} &>>$LOG_FILE
 if [ $? -ne 0 ]; then
   echo "Change the default root password"
   mysql --connect-expired-password -uroot -p"${DEFAULT_PASSWORD}"  </tmp/root-pass.sql &>>$LOG_FILE
   statuscheck $?
fi

echo 'show plugins'| mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} 2>/dev/null | grep validate_password &>>$LOG_FILE
 if [ $? -eq 0 ]; then
  echo "Uninstall password validation plugin"
  echo "Uninstall plugin validate_password;" | mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} &>>LOG_FILE
  statuscheck $?
fi
 echo "Download Schema "
 curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>LOG_FILE
 statuscheck $?

 echo "Extract schema"
 cd /tmp &>>LOG_FILE
 unzip -o mysql.zip &>>LOG_FILE
 statuscheck $?

 echo "Load Schema"
 cd mysql-main &>>LOG_FILE
 mysql -u root -p${ROBOSHOP_MYSQL_PASSWORD} <shipping.sql &>>LOG_FILE
 statuscheck $?
