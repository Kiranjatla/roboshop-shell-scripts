COMPONENT=dispatch
LOG_FILE=/tmp/${COMPONENT}
source common.sh
echo "Install golang "
yum install golang -y &>>$LOG_FILE
StatusCheck $?

APP_PREREQ

SYSTEMD_SETUP



