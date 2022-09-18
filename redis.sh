LOG_FILE=/tmp/catalogue

 source common.sh

 echo "setup YUM repos for redis"
 dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOG_FILE
 statuscheck() $?

 echo "Enabling the Module of Redis"
 dnf module enable redis:remi-6.2 -y &>>$LOG_FILE
 statuscheck() $?

 echo "Install Redis"
 yum install redis -y &>>$LOG_FILE
 statuscheck() $?

 echo "Update Redis Listen Address 127.0.0.1 to 0.0.0.0"
 sed -i -e 's/127.0.0.1/0.0.0.0' /etc/redis.conf /etc/redis/redis.conf &>>$LOG_FILE
 statuscheck() $?

 systemctl enable redis &>>$LOG_FILE
 echo "Redis Start"
 systemctl start redis &>>$LOG_FILE
 statuscheck() $?
