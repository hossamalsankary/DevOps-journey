#! /bin/bash
function showMessage() {
    colorName=$1
    message=$2
    bold="\e[1m"
    reset="\e[0m"

    case $colorName in

    red) color="\e[0;91m" ;;
    blue) color="\e[0;94m" ;;
    *) color="\e[0;94m" ;;

    esac

    echo -e "${color} ${bold} ${message} ${reset}"

}

function checkIfTheServiceIsActive() {
    serviceName=$1
    checkServiceStatus=$(systemctl is-active $serviceName)

    if [ $checkServiceStatus = "active" ]; then
        showMessage "blue" "service $serviceName Is active mood"

    elif [ $checkServiceStatus = "inactive" ]; then
        showMessage "red" "service $serviceName Is inactive mood"
    else
        showMessage "red" "Some thing Went Wrong"
    fi
}

# function isThePortConf(){
#  iSportOpen=$(sudo firewall-cmd --list-ports)
 
#  if [[ $iSportOpen = "*$1*" ]]
  
#  then

#     showMessage "blue" "This port is exist"
 
#  else
#      showMessage "red" "This port is not exist"

#  fi

# }

echo "----------------------Deploy Pre-Requisites --------------------------------- "
yum install -y firewalld > input
 service firewalld start
 systemctl enable firewalld
checkIfTheServiceIsActive "firewalld"

echo "----------------------Deploy and Configure Database --------------------------
"
 yum install -y mariadb-server >> input
 service mariadb start
 systemctl enable mariadb
checkIfTheServiceIsActive "mariadb"

echo "-----------------------Configure firewall for Database-------------------------"
 firewall-cmd --permanent --zone=public --add-port=3306/tcp

if  $( firewall-cmd --permanent --zone=public --add-port=3306/tcp ) 
  
 then

     showMessage "blue" "port configure !"
     firewall-cmd --reload
 
 else
     showMessage "red" "This port is no exist"

 fi


 #----------------------- Configure Database -------------------------
 echo  "----------------------- Configure Database ------------------------- "
 mysql -e "CREATE DATABASE ecomdb; CREATE USER 'ecomuser'@'localhost' IDENTIFIED BY 'ecompassword';
 GRANT ALL PRIVILEGES ON *.* TO 'ecomuser'@'localhost'; FLUSH PRIVILEGES;"