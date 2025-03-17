LOG_FILE=/tmp/catalogue
echo "setup nodejs repos"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
  else
  echo status - failure
  exit
  fi

echo "Install nodejs"
yum install nodejs -y  &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
  else
  echo status - failure
  exit
  fi

echo "Adding Roboshop application User"
useradd roboshop &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
  else
  echo status - failure
  exit
  fi

echo "Download catalogue application code"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
  else
  echo status - failure
  exit
  fi

cd /home/roboshop

echo "extract catalogue application code"
unzip /tmp/catalogue.zip &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
  else
  echo status - failure
  exit
  fi

mv catalogue-main catalogue
cd /home/roboshop/catalogue

echo "Install Nodejs Dependencies"
npm install &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
  else
  echo status - failure
  exit
  fi

echo "Setup Catalogue Service"
mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
  else
  echo status - failure
  exit
  fi

systemctl daemon-reload &>>LOG_FILE
systemctl enable catalogue &>>LOG_FILE

echo "Restart the Servcie"
systemctl start catalogue &>>LOG_FILE
if [ $? -eq 0 ]; then
  echo status = success
  else
  echo status - failure
  exit
  fi
