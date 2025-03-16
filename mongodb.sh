 LOG_FILE=/tmp/mongodb
 echo "setting Mongodb repo file"
 curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
 echo status = $?

 echo "installing mongodb server"
 yum install -y mongodb-org &>>$LOG_FILE
 echo status = $?

 echo "Enabled mongodb server"
 systemctl enable mongod &>>$LOG_FILE
 echo status = $?

 echo "restarted mongodb server"
 systemctl restart mongod &>>$LOG_FILE
 echo status = $?

 curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"

 cd /tmp
 unzip mongodb.zip
 cd mongodb-main
 mongo < catalogue.js
 mongo < users.js

