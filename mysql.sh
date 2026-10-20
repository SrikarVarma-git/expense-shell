#!/bin/bash

USERID=$( id -u )
R="\e[31m"
G="\e[32m"
N="\e[0m"
    
VARMA(){
    if [ $1 -ne 0 ]
    then 
        echo "perform this activity of installation with the root priviliges"
        exit 1
    else
    echo "installed successfully"
    fi    
}

VARMA $USERID

SRIKAR(){
    if [ $1 -ne 0 ]
    then 
        echo -e " $2 is  $R failure $N"
        exit 1
    else 
        echo -e " $2 is  $G success $N"
    fi
}

dnf install mysql-server -y
SRIKAR $? "Installing mysql"

systemctl enable mysqld
SRIKAR $? "enabling mysql"

systemctl start mysqld
SRIKAR $? "starting mysql"


