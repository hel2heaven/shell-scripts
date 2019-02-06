#!/bin/bash

for arg in $@
do

if [[ $arg == "help" || $arg == "HELP" || $arg == "man"  || $arg == "MAN"  ]]; then
echo "Help 		Print the help or manual details"
echo "    		./killall "
echo "   		execute ./killTachyon script on all Servers"
echo "NOTE:-PLEASE MAKE SURE THE MARKET HOUR HAS BEEN CLOSED"
echo "    		No other arguments are required"
exit
else
echo "Invalid Argument for more use 'HELP' or 'MAN'"
exit
fi
done


clear
bold=$(tput bold)
normal=$(tput sgr0)
echo $bold

time=$(date +%k%M)
if [[ "$time" -lt 1559 ]];then
  echo && echo
echo -e "\e[0;30;43m WARNING\e[0;97;40m""\e[0;97;41m COMMAND CAN NOT BE EXECUTED\e[0;97;40m"
  echo && echo
   exit
elif [[ "$time" -ge 1510 ]];then
 echo && echo &&  echo -e "\e[0;97;42m KILLING ALL\e[0;97;40m" && echo && echo

for ip in 32 35 36 40 43 44 51 56 65 67 69 70 75 85 87 88 89 118 6 62 63 71 73 77 78 90 91 113 114 116 117 119 120 121 122 123 124 125 5 15 20 21 22 24 46 81 84 89 60 83 41 153 154 155 156 157 61 27 115 127
do
sshpass -p group@10798 ssh root@192.168.100.$ip pkill Tachyon
sshpass -p group@10798 ssh root@192.168.100.$ip pkill Arbitrage
#sshpass -p group@10798 ssh root@192.168.100.$ip /root/killTachyon
echo "done in" $ip
done
else
        echo "TRY AGAIN LATER"
exit 
fi

