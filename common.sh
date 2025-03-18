ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo you should run this as root user or with sudo previleges
  exit 1
fi
StatusCheck(){
  if [ $1 -eq 0 ]; then
    echo -e status = "\e[32msuccess\e[0m"
  else
    echo -e status = "\e[31mfailure\e[0m"
    exit 1
  fi
}

NODEJS(){
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

  echo "Download ${COMPONENT} application code"
  curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG_FILE}
  StatusCheck $?

  cd /home/roboshop

  echo "clean old app content"
  rm -rf ${COMPONENT} &>>${LOG_FILE}
  StatusCheck $?

  echo "extract ${COMPONENT} application code"
  unzip /tmp/${COMPONENT}.zip &>>${LOG_FILE}
  StatusCheck $?

  mv ${COMPONENT}-main ${COMPONENT}
  cd /home/roboshop/${COMPONENT}

  echo "Install Nodejs Dependencies"
  npm install &>>${LOG_FILE}
  StatusCheck $?

  ##Update "Update SystemD service file"
  echo "Update SystemD service file"
  sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service &>>${LOG_FILE}
  StatusCheck $?

  echo "Setup ${COMPONENT} Service"
  mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${LOG_FILE}
  StatusCheck $?

  systemctl daemon-reload &>>${LOG_FILE}
  systemctl enable ${COMPONENT} &>>${LOG_FILE}

  echo "Restart the Servcie"
  systemctl start ${COMPONENT} &>>${LOG_FILE}
  StatusCheck $?
}