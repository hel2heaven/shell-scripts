#!/bin/bash

sshpass -p group@10798 scp root@192.168.100.5:/home/shareindia/Algowire/ServerRatio/Ratio_$(date +%d%m%Y)/* /home/chandan/turnover/T$(date +%d%m%Y)/
cd /home/chandan/turnover/T$(date +%d%m%Y)/

#####IOC SERVERS####

for ip in 6 18 32 40 51 56 60 61 62 63 65 67 69 70 71 72 73 75 77 78 88 89 90 91 113 114 116 117 118 119 120 121 122
do
  ipfile1=shareindia$ip
  if [[ -f "${ipfile1}" ]];then
	echo $ip > sh$ip.txt
	cat shareindia$ip | grep "Total_Fut_Turn_Over" | cut -c22- >>sh$ip.txt
	cat shareindia$ip | grep "Total_Option_Turn_Over" | cut -c25- >>sh$ip.txt
	echo 0 >>sh$ip.txt
	cat shareindia$ip | grep "FO_Order Entry" | cut -c17- >>sh$ip.txt
	cat shareindia$ip | grep "FO_SPD Order Entry" | cut -c21- >>sh$ip.txt
	cat shareindia$ip | grep "FO_Trade" | cut -c11- >>sh$ip.txt
  else 
  	ipfile2=sh$ip.txt
	if [[ -f "${ipfile2}" ]];then
	  echo $ipfile2 already exists
	  sed -i '8,$ d' sh$ip.txt
          echo 0 >>sh$ip.txt
          echo 0 >>sh$ip.txt
	  var1=$(head -5 sh$ip.txt | tail -1)
	  var2=$(head -6 sh$ip.txt | tail -1)
	  var3=$(head -7 sh$ip.txt | tail -1)
	  var4=$(echo "($var3-$var1)/($var2)*100" | bc -l | cut -c1-4)
	  echo $var4 >>sh$ip.txt
	  echo $(date +%d/%m/%Y) >>sh$ip.txt	
	else
	  echo no file exists for server $ip
	fi
  fi
done

#####BID SERVERS#####
for ip in 5 15 20 21 22 55 81 84
do
	echo $ip > sh$ip.txt
	cat shareindia$ip | grep "Total_Fut_Turn_Over" | cut -c22- >>sh$ip.txt
	echo 0 >>sh$ip.txt
	cat shareindia$ip | grep "Total_Cash_Turn_Over" | cut -c23- >>sh$ip.txt
	cat shareindia$ip | grep "FO_Order Entry" | cut -c17- >>sh$ip.txt
	cat shareindia$ip | grep "FO_SPD Order Entry" | cut -c21- >>sh$ip.txt
	cat shareindia$ip | grep "FO_Trade" | cut -c11- >>sh$ip.txt
	cat shareindia$ip | grep "CM_Order Entry" | cut -c17- >>sh$ip.txt
	cat shareindia$ip | grep "CM_Trade" | cut -c11- >>sh$ip.txt
	echo 0 >>sh$ip.txt
	echo $(date +%d/%m/%Y) >>sh$ip.txt
done
sleep 2

echo -e Server,FUT,OPTION,CASH,FO_ORDER,FO_SPD_Ordr,FO_TRADE,CM_ORDER,CM_TRADE,Ratio %,Date,NSE stock fut= > /home/chandan/turnover/T$(date +%d%m%Y).csv

for ip in 5 6 15 18 20 21 22 32 40 51 55 56 60 61 62 63 65 67 69 70 71 72 73 75 77 78 81 84 88 89 90 91 113 114 116 117 118 119 120 121 122
do
	paste -sd ',' sh$ip.txt >> /home/chandan/turnover/T$(date +%d%m%Y).csv
done


mount -t cifs //192.168.102.50/share /home/chandan/mounted -o username=admin,password=startingmywork
sleep 1
echo Copying...
cp /home/chandan/turnover/T$(date +%d%m%Y).csv /home/chandan/mounted/Turnovers/Dec
echo Done
umount /home/chandan/mounted

