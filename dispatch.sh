COMPONENT=dispatch
LOG_FILE=/tmp/${COMPONENT}

 source common.sh

  echo "Install Golong"
  yum install golang -y $>>$LOG_FILE
  statuscheck $?

  APP_PREREQ
  cd dispatch
  echo"Mod Init Dispatch"
   go mod init dispatch $>>$LOG_FILE
   statuscheck $?
   echo "Go Get"
   go get $>>$LOG_FILE
   statuscheck $?
   echo "Build"
   go build $>>$LOG_FILE
   statuscheck $?

   SYSTEMD_SETUP
