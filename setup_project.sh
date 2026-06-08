#!/bin/bash

echo "Deploying  is  starting"
echo "checking  if  python3  is  installed...."



if python3 --version;then
	echo "python3  is installed moving forward"
else
	echo "python3  not  found ,  you  can  install  it  first  by  running  sudo  apt  install  python3"
fi


echo "Doing the  creation  of  the  workspace"
read -p "Enter a  unique  folder  name: " folder
name="attendance_tracker_$folder"
if [ -d $name ];then
	echo "exists"
else
mkdir -p "$name"
mkdir -p "$name/Helpers"
mkdir -p "$name/reports"
echo "Parent directory and files  created for the  workspaces"
touch "$name/attendance_checker.py"
touch "$name/Helpers/assets.csv"
touch "$name/Helpers/config.json"
touch "$name/reports/reports.log"
fi
