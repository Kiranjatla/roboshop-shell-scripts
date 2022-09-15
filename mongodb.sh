 LOG_FILE=/tmp/mongodb
echo "Setting Mongodb Repos File"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
echo status=$?

echo "Installing Mongodb server"
yum install -y mongodb-org &>>$LOG_FILE
echo status=$?

echo "Starting Mongodb server"
systemctl enable mongod &>>$LOG_FILE
systemctl start mongod &>>$LOG_FILE
echo status=$?


