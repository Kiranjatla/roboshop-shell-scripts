LOG_FILE=/tmp/catalogue
 echo "Setup Nodejs repos"
 curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${LOG_FILE}
 echo status=$?

 echo "Installing Nodejs"
 yum install nodejs -y &>>${LOG_FILE}
 if [ $? -eq 0 ] ; then
    echo status = success
  else
    echo status = failure
    exit
   fi

 echo "Add Roboshop application user"
 user add roboshop &>>${LOG_FILE}
 if [ $? -eq 0 ] ; then
     echo status = success
   else
     echo status = failure
     exit
    fi

echo "Download catalogue application code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
if [ $? -eq 0 ] ; then
    echo status = success
  else
    echo status = failure
    exit
   fi
 cd /home/roboshop

 echo "Extracting catalogue application code"
 unzip /tmp/catalogue.zip &>>${LOG_FILE}
 if [ $? -eq 0 ] ; then
     echo status = success
   else
     echo status = failure
     exit
    fi

 mv catalogue-main catalogue
 cd /home/roboshop/catalogue

 echo "Install NodeJS Dependencies"
 npm install &>>${LOG_FILE}
 if [ $? -eq 0 ] ; then
     echo status = success
   else
     echo status = failure
     exit
    fi

echo "Setup Catalogue service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>${LOG_FILE}
if [ $? -eq 0 ] ; then
    echo status = success
  else
    echo status = failure
    exit
   fi
 systemctl daemon-reload &>>${LOG_FILE}
 systemctl enable catalogue &>>${LOG_FILE}

 echo "Start catalogue service"
 systemctl start catalogue &>>${LOG_FILE}
if [ $? -eq 0 ] ; then
    echo status = success
  else
    echo status = failure
    exit
   fi