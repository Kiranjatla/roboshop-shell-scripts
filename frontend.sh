 LOG_FILE=/tmp/frontend
 source common.sh

 echo Installing Nginx software
 yum install nginx -y &>>$LOG_FILE
 statuscheck $?

 echo Downloading Nginx Web Content
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
 statuscheck $?
 cd /usr/share/nginx/html

 echo Removing Old Web Content
 rm -rf * &>>$LOG_FILE
 statuscheck $?

 echo Extracting Web Content
 unzip /tmp/frontend.zip &>>$LOG_FILE
 statuscheck $?

 mv frontend-main/static/* . &>>$LOG_FILE
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE

 echo Starting Nginx Service
 systemctl enable nginx &>>$LOG_FILE
 statuscheck $?
 systemctl start nginx &>>$LOG_FILE
 statuscheck $?
 systemctl restart nginx &>>$LOG_FILE
 statuscheck $?