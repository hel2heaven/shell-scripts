#!/bin/bash
cd /home/chandan

ver10=(6 35 36 51 62 61 71 73 77 78 90 113 114 116 117 119 122)
prim=(6 36 43 61 90 114 116 117 119 121 122)
sec=(35 51 62 63 71 73 75 77 78 113)

maxlines=$(cat /home/chandan/test_1/issues.txt | wc -l)
line=1
while [ $line -le $maxlines ]
 do
 target=$(cat /home/chandan/test_1/issues.txt | head -$line | tail -1 | cut -d ' ' -f1)
 if [[ $target =~ ^[0-9]+$ ]];then
  for i in ${ver10[@]}
  do
   if [[ $i == $target ]];then
    target_1=$(sshpass -p group@10798 ssh 192.168.100.$target cat /home/shareindia/Algowire/Tachyon/TAP_Live/switch_tap-tbt | grep ^primaryServer | cut -d '=' -f2)
    target_2=$(sshpass -p group@10798 ssh 192.168.100.$target cat /home/shareindia/Algowire/Tachyon/TAP_Live/switch_tap-tbt | grep ^secondaryServer | cut -d '=' -f2)
    sshpass -p group@10798 scp root@192.168.100."$target":/home/shareindia/Algowire/Tachyon/Live/putty.log ./morning_"$target"
    ptimes=$(cat morning_"$target" | grep -ai "PreLogin resp not rcv" | wc -l)
    if [[ $ptimes -ge 2 ]];then
	egrep -iwq "Login Done" morning_"$target" > /dev/null
	if [[ $? == 0 ]];then
	 break
	else
	 sshpass -p group@10798 ssh 192.168.100."$target" /root/./killTachyon
	 sshpass -p group@10798 ssh "$target_1" /root/./killTachyon
	 sleep 2
	 sshpass -p group@10798 ssh "$target_1" cr
	 sleep 2
	 sshpass -p group@10798 ssh "$target_1" cn
	 sshpass -p group@10798 ssh "$target_2" /root/./killTachyon
	 sshpass -p group@10798 ssh "$target_2" cn
	 sleep 60
	 nohup sshpass -p group@10798 ssh "$target_1" /root/./runTachyon > /dev/null 2>&1 &
	 nohup sshpass -p group@10798 ssh "$target_2" /root/./runTachyon > /dev/null 2>&1 &
	fi
   fi
   #echo $target" is ver10 !"
   fi
  done   
fi

line=$((line + 1))

done 

