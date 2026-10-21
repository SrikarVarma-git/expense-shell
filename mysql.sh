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

dnf install mysql-server -y
SRIKAR $? "Installing mysql"   

systemctl enable mysqld
SRIKAR $? "enabling mysql"    

systemctl start mysqld
SRIKAR $? "starting mysql"

mysql -h mysql.daws81s.store -u root -p<ExpenseApp@1> -e 'show databases;'  &>>$LOG_FILE

if [ $? -ne 0 ]
then 
    echo "need to set the password, if it is not set"   &>>$LOG_FILE
    mysql_secure_installation --set-root-pass ExpenseApp@1
    SRIKAR $? "setting up the password"
else
    echo "the password has been already set, so skipping "   | tee -a $LOG_FILE   
fi


