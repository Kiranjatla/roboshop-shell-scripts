LOG_FILE=/tmp/redis

source common.sh

echo "setup nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
StatusCheck $?

echo "Install nodejs"
yum install nodejs -y &>>${LOG_FILE}
StatusCheck $?

id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
echo "Adding Roboshop application User"
useradd roboshop &>>${LOG_FILE}
 StatusCheck $?
fi

echo "Download user application code"
curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>${LOG_FILE}
StatusCheck $?

cd /home/roboshop

echo "clean old app content"
rm -rf user &>>${LOG_FILE}
StatusCheck $?

echo "extract user application code"
unzip /tmp/user.zip &>>${LOG_FILE}
StatusCheck $?

mv user-main user
cd /home/roboshop/user

echo "Install Nodejs Dependencies"
npm install &>>${LOG_FILE}
StatusCheck $?

##Update "Update SystemD service file"
echo "Update SystemD service file"
sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/roboshop/user/systemd.service &>>${LOG_FILE}
StatusCheck $?

echo "Setup user Service"
mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service &>>${LOG_FILE}
StatusCheck $?

systemctl daemon-reload &>>${LOG_FILE}
systemctl enable user &>>${LOG_FILE}

echo "Restart the Servcie"
systemctl start user &>>${LOG_FILE}
StatusCheck $?

