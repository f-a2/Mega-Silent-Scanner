#!/bin/bash

# دالة الألوان
change_colors() {
    while true; do
        colors=(31 32 33 34 35 36 37)
        echo -ne "\e[1;${colors[$RANDOM % 7]}m"
        sleep 0.5
    done
}

clear
echo -e "\e[1;36m=========================================="
echo "          MEGA SILENT SCANNER v3.0        "
echo "      Admin, Shells & Vuln Hunting        "
echo "==========================================\e[0m"

# طلب الهدف (تأكد تكتب النطاق بدون http)
echo -ne "\e[1;33m[?] Enter Domain/IP (e.g., google.com): \e[0m"
read target

if [ -z "$target" ]; then exit; fi

# تنظيف الرابط لو المستخدم حط http بالخطأ
target=$(echo $target | sed -e 's|^[^/]*//||' -e 's|/.*$||')

change_colors &
COLOR_PID=$!

echo -e "\n\e[1;31m[!] Launching Bruteforce & Vuln Scan on: $target\e[0m"
echo "------------------------------------------"

# الفحص المرعب:
# -sV: نوع السيرفر وإصداره
# -p 80,443,21,22,3306,8080: منافذ خطيرة
# --script=vuln,http-enum: البحث عن الثغرات وتخمين المجلدات (آدمن، شلات)
(sudo nmap -sV -Pn --script=vuln,http-enum,http-title $target > mega_result.txt 2>/dev/null) &
SCAN_PID=$!

while kill -0 $SCAN_PID 2>/dev/null; do
    echo -ne "\r\e[1;32m[ / ] Hunting Shells & Admin Panels... " ; sleep 0.1
    echo -ne "\r\e[1;34m[ - ] Analyzing Server Type... " ; sleep 0.1
    echo -ne "\r\e[1;35m[ \\ ] Checking Critical Ports... " ; sleep 0.1
    echo -ne "\r\e[1;31m[ | ] Searching for Vulnerabilities... " ; sleep 0.1
done

kill $COLOR_PID
echo -e "\e[0m" 

echo -e "\n\e[1;32m[✔] FULL AUDIT COMPLETED!\e[0m"
echo "------------------------------------------"
cat mega_result.txt
