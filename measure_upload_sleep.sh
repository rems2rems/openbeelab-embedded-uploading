#!/bin/bash

#script a lancer dans le cron avec : > /root/mesure.log 2>&1

./setdate_from_google

node /root/openbeelab-embedded-uploading/javascript/main.js

echo chemin wakeup_ena `which wakeup_ena`
if [ ! -f /sys/class/rtc/rtc0/wakealarm ]; then
    echo "le chemin vers le fichier wakealarm n'existe pas!"
fi

node /root/openbeelab-embedded-uploading/javascript/plan_reboot.js
