LOG_FILE=/tmp/mongodb
echo "Setting Mongodb Repos File"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
echo status=$?

echo "Installing Mongodb server"
yum install -y mongodb-org &>>$LOG_FILE
echo status=$?

echo "Update mongodb listen ip address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
echo status = $?

echo "Starting Mongodb server"
systemctl enable mongod &>>$LOG_FILE
systemctl start mongod &>>$LOG_FILE
echo status=$?

echo "Downloading Mongodb Schema"
 curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
 echo status-$?

  cd /tmp
  echo "Extracting Schema files"
  unzip mongodb.zip &>>$LOG_FILE
  echo status-$?
  cd mongodb-main

  echo"Load Catalogue service schema"
  mongo < catalogue.js &>>$LOG_FILE
  echo status-$?

  echo "Load users  service schema"
  mongo < users.js &>>$LOG_FILE
  echo status-$?







