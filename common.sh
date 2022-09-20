
ID=$(id -u)
if [ $ID -ne 0 ] ; then
echo you should run this script as root or with sudo privilages.
exit 1
fi
 statuscheck(){
   if [ $1 -eq 0 ] ; then
       echo -e status = "\e[32mSuccess\e[0m"
     else
       echo -e status = "\e[31mFailure\e[0m"
       exit 1
      fi
}
APP_PREREQ(){
      id roboshop &>>${LOG_FILE}
       if [ $? -ne 0 ]; then
        echo "Add Roboshop application user"
        user add roboshop &>>${LOG_FILE}
         statuscheck $?
       fi

       echo "Download ${COMPONENT} application code"
       curl -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG_FILE}
        statuscheck $?

        cd /home/roboshop

        echo "Clean old ${COMPONENT} app content"
         rm -rf ${COMPONENT} &>>${LOG_FILE}
          statuscheck $?

        echo "Extracting ${COMPONENT} application code"
        unzip /tmp/${COMPONENT}.zip &>>${LOG_FILE}
         statuscheck $?

        mv ${COMPONENT}-main ${COMPONENT}
        cd /home/roboshop/${COMPONENT}
}
SYSTEMD_SETUP(){
  echo "Update SystemD service file"
      sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/MONGO_DNSNAME/mongodg.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' /home/roboshop/${COMPONENT}/systemd.service
      statuscheck $?

      echo "Setup ${COMPONENT} service"
      mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service &>>${LOG_FILE}
       statuscheck $?
       systemctl daemon-reload &>>${LOG_FILE}
       systemctl enable ${COMPONENT} &>>${LOG_FILE}

       echo "Start ${COMPONENT} service"
       systemctl start ${COMPONENT} &>>${LOG_FILE}
       statuscheck $?
       }
NODEJS(){
  echo "Setup Nodejs repos"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
    statuscheck $?

    echo "Installing Nodejs"
    yum install nodejs -y &>>${LOG_FILE}
     statuscheck $?

      APP_PREREQ

      echo "Install NodeJS Dependencies"
      npm install &>>${LOG_FILE}
      statuscheck $?

      SYSTEMD_SETUP
}
     JAVA() {
       echo "Install maven" &>>${LOG_FILE}
       yum install maven -y &>>${LOG_FILE}
       statuscheck $?

        APP_PREREQ

       echo "Download Dependencies And Make Package"
        mvn clean package &>>${LOG_FILE}
        mv target/${COMPONENT}-1.0.jar ${COMPONENT}.jar &>>${LOG_FILE}
        statuscheck $?

        SYSTEMD_SETUP
}
PYTHON(){
  echo "Install Python 3"
  yum install python36 gcc python3-devel -y &>>${LOG_FILE}
  statuscheck $?

  APP_PREREQ

  cd /home/roboshop/${COMPONENT} &>>${LOG_FILE}

  echo "Install Python Dependencies"
 pip3 install -r requirements.txt &>>${LOG_FILE}
 statuscheck $?

}