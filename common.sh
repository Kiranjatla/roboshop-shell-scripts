
ID=$(id -u)
if [ ID -ne 0 ] ; then
echo you should run this script as root or with sudo privilages.
exit 1
fi
 statuscheck(){
   if [ $1 -eq 0 ] ; then
       echo -e status = "\e[32mSuccess\e[0m"
     else
       echo -e status = "\e[31mFailure\e[0m"
       exit 1
      fi
}