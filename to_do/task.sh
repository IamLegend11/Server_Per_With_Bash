#!/bin/bash

FILE=task_show.txt

if ! [ -f "$FILE" ];then
	echo "File doesn't exist"
	exit 1
fi

add_task() {
        if [ -z "$2" ];then
                echo "You didn't enter any task, please try again!"
        	exit 1
	fi
        echo "[ ] ${@:2}" >> "$FILE"
}

list_tasks() {
	awk '{print NR"." $0 }' "$FILE"
}

done_task() {
	sed -Ei "$1s/(\[) (\])(.*)/\1x\2\3 | $(date +"Completed at %H:%M %d%b-%Y")/" "$FILE"
}

delete_task() {
	read -rp "Would you like to (D)elete whole task or (U)ncheck it with number of the task?" input line
	check=$(sed -n "${line}p" "$FILE")
	if [[ "${input,,}" = "d" ]] && [[ "$line" -le $(wc -l < "$FILE") ]];then
		sed -i "${line}d" "$FILE"
	elif [[ "${input,,}" == "u" ]] && [[ "$line" -le $(wc -l < "$FILE") ]];then
		if [[ "$check" =~ \[\ \] ]];then
			echo "The task is already un-checked, please try again"
			exit 1
		fi
		sed -Ei "${line}s/(\[)x(\])(.*)\|.*/\1 \2\3/" "$FILE"
	else
		echo "You've entered a wrong input,try again"
		exit 1
	fi
}

clear_completed() {
	sed -i "s/\[x\]/\[ \]/" "$FILE"
}

search_task() {
	if [ -z "$1" ];then
		echo "You didn't enter a valid input, please try again"
		exit 1
	fi
	if ! grep -i "$@" "$FILE" |nl ;then
		echo "Task not found, please try again"
	fi
}

edit_task() {
	if ! [[  "$1" =~ ^[0-9]+$ ]] ||! [[ -n "${*:2}" ]] || \
   ( [[ "$2" =~ ^[0-9]+$ ]] && \
     ( [[ $# -lt 3 ]] || ! [[ "${*:2}" =~ [a-zA-Z] ]] ) );then
#! [[ -z "${*:2}" ]];then
		echo "Invalid input, try again"
		exit 1
	fi
	sed -Ei "$1s/(\[.*\]).*/\1 ${@:2}/" "$FILE"
}

case ${1,,} in 
	"add") add_task "$@" ;;
	"list") list_tasks ;;
	"done") done_task "$2" ;;
	"delete") delete_task ;;
	"search") search_task "${@:2}" ;;
	"clear") clear_completed ;;
	"edit") edit_task "${@:2}" ;;
	*)
	echo "You have entered a wrong input"
	echo -e "These are your avail options\nadd)\nlist)\ndone)\ndelete)\nsearch)\nclear)\nedit)" | awk 'NR==1{print $0}; NR>1 {print (NR-1)"." $0}'
	exit 1;;
esac

