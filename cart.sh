 LOG_FILE=/tmp/cart

  source common.sh

  echo"Adding Rpos File"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>LOG_FILE
  statuscheck $?

  echo"Installing Nodejs"
  yum install nodejs -y &>>LOG_FILE
  statuscheck $?

  echo"Add Roboshop User"
  useradd roboshop &>>LOG_FILE
  statuscheck $?

   curl -s -L -o /tmp/cart.zip "https://github.com/roboshop-devops-project/cart/archive/main.zip"
   cd /home/roboshop
   unzip /tmp/cart.zip
   mv cart-main cart
   cd cart
   npm install
