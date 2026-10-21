#!/bin/bash

LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME/$TIMESTAMP.log"
DATE=$(date +%F)

mkdir -p "$LOGS_FOLDER/$SCRIPT_NAME"

echo "script is executed at:  $DATE"

USERID=$( id -u )
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
    
VARMA(){
    if [ $1 -ne 0 ]
    then 
        echo "perform this activity of installation with the root priviliges"  | tee -a $LOG_FILE
        exit 1
    else
    echo "installed successfully" | tee -a $LOG_FILE
    fi    
}

VARMA $USERID

SRIKAR(){
    if [ $1 -ne 0 ]
    then 
        echo -e " $2 is  $R failure $N"  | tee -a $LOG_FILE
        exit 1
    else 
        echo -e " $2 is  $G success $N" | tee -a $LOG_FILE
    fi
}

dnf module disable nodejs -y
SRIKAR $? "Nodejs disabled"

dnf module enable nodejs:20 -y
SRIKAR $? "Enabled nodejs 20"

dnf install nodejs -y
SRIKAR $? "installed nodejs"  


id expense   &>>$LOG_FILE
if [ $? -ne 0 ]
then 
    echo "create the user expense" 
    useradd expense
    SRIKAR $? "created user expense"
else
    echo -e "user expense is already created, so  $Y skip $N it"   | tee -a $LOG_FILE
fi


