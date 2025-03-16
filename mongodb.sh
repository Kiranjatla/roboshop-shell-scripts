 LOG_FILE=/tmp/mongodb
 echo "setting Mongodb repo file"
 curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
 echo status = $?

 echo "installing mongodb server"
 yum install -y mongodb-org &>>$LOG_FILE
 echo status = $?

 echo "update MongoDB Listen Ip Address"
 sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
 echo status = $?

 echo "Enabled mongodb server"
 systemctl enable mongod &>>$LOG_FILE
 echo status = $?

 echo "restarted mongodb server"
 systemctl restart mongod
 echo status = $?

 echo "Downloading Mongodb Schema"
 curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
 echo status = $?

 cd /tmp
 echo "extract Mongodb schema files"
 unzip mongodb.zip &>>$LOG_FILE
 echo status = $?

 cd mongodb-main

 echo "extract Catalogue service schema files"
 mongo < catalogue.js
 echo status = $?

 echo "extract users service schema files"
 mongo < users.js
 echo status = $?

