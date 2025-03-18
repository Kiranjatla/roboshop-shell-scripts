 LOG_FILE=/tmp/mysql
 source common.sh

 echo "settingup mysql repo file"
 curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG_FILE}
 StatusCheck $?

 echo "disable mysql default module to enable 5.7 mysql"
 dnf module disable mysql -y &>>${LOG_FILE}
 StatusCheck $?

 echo "install mysql"
 yum install mysql-community-server -y &>>${LOG_FILE}
 StatusCheck $?

 echo "Start mysql service"
 systemctl enable mysqld &>>${LOG_FILE}
 systemctl start mysqld &>>${LOG_FILE}
 StatusCheck $?

 DEFAULT_PASSWORD=$(sudo grep 'A temp' /var/log/mysqld.log | awk '{print $11}')

 echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('${ROBOSHOP_MYSQL_PASSWORD}');
 FLUSH PRIVILEGES;" >/tmp/root-pass.sql

 echo "show databases;" |mysql -uroot -p${ROBOSHOP_MYSQL_PASSWORD} &>>${LOG_FILE}
 if [ $? -ne 0 ] ; then
 echo "Change the default root password"
 mysql --connect-expired-password -uroot -p${DEFAULT_PASSWORD} </tmp/root-pass.sql &>>${LOG_FILE}
 StatusCheck $?
 fi


 #mysql -uroot -pRoboShop@1
#> uninstall plugin validate_password;
 #curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
 #cd /tmp
 #unzip mysql.zip
 #cd mysql-main
 #mysql -u root -pRoboShop@1 <shipping.sql