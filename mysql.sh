#!/bin/bash

LOGS_FOLDER="/var/log/expense-shell"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIMESTAMP=$(date +%Y-%m-%d_%H-%M-%S)
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME/$TIMESTAMP.log"

mkdir -p "$LOGS_FOLDER/$SCRIPT_NAME"

echo "script is executed at:  $(DATE)"

USERID=$( id -u )
R="\e[31m"
G="\e[32m"
N="\e[0m"
    
VARMA(){
    if [ $1 -ne 0 ]
    then 
        echo "perform this activity of installation with the root priviliges"  &>>$LOG_FILE
        exit 1
    else
    echo "installed successfully"
    fi    
}

VARMA $USERID

SRIKAR(){
    if [ $1 -ne 0 ]
    then 
        echo -e " $2 is  $R failure $N"  &>>$LOG_FILE
        exit 1
    else 
        echo -e " $2 is  $G success $N"  &>>$LOG_FILE
    fi
}

dnf install mysql-server -y
SRIKAR $? "Installing mysql"

systemctl enable mysqld
SRIKAR $? "enabling mysql"

systemctl start mysqld
SRIKAR $? "starting mysql"


