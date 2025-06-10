#!/bin/bash

THE_FILE="$HOME/settings/.spaced_repetition.info"
HELP_MSG="Usage: $0 <OPTION> { KNOWLEDGE | KNOWLEDGE-INDEX }...
Help remember KNOWLEDGE with spaced repetition technique.

OPTIONS:
add		Add new KNOWLEDGE
edit		Edit content of KNOWLEDGE file in a text editor
ls, list	List existing knowledges
rm		Remove knowledge using it's KNOWLEDGE-INDEX
restore		Undo last rm
help		Display this help message

"

case $1 in
	"add" )
		# make temp file
		tmp_file="$(mktemp)"

		# edit temp file with default editor
		$EDITOR $tmp_file

		if [ -n "$(cat $tmp_file)" ]
		then
			# printing index of a new knowledge to the file
			# (if file size > 0, return the index of the lest line (first line index = 1), else return 0) no matter the resilt, add 1
			printf "$(($([ -s "$THE_FILE" ] \
				&& tail -n 1 "$THE_FILE" | cut -d',' -f 1 \
				|| echo 0) + 1)),1-$(($(date +'%-j') + 1))-$(date +'%Y'),$(date +'%m/%d/%Y %R'),	" \
				>> "$THE_FILE"

			# condense the edited file in one line and add it in the knowledge file
			echo $(cat $tmp_file | tr "\n" " " && printf "\n") >> "$THE_FILE"
		else
			echo "No KNOWLEDGE found. Aborted."

		fi
	;;

	"list" | "ls" )
		[ -s "$THE_FILE" ] \
			&& cut -d',' -f 1,3- "$THE_FILE" \
			|| echo "No knowledge yet."
	;;

	"edit" )
		tmp_file="$(mktemp)"

		cat $THE_FILE > $tmp_file
		$EDITOR $tmp_file

		git --no-pager diff -U0 $THE_FILE $tmp_file || has_changes="po"

		if [ -n "$has_changes" ]
		then
			printf "Apply patch to the main file? [y/n] "
			read yes_no

			if [ "$yes_no" = "y" ]
			then
				# do a backup
				cat "$THE_FILE" \
					> "${THE_FILE}.bk"

				# patch "$THE_FILE" <(git diff -R $tmp_file $THE_FILE)
				patch "$THE_FILE" <(git diff $THE_FILE $tmp_file )
				echo Patch applied
			else
				# do nothing
				echo Successfully aborted.
			fi
		else
			echo No changes found.
			echo Change aborted.
		fi

	;;

	"rm" )
		# checks if there are arguments
		if [ $(echo ${@:2} | wc -w) -eq 0 ] ;
		then
			printf "No KNOWLEDGE-INDEX found.\nRefer to the manual:\n"
			printf "$HELP_MSG"
			exit
		fi

		args=""

		# 0 = last_index -- negative_num = last_index - negative_num
		if ( grep -E "((0+ | 0+$|^0+ |^0+$)|( -[1-9][0-9]* | -[1-9][0-9]*$|^-[1-9][0-9]* |^-[1-9][0-9]*$))" <(echo ${@:2}) > /dev/null 2>&1 )
		then
			for i in ${@:2}
			do
				# checks if there are negative or zero index
				if [ $i -eq 0 ]
				then
					# args = current_val + last_index
					args+="$(tail -n 1 "$THE_FILE" | cut -d"," -f 1) "
				elif ( grep -E "( -[1-9][0-9]* | -[1-9][0-9]*$|^-[1-9][0-9]* |^-[1-9][0-9]*$)" <(echo $i) > /dev/null 2>&1 )
				then
					# args = "current_val + (last_index - i.value)"
					args+="$(( $i + $(tail -n 1 $THE_FILE | cut -d',' -f 1) + 1)) "
				else
					args+="$i "
				fi
			done
		fi

		# used if there are MULTIPLE args
		lines_index_remove="$(mktemp)"

		deleting_process(){
			# get line ro rm
			line="$(sed -n ${1}p "$THE_FILE")"

			# show the selected knowledge and ask if want to delete
			printf "Removing line ${1}:\n${line}\n"
			printf "Do you realy want to remove item ${1}? [y/n] "
			read yes_no

			# if line.remove = true; then rm it
			if [ "$yes_no" = "y" ] ;
			then
				# if there are multiple args, do this
				if [ "${@:${#@}}" = "MULTIPLE" ]
				then
					sed -n ${1}p "$THE_FILE" \
					| cut -d"," -f 1 \
					>> $lines_index_remove
				else
					# do backup
					cat "$THE_FILE" \
						> "${THE_FILE}.bk"

					sed -i "${1}d" "$THE_FILE"

					tmp_file="$(mktemp)"

					cut -d"," -f 2- "$THE_FILE" | nl -w1 -s"," \
					> $tmp_file
					cat $tmp_file > "$THE_FILE"
				fi
			else
				# Do nothing
				echo Successfully aborted.
			fi

		}

		# if there are more than one line to delete, do the deleting
		# process for all of them.
		if [ $(echo $args | wc -w) -gt 1 ] ;
		then
			# does the deliting process for each index in ${@:2} = (the second item onwards)
			for i in $args
			do
				deleting_process $i MULTIPLE
			done
		else
			deleting_process $args
		fi

		if [ -s $lines_index_remove ] 
		then
			# do a backup
			cat "$THE_FILE" \
				> "${THE_FILE}.bk"

			for i in $(sort -r -u $lines_index_remove)
			do
				sed -i "${i}d" "$THE_FILE"
			done

			tmp_file="$(mktemp)"

			cut -d"," -f 2- "$THE_FILE" | nl -w1 -s"," \
			> $tmp_file
			cat $tmp_file > "$THE_FILE"
		fi

	;;

	"restore" | "recover" )
		echo "Patch to be applied:"
		git diff "$THE_FILE" "${THE_FILE}.bk"
		printf "\nApply patch to main file? [y/n] "
		read yes_no

		# if patch.apply = true; then apply it
		if [ "$yes_no" = "y" ] ;
		then
			# apply
			patch "$THE_FILE" <(git diff "$THE_FILE" "${THE_FILE}.bk")
			echo Done.
		else
			# Do nothing
			echo Successfully aborted.
		fi
	;;

	"-h" | "--help" | "help" | *)
		printf "$HELP_MSG"
	;;
esac
