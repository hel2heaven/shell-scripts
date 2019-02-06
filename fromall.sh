#!/bin/bash

for ip in $*
do
sshpass -p group@10798 scp -r root@192.168.100.$ip:/home/shareindia/Algowire/Tachyon/TAP_Live/Backup10072018 /mktdata1/DailyLogs/$ip/
#sshpass -p group@10798 scp -r root@192.168.100.$ip:/home/shareindia/Algowire/Tachyon/Live/sh$ip.txt /home/chandan/turnover/T14122017/
echo "copied from "$ip
done

