#!/bin/bash
var1=$(cat /home/chandan/serverscenter | head -2 | tail -1)
#for ip in $var1
for ip in $@
#32 40 44 51 55 56 62 65 67 70 85 88 91 123 124 41 125 6 35 36 43 61 63 71 73 75 77 78 90 113 114 116 117 118 119 120 121 122 133 134 5 15 20 21 22 24 46 60 69 81 83 84 87 89 127 153 154 155 156 157
do
 sshpass -p group@10798 scp /home/chandan/AlgoIdList_CM.py root@192.168.100.$ip:/home/shareindia/Algowire/Tachyon/TAP_Live/Backup28012019*
 sshpass -p group@10798 scp /home/chandan/AlgoIdList.py root@192.168.100.$ip:/home/shareindia/Algowire/Tachyon/TAP_Live/Backup28012019*
 #sshpass -p group@10798 ssh root@192.168.100.$ip sed -i s/maxtries=1200/maxtries=1500/g' /root/runTachyon*
 #sshpass -p group@10798 ssh 192.168.100.$ip [ -f DPRContract_Index_N.py ]
 #if [[ $? == 0 ]];then
  #echo "DPRSecurity_N.py exist in "$ip
 #else
  #echo "DPRSecurity_N.py doesn't exist in "$ip
 #fi
 #sleep 1
done
