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

dnf install nginx -y   &>>$LOG_FILE
SRIKAR $? "installed Nginx"

systemctl enable nginx
SRIKAR $? "enabled nginx"

systemctl start nginx
SRIKAR $? "started nginx"

rm -rf /usr/share/nginx/html/*
SRIKAR $? "removed current code"

curl -o /tmp/frontend.zip https://expense-builds.s3.us-east-1.amazonaws.com/expense-frontend-v2.zip
SRIKAR $? "downloaded the code"

cd /usr/share/nginx/html

unzip /tmp/frontend.zip
SRIKAR $? "unzip the code"

cp /home/ec2-user/expense-shell/expense.conf /etc/nginx/default.d/expense.conf
SRIKAR $? "copied it"

systemctl restart nginx
SRIKAR $? "restarted nginx"