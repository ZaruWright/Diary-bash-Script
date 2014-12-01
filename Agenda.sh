#!/bin/bash

## @Author: Samuel García Segador
## @Copyright 2014 Samuel García Segador
## @License GPL

# CONSTANTS
file=".diary" # Hide file
prompt="#!"

# Colors Code
Black="30m"
Red="31m"
Green="32m"
Yellow="33m"
Blue="34m"
Magenta="35m"
Cyan="36m"
Gray="37m"


#
# Simple menu to do the operations
function menu(){
	
	let close=0 #number var
	while [ $close -eq 0 ];
	do
		colorText $Yellow "1) "
			colorText $Blue "Show\n"
		colorText $Yellow "2) "
			colorText $Blue "Search\n"
		colorText $Yellow "3) "
			colorText $Blue "Erase\n"
		colorText $Yellow "4) "
			colorText $Blue "Erase all\n"
		colorText $Yellow "5) "
			colorText $Blue "Add\n"
		colorText $Yellow "6) "
			colorText $Blue "Quit\n"
		read -p $prompt option
		case $option in
			"1") show;;
			"2") search;;
			"3") erase;;
			"4") eraseAll;;
			"5") add;;
			"6") colorText $Green "Goodbye!\n"; close=1;;
			*)   colorText $Red "Please, select a correct answer.\n";;
		esac
	done
}

#
# Shows to the user all the contacts that you have in it.
function show(){

	if [ -f $file ]; then
		let lines=`wc $file | cut -d " " -f2` #number of lines
		let i=1
		while [ $i -le $lines ];
		do
			colorText $Green "Name: "; cat $file | cut -d ':' -f1 | tr '\n' ':' | cut -d ':' -f$i
			colorText $Green "Phone: ";cat $file | cut -d ':' -f2 | tr '\n' ':' | cut -d ':' -f$i
			colorText $Green "Mail: "; cat $file | cut -d ':' -f3 | tr '\n' ':' | cut -d ':' -f$i
			colorText $Green "\n"
			i=`expr $i + 1`
		done
	else
		colorText $Red "There isn't nothing in the database, please add some contacts.\n"
	fi
}


# 
# The user can search in the database (file) the data of
# your contacts
function search(){

	if [ -f $file ]; then
		colorText $Green "Search: ";  read search
		cat $file | grep "\<$search:.*:.*" > diaryAux 2> /dev/null

		if [ $? -eq 0 ];then 
			# If the grep command finished correctly, then show the data
			colorText $Green "Name: ";  cat diaryAux | cut -d ':' -f1 # It gets the first field
			colorText $Green "Phone: "; cat diaryAux | cut -d ':' -f2 # It gets the second field
			colorText $Green "Mail: ";  cat diaryAux | cut -d ':' -f3 # It gets the third field
		else
			colorText $Red "Sorry, this name isn't in your diary, try again.\n"
		fi
		rm diaryAux
	else
		colorText $Red "There isn't nothing in the database, please add some contacts.\n"
	fi
}

#
# Erase a contact from the database with an input string from the user
function erase(){
	if [ -f $file ]; then

		colorText $Green "Name: ";  read name
		line=`(grep -n "\<$name:.*:.*" $file | cut -d ':' -f1) 2> /dev/null` # We send the output error to the null device.
		if [ -n "$line" ]; then
			sed ${line}d $file > diaryAux
			cat diaryAux > $file
			rm diaryAux

			if [ $(wc $file | cut -d " " -f1) = "0" ]; then
				rm $file
			fi
			colorText $Cyan "Your diary has been updated, the state of your diary now is:\n"
			show
		else
			colorText $Red "Sorry, this name isn't in your diary, try again.\n"
		fi
	else

		colorText $Red "There isn't nothing in the database, please add some contacts.\n"
	fi
	
}

#
# Erase all about the diary
function eraseAll(){
	if [ -f $file ]; then
		rm $file
	else
		colorText $Red "Your diary haven't got any contacts. Please, add someone.\n"
	fi
}

# 
# Add a contact in the database
function add(){

	# We create file if not exist
	if [ ! -f $file ]; then
		touch $file
	fi

	colorText $Green "Name: ";  read name
	cat $file | grep "\<$name:.*:.*" > /dev/null 
	if [ $? -ne 0 ];then
		colorText $Green "Phone: "; read phone
		colorText $Green "Mail: " ; read mail
		colorText $Green "\n"
		echo "$name:$phone:$mail" >> $file
	else
		colorText $Red "Sorry, this name is in your diary yet, try again.\n"
	fi
	
}

function colorText(){
	echo -e -n "\e[$1$2\e[0m"
}

# Start Program
menu