LOG_FILE=/tmp/catalogue
Source common.sh

 echo "Setup Nodejs repos"
 curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
 statuscheck $?

 echo "Installing Nodejs"
 yum install nodejs -y &>>${LOG_FILE}
  statuscheck $?

id roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
 echo "Add Roboshop application user"
 user add roboshop &>>${LOG_FILE}
  statuscheck $?
fi
echo "Download catalogue application code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
 statuscheck $?

 cd /home/roboshop

 echo "Clean old catlaogue app content"
  rm -rf catalogue &>>${LOG_FILE}
   statuscheck $?

 echo "Extracting catalogue application code"
 unzip /tmp/catalogue.zip &>>${LOG_FILE}
  statuscheck $?

 mv catalogue-main catalogue
 cd /home/roboshop/catalogue

 echo "Install NodeJS Dependencies"
 npm install &>>${LOG_FILE}
 statuscheck $?

echo "Setup Catalogue service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>${LOG_FILE}
 statuscheck $?
 systemctl daemon-reload &>>${LOG_FILE}
 systemctl enable catalogue &>>${LOG_FILE}

 echo "Start catalogue service"
 systemctl start catalogue &>>${LOG_FILE}
 statuscheck $?