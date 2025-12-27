LOG_FILE=/tmp/redis

source common.sh

#echo "Setup YUM Repos for Redis"
# This remi repos is not working any more, So ignore this step and move to next step directly. Run the commands from next step.
#dnf install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOG_FILE
#StatusCheck $?

echo "disabling Redis YUM Modules"
dnf module disable redis -y &>>$LOG_FILE
StatusCheck $?

echo "enable Redis module"
dnf module enable redis:6 -y &>>$LOG_FILE
StatusCheck $?

echo "install redis"
dnf install redis -y  &>>$LOG_FILE
StatusCheck $?

echo "Updated Redis Listen address from 127.0.0.1 to 0.0.0.0"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf
StatusCheck $?

echo "enable redis"
systemctl enable redis &>>$LOG_FILE
StatusCheck $?

echo "Start Redis"
systemctl restart redis &>>$LOG_FILE
StatusCheck $?