 LOG_FILE=/tmp/mongodb
 source common.sh

 echo "setting Mongodb repo file"
 curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
 StatusCheck $?

 echo "installing mongodb server"
 yum install -y mongodb-org &>>$LOG_FILE
 StatusCheck $?

 echo "update MongoDB Listen Ip Address"
 sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOG_FILE
 StatusCheck $?

 echo "Enabled mongodb server"
 systemctl enable mongod &>>$LOG_FILE
 StatusCheck $?

 echo "restarted mongodb server"
 systemctl restart mongod &>>$LOG_FILE
 StatusCheck $?

 echo "Downloading Mongodb Schema"
 curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
 StatusCheck $?

 cd /tmp
 echo "extract Mongodb schema files"
 unzip -o mongodb.zip &>>$LOG_FILE
 StatusCheck $?

 cd mongodb-main

 echo "extract Catalogue service schema files"
 mongo < catalogue.js &>>$LOG_FILE
 StatusCheck $?

 echo "extract users service schema files"
 mongo < users.js &>>$LOG_FILE
 StatusCheck $?

