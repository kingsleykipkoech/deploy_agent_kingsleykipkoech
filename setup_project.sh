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
name="attendance_tracker_{$folder}"
mkdir -p "$folder"
mkdir -p "$folder/Helpers"
mkdir -p "$folder/reports"
echo "Parent directory and files  created for the  workspaces"

