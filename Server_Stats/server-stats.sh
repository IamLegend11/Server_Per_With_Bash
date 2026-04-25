#!/bin/bash

echo "Server performance stats."

CPU=$(ps aux)

echo "$CPU" | awk '{SUM+=$3} END {print "The total CPU Usage:",SUM"%"}'
echo "------------------------"

echo "Total memory usage:"
free |awk 'NR==2 {print"Used memory:",($3/$2)*100"%","\nFree Memory:",($4/$2)*100"%"}'

echo -e "-----------------------\nTotal disk usage:"
df |awk 'BEGIN {
printf "%-20s %-10s %-10s \n","File_Name","Avail","Used"
}
NR>1 {printf "%-20s %.2f%%\t %d%%\n",$1,($2 ? ($4/$2)*100 : 0),$5
}'
echo -e "------------------------\nTOP 5 Processes with most CPU Usage:"
ps -eo %cpu,pid |sort -nr|head -n 5|awk '
BEGIN{
printf "Process No\tCPU%%\tPID\n"
}
{printf "%d)\t\t%.2f\t%d\n",NR,$1,$2}
'

echo -e "------------------------\nTOP 5 Processes with most Memory Usage:"
echo "$CPU" |sort -k4 -nr|head -n 5|awk '{print NR"): "$4"%","PID",$2}'
