#!/bin/bash

#------------------------------------------------------------------------------------------#

confile="/home/shareindia/Algowire/Tachyon/Live/Configuration/AllConfig.csv"
path1="/home/shareindia/Algowire/Tachyon/Live/Configuration"
path2="/home/shareindia/Algowire/Tachyon/TAP_Live"
#path3="/etc/sysconfig/network-scripts/"
vernature=$(cat /root/runTachyon | grep ^tach_profile | cut -d '=' -f2)
tap_ip=$(cat $confile | grep ^InteractiveIP | cut -d '=' -f2)
mainip=$(cat $confile | grep ^InteractiveIP | cut -d '=' -f2 | cut -d '.' -f1-3)
net_ip=$(cat $confile | grep ^NetworkIP | cut -d '=' -f2)
intpath="/etc/sysconfig/network-scripts/"
intfile=$(grep $mainip $intpath/ifcfg-* -l)
tbt_ip=$(cat $intfile | grep TMPIP | cut -d '=' -f2)
ipc12=$(cat $confile | grep ^InteractiveIP | cut -d '=' -f2 | cut -d '.' -f1-2)
pip=$(cat $path2/switch_tap-tbt | grep ^primary | cut -d '.' -f4)
#p9a16=$(cat $confile | grep ^InteractiveIP | cut -d '.' -f3)
p9a16=$(cat $confile | grep ^InteractiveIP | cut -d '=' -f2 | cut -d '.' -f3)
hostmac=$(cat $confile | grep ^HostMac.Hex | cut -d '=' -f2 | cut -d '.' -f3)
#------------------------------------------------------------------------------------------#

if [[ $vernature == "\"ioc_ver10-1"\" ]] || [[ $vernature == "\"ioc_ver10-2"\" ]] ; then
	echo "Configured Version is" $vernature
	echo ''
	echo "Do You Want to Switch to Non-v10 ??"
	echo "Hit [y/Y] or [n/N]"
	read input
	if [[ $input =~ ^[y/Y]$ ]];then
	 echo Switching.. 
#	 sed -i "s/$vernature/"\"ioc_test"\"/g" /root/runTachyon
	 sed -i "s/^TBTMcastOnlineInterfaceIp=$tbt_ip/TBTMcastOnlineInterfaceIp=$tap_ip/g" $confile
	 sed -i "s/^NetworkIP=$net_ip/NetworkIP=$tap_ip/g" $confile
	 cd $path2 && ./switch_tap-tbt forced_change_tap disable
	 sed -i "s/$vernature/"\"ioc_test"\"/g" /root/runTachyon
	 echo ''
	 echo ''
	 echo "**********Please ensure Version is Non-V10 in runTachyon !!**********"	
	 if [[ $p9a16 == 7 ]]; then
	  sed -i "s/^HostMac.Hex=$hostmac/"HostMac.Hex=00:2A:10:39:8B:01"/g" $confile
	  #echo "**********Since this server belongs to A16 Rack, please ensure Mac Addr in AllConfig file !!**********"
	 elif [[ $p9a16 == 133 ]]; then
	  sed -i "s/^HostMac.Hex=$hostmac/"HostMac.Hex=58:97:bd:73:9e:fc"/g" $confile
	  #echo "**********Since this server belongs to P9 Rack, please ensure Mac Addr in AllConfig file !!**********"
	 elif [[ $p9a16 == 16 ]]; then
	  sed -i "s/^HostMac.Hex=$hostmac/"HostMac.Hex=A8:9D:21:AB:46:81"/g" $confile
	  echo "**********Since this server belongs to AB15 Rack, please ensure Mac Addr in AllConfig file !!**********"
	 fi	 

	else
		exit
	fi

elif [[ $vernature == "\"ioc_test"\" ]]; then
	echo "Configured Version is "$vernature
	echo ''
	echo "Do You Want to Switch to v10 ??"
        echo "Hit [y/Y] or [n/N]"
        read input
        if [[ $input =~ ^[y/Y]$ ]];then
         echo "Switch for Primary or Secondary ??	[p/P] or [s/S]" 
	 read input
	 if [[ $input =~ ^[p/P]$ ]];then
	  echo Switching..
	  ipc3=$(hostname | cut -c11-)
	  sed -i "s/$vernature/"\"ioc_ver10-1"\"/g" /root/runTachyon
	  sed -i "s/^TBTMcastOnlineInterfaceIp=$tap_ip/TBTMcastOnlineInterfaceIp=$tbt_ip/g" $confile
	  sed -i "s/^NetworkIP=$net_ip/NetworkIP="$ipc12"."$ipc3".1/g" $confile
	  cd $path2 && ./switch_tap-tbt forced_change_tbt enable
	  echo ''
	  echo ''
	  echo "**********Please ensure Version is V10-Primary in runTachyon !!**********"

	 elif [[ $input =~ ^[s/S]$ ]];then
	  pip=$(cat $path2/switch_tap-tbt  | grep ^primary | cut -d '=' -f2 | cut -d '.' -f4)
	  sed -i "s/$vernature/"\"ioc_ver10-2"\"/g" /root/runTachyon
	  sed -i "s/^TBTMcastOnlineInterfaceIp=$tap_ip/TBTMcastOnlineInterfaceIp=$tbt_ip/g" $confile
	  sed -i "s/^NetworkIP=$net_ip/NetworkIP="$ipc12"."$pip".2/g" $confile
	  cd $path2 && ./switch_tap-tbt forced_change_tbt enable
          echo ''
          echo ''
          echo "**********Please ensure Version is V10-Secondary in runTachyon !!**********"
	  echo ''
	 fi
	if [[ $p9a16 == 7 ]]; then
	 sed -i "s/^HostMac.Hex=$hostmac/"HostMac.Hex=04:62:73:78:02:81"/g" $confile
         #echo "**********Since this server belongs to A16 Rack, please ensure Mac Addr in AllConfig file !!**********"
	 echo ''
        elif [[ $p9a16 == 133 ]]; then
	 sed -i "s/^HostMac.Hex=$hostmac/"HostMac.Hex=88:f0:31:c3:2e:c1"/g" $confile
	 #echo "**********Since this server belongs to P9 Rack, please ensure Mac Addr in AllConfig file !!**********"
 	 echo ''
	elif [[ $p9a16 == 16 ]]; then
	 sed -i "s/^HostMac.Hex=$hostmac/"HostMac.Hex=04:62:73:b1:2e:fc"/g" $confile
        fi

        else
                exit
        fi
	
else 
	echo "It's Different" $vernature
fi

