#!/bin/bash

errormsg(){
    if [[ $? -ne 0]]; then
    echo "ERROR: For more information , please check the log file" 
    exit 1; 
    fi

}

#
current_date=$(date + %Y-%m-%d %H:%M:%S)

#Creating a logs files  for the script execution and errors.
readonly LOG_FILE=/var/log/tomcatconfig.log
readonly ERROR_FILE=/var/log/tomcaterrorlogs.log

{

echo "-------------------------------------------------------------------"
echo "     This Bash Script was excecuted at $current_date              "
echo "-------------------------------------------------------------------"

}>>"$LOG_FILE"



#change the hostname of EC2
sudo  hostnamectl set-hostname tomcat


{
sudo apt update -y && sudo apt upgrade -y

}>> /dev/null 2>$ERROR_FILE

errormsg



{

cd /opt|| { echo "Unable to log into /opt" | tee -a "$ERROR_FILE" }

#installing java development kit 
echo "-------------------------------------------------------------------"
echo "                      INSTALLING JAVA-JDK               "
echo "-------------------------------------------------------------------"

sudo apt install default-jdk -y  >>  /dev/null 2>$ERROR_FILE
errormsg

#log the java-jdk version into the $LOG_FILE
{

echo "-------------------------------------------------------------------"
echo "                      JAVA-JDK  VERSION               "
echo "-------------------------------------------------------------------"
    java -version


} >> $LOG_FILE 2>> "$ERROR_FILE"

errormsg

echo "-------------------------------------------------------------------"
echo "                      INSTALLING TOMCAT                "
echo "-------------------------------------------------------------------"
#Installing and extracting Apache tomcat 
sudo wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.85/bin/apache-tomcat-9.0.85.tar.gz && sudo tar -xzvf apache-tomcat-9.0.85.tar.gz  >> "$LOG_FILE" 2>>"$ERROR_FILE"


{ 
    sudo rm -rf apache-tomcat-9.0.85.tar.gz && sudo mv apache-tomcat-9.0.85/ tomcat9 

} 2>> "$ERROR_FILE" 

errormsg

}

sudo chmod 777 -R /opt/tomcat9

{

sudo ln -s /opt/tomcat9/bin/startup.sh /usr/bin/starttomcat
sudo ln -s /opt/tomcat9/bin/shutdown.sh /usr/bin/stoptomcat

sudo starttomcat

} 2>>"$ERROR_FILE"
