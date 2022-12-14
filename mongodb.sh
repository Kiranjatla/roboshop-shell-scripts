LOG_FILE=/tmp/mongodb

source common.sh

echo "Setting Mongodb Repos File"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
statuscheck $?

echo "Installing Mongodb server"
yum install -y mongodb-org &>>$LOG_FILE
statuscheck $?

echo "Update mongodb listen ip address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
statuscheck $?

echo "Starting Mongodb server"
systemctl enable mongod &>>$LOG_FILE && systemctl start mongod &>>$LOG_FILE
statuscheck $?

echo "Downloading Mongodb Schema"
 curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
 statuscheck $?

  cd /tmp
  echo "Extracting Schema files"
  unzip -o mongodb.zip &>>$LOG_FILE
  statuscheck $?
  cd mongodb-main

  echo "Load Catalogue service schema"
  mongo < catalogue.js &>>$LOG_FILE
  statuscheck $?

  echo "Load users  service schema"
  mongo < users.js &>>$LOG_FILE
  statuscheck $?







