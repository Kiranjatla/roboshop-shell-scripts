LOG_FILE=/tmp/mysql

 source common.sh
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
# grep temp /var/log/mysqld.log
# mysql_secure_installation
# mysql -uroot -pRoboShop@1
# > uninstall plugin validate_password;
# curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
# cd /tmp
# unzip mysql.zip
# cd mysql-main
# mysql -u root -pRoboShop@1 <shipping.sql