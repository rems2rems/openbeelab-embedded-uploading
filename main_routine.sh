#!/bin/bash

#script a lancer dans le cron avec : > /root/mesure.log 2>&1

./setdate_from_google

node /root/openbeelab-embedded-uploading/javascript/main.js

node /root/openbeelab-embedded-uploading/javascript/util/plan_reboot.js
