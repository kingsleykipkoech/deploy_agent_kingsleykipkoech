#!/bin/bash
interrupt() {
	echo " interrupt detected "
	echo " cleanning  up  ... "
	if [ -d "$name" ];then
	tar cf "${name}_archive.tar" "$name"
	rm -rf "$name"
	echo "Incompleted structure  removed"
	fi
	exit 1
}
trap interrupt SIGINT
#THIS  IS  THE  INSTRUCTION  THE  PROGRAM  WILL FOLLOW, THATS  WHY  ITS  AT THE  TOP



echo "Loading......."
sleep 0.5
echo "checking  if  python3  is  installed...."
sleep 1
if python3 --version;then
	echo "python3  is installed moving forward"
else
	echo "python3  not  found ,  you  can  install  it  first  by  running  sudo  apt  install  python3"
fi


echo "Creating the workspace"
read -p "Enter the desired folder  name: " folder
name="attendance_tracker_$folder"
if [ -d "$name" ];then
	echo " \"$name\" exists"
else
	mkdir -p "$name"
	mkdir -p "$name/Helpers"
	mkdir -p "$name/reports"
sleep 2
echo "Parent directory and files  created for the  workspaces"

# creating attendance_checker.py file
cat > "$name/attendance_checker.py" << 'EOF'
import csv
import json
import os
from datetime import datetime

def run_attendance_check():
    # 1. Load Config
    with open('Helpers/config.json', 'r') as f:
        config = json.load(f)
    
    # 2. Archive old reports.log if it exists
    if os.path.exists('reports/reports.log'):
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        os.rename('reports/reports.log', f'reports/reports_{timestamp}.log.archive')

    # 3. Process Data
    with open('Helpers/assets.csv', mode='r') as f, open('reports/reports.log', 'w') as log:
        reader = csv.DictReader(f)
        total_sessions = config['total_sessions']
        
        log.write(f"--- Attendance Report Run: {datetime.now()} ---\n")
        
        for row in reader:
            name = row['Names']
            email = row['Email']
            attended = int(row['Attendance Count'])
            
            # Simple Math: (Attended / Total) * 100
            attendance_pct = (attended / total_sessions) * 100
            
            message = ""
            if attendance_pct < config['thresholds']['failure']:
                message = f"URGENT: {name}, your attendance is {attendance_pct:.1f}%. You will fail this class."
            elif attendance_pct < config['thresholds']['warning']:
                message = f"WARNING: {name}, your attendance is {attendance_pct:.1f}%. Please be careful."
            
            if message:
                if config['run_mode'] == "live":
                    log.write(f"[{datetime.now()}] ALERT SENT TO {email}: {message}\n")
                    print(f"Logged alert for {name}")
                else:
                    print(f"[DRY RUN] Email to {email}: {message}")

if __name__ == "__main__":
    run_attendance_check()
EOF

#CONFIG.json file
cat > "$name/Helpers/config.json" << 'EOF'
{
    "thresholds": {
        "warning": 75,
        "failure": 50
    },
    "run_mode": "live",
    "total_sessions": 15
}
EOF

#assets.csv file
cat > "$name/Helpers/assets.csv" << 'EOF'
Names,Email,Attendance Count
Alice Johnson,alice@example.com,14
Bob Smith,bob@example.com,7
Charlie Davis,charlie@example.com,4
Diana Ross,diana@example.com,12
Edward King,edward@example.com,10
EOF

#reports.log file
cat > "$name/reports/reports.log" << 'EOF'
--- Attendance Report Run: 2026-02-06 18:10:01.468726 ---
[2026-02-06 18:10:01.469363] ALERT SENT TO bob@example.com: URGENT: Bob Smith, your
attendance is 46.7%. You will fail this class.
[2026-02-06 18:10:01.469424] ALERT SENT TO charlie@example.com: URGENT: Charlie
Davis, your attendance is 26.7%. You will fail this class
EOF

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
