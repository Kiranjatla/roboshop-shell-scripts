LOG_FILE=/tmp/user

  source common.sh
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

   echo "Download User application code"
   curl -s -L -o /tmp/user.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>${LOG_FILE}
    statuscheck $?

    cd /home/roboshop

    echo "Clean old catlaogue app content"
     rm -rf user &>>${LOG_FILE}
      statuscheck $?

    echo "Extracting user application code"
    unzip /tmp/user.zip &>>${LOG_FILE}
     statuscheck $?

    mv user-main user
    cd /home/roboshop/user

    echo "Install NodeJS Dependencies"
    npm install &>>${LOG_FILE}
    statuscheck $?

    echo "Update SystemD service file"
    sed -i -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' /home/roboshop/user/systemd.service
    statuscheck $?

    echo "Setup user service"
    mv /home/roboshop/user/systemd.service /etc/systemd/system/user.service &>>${LOG_FILE}
     statuscheck $?
     systemctl daemon-reload &>>${LOG_FILE}
     systemctl enable user &>>${LOG_FILE}

     echo "Start user service"
     systemctl start user &>>${LOG_FILE}
     statuscheck $?