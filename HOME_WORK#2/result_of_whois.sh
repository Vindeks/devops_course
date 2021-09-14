#!/bin/bash
IFS=$'\n'

process=$1
status=$2
parameter=$3
count=$4

if [ $# -eq 0 ]; then
  echo "No arguments. See help -   /bin/bash result_of_whois.sh help"
  exit
fi


if [ $# -eq 1 ] && [ $process == "help" ]; then
  echo "usage: /bin/bash result_of_whois.sh [parameter_1] [parameter_2] [parameter_3] [parameter_4]
  
        [parameter_1]              process name or pid of network connection (example: chrome)
        [parameter_2]              connection state, use one parameter (you should use the following values:
                                   - closed
                                   - established
                                   - close_wait
                                   - listen
                                   - time_wait)
        [parameter_3]              output parameters of command 'whois', use one parameter (example: Organization, OrgName)
        [parameter_4]              number of lines of connections to display"
  exit
fi


if [ -z "$2" ] || [ -z "$3" ] || [ -z "$4" ]; then
  echo "You have not entered all the arguments. See help -   /bin/bash result_of_whois.sh help"
  exit
else 
    reset=1
    for var in closed established close_wait listen time_wait 
        do
            if [ $status == $var ]; then
                reset=0
                break
            fi
        done
    if [ $reset == 1 ]; then
        echo "Connection status entered incorrectly. See help -   /bin/bash result_of_whois.sh help"
        exit
    fi
    re='^[0-9]+$'
    if ! [[ $count =~ $re ]]; then
        echo "Row count value must be a number. See help -   /bin/bash result_of_whois.sh help" 
        exit
    fi
    
fi

uniq_ip="$(netstat -tunapl |& grep -i $status | awk "/$process/ {print \$5}" | cut -d: -f1 | sort | uniq -c | sort )" 
uniq_ip2="$(echo "${uniq_ip}" | tail -n$count)" 
for IP in $(echo "$uniq_ip2")
do 
    IP_ORG="$(echo $IP | grep -oP '(\d+\.){3}\d+')"  
    amount_connect="$(echo $IP | awk -F' ' '{print $1}')"
    if [ -n $IP_ORG ]; then   
        organization="$(whois $IP_ORG | awk -F':' "/^$parameter/ {print \$2}" | sed -e 's/^ *//')"
        if [ "$organization" ]; then
            for i in $organization
            do
                length=$((16-"$(expr length $IP_ORG)"))
                echo  "amount of connections=$amount_connect   ip=$IP_ORG"  `printf '%*s' $length`  "parameter_of_whois:$parameter= $i" 
            done
        fi
    fi
done
