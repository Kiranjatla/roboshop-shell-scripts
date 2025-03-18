LOG_FILE=/tmp/catalogue

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

echo "Download catalogue application code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
StatusCheck $?

cd /home/roboshop

echo "clean old app content"
rm -rf catalogue &>>${LOG_FILE}
StatusCheck $?

echo "extract catalogue application code"
unzip /tmp/catalogue.zip &>>${LOG_FILE}
StatusCheck $?

mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo "Install Nodejs Dependencies"
npm install &>>${LOG_FILE}
StatusCheck $?

echo "Setup Catalogue Service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>${LOG_FILE}
StatusCheck $?

systemctl daemon-reload &>>${LOG_FILE}
systemctl enable catalogue &>>${LOG_FILE}

echo "Restart the Servcie"
systemctl start catalogue &>>${LOG_FILE}
StatusCheck $?
