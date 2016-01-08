#!/bin/bash

./setdate_from_google

node /root/openbeelab-embedded-uploading/javascript/main.js

echo chemin wakeup_ena `which wakeup_ena` > /root/plan_reboot.log 2>&1
if [ ! -f /sys/class/rtc/rtc0/wakealarm ]; then
    echo "le chemin vers le fichier wakealarm n'existe pas!" >> /root/plan_reboot.log 2>&1
fi

node /root/openbeelab-embedded-uploading/javascript/plan_reboot.js >> /root/plan_reboot.log 2>&1
