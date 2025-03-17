LOG_FILE=/tmp/catalogue

ID=$(id -u)
if [ $ID -ne 0 ]; then
  echo you should run this as root user (or) with sudo previleges
  exit 1
   fi

echo "setup nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
  exit 1
  fi

echo "Install nodejs"
yum install nodejs -y &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
  exit 1
  fi

echo "Adding Roboshop application User"
useradd roboshop &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
  exit 1
  fi

echo "Download catalogue application code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
  exit 1
  fi

cd /home/roboshop

echo "extract catalogue application code"
unzip /tmp/catalogue.zip &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
  exit 1
  fi

mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo "Install Nodejs Dependencies"
npm install &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
  exit 1
  fi

echo "Setup Catalogue Service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
  exit 1
  fi

systemctl daemon-reload &>>LOG_FILE
systemctl enable catalogue &>>LOG_FILE

echo "Restart the Servcie"
systemctl start catalogue &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
else
  echo status = failure
  exit 1
  fi
