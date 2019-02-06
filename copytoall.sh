#!/bin/bash

if [[ $1 == "help" || $1 == "HELP" || $1 == "man"  || $1 == "MAN"  ]]; then
echo "Help              Print the help or manual details"
echo "                  ./copytoall.sh "
echo "                  copy contract.txt and security.txt into all selected Servers"
echo "                  No other arguments are required"
exit
fi

var1=$(sshpass -p group@10798 ssh 192.168.100.32 cat runTachyon | grep -i dprc | head -1 | cut -d ' ' -f2-)
cd /home/shareindia
./DPRContract_Index_N.py $var1
./DPRSecurity_N.py 50
sleep 2
#exit

#for ip in $*
allservers=$(cat /home/chandan/serverscenter | head -2 | tail -1)
for ip in $allservers
#for ip in 118
#32 40 44 51 55 56 62 65 67 70 85 88 91 123 124 41 125 6 35 36 43 61 63 71 73 75 77 78 90 113 114 116 117 118 119 120 121 122 134 5 15 20 21 22 24 46 60 69 81 83 84 87 89 127 153 154 155 156 157
do
sshpass -p group@10798 scp /home/shareindia/contract.txt root@192.168.100.$ip:/home/shareindia/Algowire/Tachyon/Live/Configuration/
sshpass -p group@10798 scp /home/shareindia/security.txt root@192.168.100.$ip:/home/shareindia/Algowire/Tachyon/Live/Configuration/
#sshpass -p group@10798 scp /home/shareindia/spd_contract.txt root@192.168.100.$ip:/home/shareindia/Algowire/Tachyon/Live/Configuration/
if [[ $ip == 41 || $ip == 118 || $ip == 124 || $ip == 125 ]] || [[ $ip == 127 ]];then
 for n in 1 2
 do
  sshpass -p group@10798 scp /home/shareindia/security.txt root@192.168.100.$ip:/home/shareindia/Algowire/Tachyon/Live_"$n"/Configuration/
  sshpass -p group@10798 scp /home/shareindia/contract.txt root@192.168.100.$ip:/home/shareindia/Algowire/Tachyon/Live_"$n"/Configuration/
  #sshpass -p group@10798 scp /home/shareindia/spd_contract.txt root@192.168.100.$ip:/home/shareindia/Algowire/Tachyon/Live_"$n"/Configuration/
  echo "$ip"_"$n"
 done
fi
echo "$ip"

done

