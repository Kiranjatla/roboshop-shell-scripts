COMPONENT=rabbitmq
source common.sh
LOG_FILE=/tmp/${COMPONENT}

echo "Setup Rabbitmq Repos"
 curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOG_FILE
 statuscheck $?
echo "Install Erland &n Rabbitmq"
 yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm rabbitmq-server -y &>>$LOG_FILE
 statuscheck $?
echo "Start Rabbitmq Server"
systemctl enable rabbitmq-server &>>$LOG_FILE
systemctl start rabbitmq-server &>>$LOG_FILE
statuscheck $?

sudo rabbitmqctl list_users | grep roboshop
if [ $? -ne 0 ]; then
   echo "Add Aplication User in Rabbitmq"
   rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
   statuscheck $?
fi
echo "Add Aplication tags User in Rabbitmq"
 rabbitmqctl set_user_tags roboshop administrator &>>$LOG_FILE
 statuscheck $?
 echo "Add Permissions for App user in Rabbitmq"
 rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOG_FILE
  statuscheck $?