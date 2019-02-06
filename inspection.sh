#!/bin/bash
for ip in $*
do

echo "$ip"

#sshpass -p group@10798 scp /home/chandan/changetov10.sh root@192.168.100.$ip:/home/chandan/
#sshpass -p group@10798 ssh 192.168.100.$ip cat /home/shareindia/Algowire/Tachyon/Live/putty.log | grep -ai "sec_upd" | wc -l
#sshpass -p group@10798 ssh 192.168.100.$ip du -h /home/shareindia/Algowire/Tachyon/Live_2/putty.log
#sshpass -p group@10798 ssh 192.168.100.$ip head -n 1 /home/shareindia/Algowire/Tachyon/Live/Configuration/
##echo "$ip"_2
sshpass -p group@10798 ssh 192.168.100.$ip cat /home/shareindia/Algowire/Tachyon/Live/Configuration/AllConfig.csv | grep Password
#sshpass -p group@10798 ssh 192.168.100.$ip exanic-config | grep -i Hardware
#sshpass -p group@10798 ssh 192.168.100.$ip cat $ALLCONFIG | grep ^VersionNo
done

