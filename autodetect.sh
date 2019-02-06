#!/bin/bash
echo "Processing...."
rm -f allerrors.txt && touch allerrors.txt

auto_check()
{
#do 
 if [[ $ip == "41" ]] || [[ $ip == "124" ]] || [[ $ip == "125" ]] || [[ $ip == "118" ]] || [[ $ip == "127" ]];then
  for n in 1 2
  do
   ifile="/home/shareindia/Algowire/Tachyon/Live_"$n"/putty.log"
   sshpass -p group@10798 ssh 192.168.100."$ip" cat $ifile | egrep -aqi "History Download Not Completed Yet|Previous packet not captured|stucked in handletrade|box signoff|RMS Disconnected|beyond range|instrument deactivated|SecurityUpdate Pending|Pattern space not found|Sequence Mismatch in Stream"
   if [[ $? == 0 ]];then
    rm -f allerrors_"$ip"_"$n".txt 
    echo "$ip"_"$n" > allerrors_"$ip"_"$n".txt
    sshpass -p group@10798 scp root@192.168.100."$ip":"$ifile" /home/chandan/error_"$ip"_"$n".log

    ntimes=$(cat /home/chandan/error_"$ip"_"$n".log | egrep -ai "History Download Not Completed Yet" | wc -l)
    if [[ "$ntimes" -ge 5 ]]; then
     echo "History Download Not Completed Yet("$ntimes")" >> allerrors_"$ip"_"$n".txt
    fi

    ntimes=$(cat /home/chandan/error_"$ip"_"$n".log | egrep -ai "Previous packet not captured" | wc -l)
    if [[ "$ntimes" -ge 1 ]]; then
     echo "Previous packet not captured("$ntimes")" >> allerrors_"$ip"_"$n".txt
    fi

    ntimes_stucked=$(cat /home/chandan/error_"$ip"_"$n".log | egrep -ai "stucked in handletrade" | wc -l)
    if [[ "$ntimes_stucked" -ge 5 ]];then
     echo "Stucked("$ntimes_stucked")" >> allerrors_"$ip"_"$n".txt
    fi

    egrep -iwq "box signoff" /home/chandan/error_"$ip"_"$n".log > /dev/null
    if [[ $? == 0 ]];then
     nboxs=$(cat /home/chandan/error_"$ip"_"$n".log | grep -iaw "Box Signoff" | wc -l)
     nlogin=$(cat /home/chandan/error_"$ip"_"$n".log | grep -aw "Login Done" | wc -l)
     plus1=`expr $nboxs + 1`
     if [[ $nlogin == $plus1 ]];then
      echo ' '
     else
      echo "Box Signoff" >> allerrors_"$ip"_"$n".txt 
     fi
    fi

   egrep -iwq "RMS Disconnected" /home/chandan/error_"$ip"_"$n".log > /dev/null
   if [[ $? == 0 ]];then
    ndisc=$(cat /home/chandan/error_"$ip"_"$n".log | grep -iaw "RMS Disconnected" | wc -l)
    nconn=$(cat /home/chandan/error_"$ip"_"$n".log | grep -iaw "RMS Connected" | wc -l)
    nboth=`expr $ndisc + 1`
    if [[ $nconn == $nboth ]];then
     echo " "
    else
     echo "RMS Disconnected" >> allerrors_"$ip"_"$n".txt
    fi
   fi

   #egrep -iwq "Beyond Range" /home/chandan/error_"$ip"_"$n".log > /dev/null
   brtimes=$(cat /home/chandan/error_"$ip"_"$n".log | egrep -ai "Beyond Range" | wc -l)
   if [[ $brtimes -ge 1 ]];then
    echo "Beyond Range("$brtimes")" >> allerrors_"$ip"_"$n".txt
   fi

   #egrep -iwq "Instrument Deactivated" /home/chandan/error_"$ip"_"$n".log > /dev/null
   idtimes=$(cat /home/chandan/error_"$ip"_"$n".log | egrep -ai "Instrument Deactivated" | wc -l)
   if [[ $idtimes -ge 1 ]];then
    echo "Inst. Deactivated("$idtimes")" >> allerrors_"$ip"_"$n".txt
   fi
   sptimes=$(cat /home/chandan/error_"$ip"_"$n".log | egrep -ai "SecurityUpdate Pending" | wc -l)
   if [[ "$sptimes" -ge 5 ]];then
    echo "Sec_upd pending("$sptimes")" >> allerrors_"$ip"_"$n".txt
   fi
   pstimes=$(cat /home/chandan/error_"$ip"_"$n".log | egrep -ai "Pattern space not found" | wc -l)
   if [[ "$pstimes" -ge 5 ]];then
    echo "Pattern Space("$pstimes")" >> allerrors_"$ip"_"$n".txt
   fi
   smmtimes=$(cat /home/chandan/error_"$ip"_"$n".log | egrep -ai "Sequence Mismatch in Stream" | wc -l)
   if [[ "$smmtimes" -ge 5 ]];then
    echo "Sequence Mismatch("$smmtimes")" >> allerrors_"$ip"_"$n".txt
   fi



 paste -sd '\t' allerrors_"$ip"_"$n".txt >> allerrors.txt
 fi
 done

else


ifile="/home/shareindia/Algowire/Tachyon/Live/putty.log"
sshpass -p group@10798 ssh 192.168.100."$ip" cat $ifile | egrep -aqi "History Download Not Completed Yet|Previous packet not captured|stucked in handletrade|box signoff|RMS Disconnected|beyond range|instrument deactivated|SecurityUpdate Pending|Pattern space not found|Sequence Mismatch in Stream"
if [[ $? == 0 ]];then
 rm -f allerrors_"$ip".txt
 echo "$ip" > allerrors_"$ip".txt
 sshpass -p group@10798 scp root@192.168.100."$ip":"$ifile" /home/chandan/error_"$ip".log

 ntimes=$(cat /home/chandan/error_"$ip".log | egrep -ai "History Download Not Completed Yet" | wc -l)
 if [[ "$ntimes" -ge 5 ]]; then
  echo "History Download Not Completed Yet("$ntimes")" >> allerrors_"$ip".txt
 fi
 ntimes=$(cat /home/chandan/error_"$ip".log | egrep -ai "Previous packet not captured" | wc -l)
 if [[ "$ntimes" -ge 1 ]]; then
  echo "Previous packet not captured("$ntimes")" >> allerrors_"$ip".txt
 fi

 ntimes_stucked=$(cat /home/chandan/error_"$ip".log | egrep -ai "stucked in handletrade" | wc -l)
 if [[ "$ntimes_stucked" -ge 5 ]];then
  echo "Stucked("$ntimes_stucked")" >> allerrors_"$ip".txt
 fi

 egrep -iwq "box signoff" /home/chandan/error_"$ip".log > /dev/null
 if [[ $? == 0 ]];then
  nboxs=$(cat /home/chandan/error_"$ip".log | grep -iaw "Box Signoff" | wc -l)
  nlogin=$(cat /home/chandan/error_"$ip".log | grep -aw "Login Done" | wc -l)
  plus1=`expr $nboxs + 1`
  if [[ $nlogin == $plus1 ]];then
   echo ' '
  else
   echo "Box Signoff" >> allerrors_"$ip".txt
   #sshpass -p group@10798 ssh root@192.168.100."$ip" /root/./killTachyon
   #sleep 1
   #sshpass -p group@10798 ssh root@192.168.100."$ip" /home/shareindia/Algowire/Tachyon/TAP_Live/./downloadBackup_2.0 > /dev/null 
  fi
 fi

 egrep -iwq "RMS Disconnected" /home/chandan/error_"$ip".log > /dev/null
 if [[ $? == 0 ]];then
  ndisc=$(cat /home/chandan/error_"$ip".log | grep -iaw "RMS Disconnected" | wc -l)
  nconn=$(cat /home/chandan/error_"$ip".log | grep -iaw "RMS Connected" | wc -l)
  nboth=`expr $ndisc + 1`
  if [[ $nconn == $nboth ]];then
   echo " "
  else
   echo "RMS Disconnected" >> allerrors_"$ip".txt
  fi
 fi

 #egrep -iwq "Beyond Range" /home/chandan/error_"$ip".log > /dev/null
 brtimes=$(cat /home/chandan/error_"$ip".log | egrep -ai "Beyond Range" | wc -l)
 if [[ $brtimes -ge 1 ]];then
  echo "Beyond Range("$brtimes")" >> allerrors_"$ip".txt
 fi

 #egrep -iwq "Instrument Deactivated" /home/chandan/error_"$ip".log > /dev/null
 idtimes=$(cat /home/chandan/error_"$ip".log | egrep -ai "Instrument Deactivated" | wc -l)
 if [[ $idtimes -eq 1 ]];then
  echo "Inst. Deactivated("$idtimes")" >> allerrors_"$ip".txt
 fi
 sptimes=$(cat /home/chandan/error_"$ip".log | egrep -ai "SecurityUpdate Pending" | wc -l)
 if [[ "$sptimes" -ge 5 ]];then
  echo "Sec_upd pending("$sptimes")" >> allerrors_"$ip".txt
 fi
 pstimes=$(cat /home/chandan/error_"$ip".log | egrep -ai "Pattern space not found" | wc -l)
 if [[ "$pstimes" -ge 5 ]];then
  echo "Pattern Space("$pstimes")" >> allerrors_"$ip".txt
  #sshpass -p group@10798 ssh root@192.168.100."$ip" /home/shareindia/Algowire/Tachyon/TAP_Live/./downloadBackup_2.0 publish &
 fi
 smmtimes=$(cat /home/chandan/error_"$ip".log | egrep -ai "Sequence Mismatch in Stream" | wc -l)
 if [[ "$smmtimes" -ge 5 ]];then
  echo "Sequence Mismatch("$smmtimes")" >> allerrors_"$ip".txt
 fi




paste -sd '\t' allerrors_"$ip".txt >> allerrors.txt

fi
fi

#done
}

if [[ "$#" -ge 1 ]];then
 for ip in $@
 do
  auto_check
 done
else
 for ip in 41 118 124 125 127 32 44 65 67 70 85 88 120 123 6 35 36 43 51 56 61 62 63 71 73 75 77 78 90 91 113 114 116 117 119 121 122 134 149 153 154 156 157 5 15 20 21 22 24 46 60 69 81 83 84 87 89 55 155 161 137 40 139 128 72
 do
  auto_check
 done
fi

cat allerrors.txt
