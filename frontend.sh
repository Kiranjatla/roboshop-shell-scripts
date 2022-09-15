 LOG_FILES=/tmp/frontend

 echo Installing Nginx software
 yum install nginx -y &>>$LOG_FILES
 echo status = $?

 echo Downloading Nginx Web Content
 curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILES
 echo status = $?
 cd /usr/share/nginx/html

 echo Removing Old Web Content
 rm -rf * &>>$LOG_FILES
 echo status = $?

 echo Extracting Web Content
 unzip /tmp/frontend.zip &>>$LOG_FILES
 echo status = $?

 mv frontend-main/static/* . &>>$LOG_FILES
 mv frontend-main/localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILES

 echo Starting Nginx Service
 systemctl enable nginx &>>$LOG_FILES
 echo status = $?
 systemctl start nginx &>>$LOG_FILES
 echo status = $?
 systemctl restart nginx &>>$LOG_FILES
 echo status = $?