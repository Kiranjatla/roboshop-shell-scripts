LOG_FILE=/tmp/user

  source common.sh
  COMPONENT=user

  NODEJS

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