#!/bin/bash
incomplete() {
echo " interrupt detected "
echo " cleanning  up  ... "
	if [ -d $name ];then
	tar cf "${name}_archive.tar.gz" "$name"
	rm -rf "$name"
	echo "Incompleted structure  removed"
	fi
	exit 1
}
trap incomplete SIGINT




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
sleep 2
echo "Parent directory and files  created for the  workspaces"
	cp attendance_checker.py "$name/"
	cp assets.csv             "$name/Helpers/"
	cp config.json            "$name/Helpers/"
	cp reports.log            "$name/reports/"
sleep 2
fi

read -p "Do you want to update the attendance thresholds? (y/n): " choice
if [ "$choice" = "y" ]; then
        read -p "Enter Warning threshold in %:  " warning
        read -p "Enter Failure threshold %: " failure
        sed -i "s/75/$warning/" "$name/Helpers/config.json"
        sed -i "s/50/$failure/" "$name/Helpers/config.json"
        echo "Threshold modified"
fi

echo "Creation of $name successfully "
exit 0
