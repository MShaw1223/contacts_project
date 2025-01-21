#! /bin/bash
cf="contacts.txt"
mf="messages"
if [ ! -f $cf ]; then
	touch "$cf"
fi
if [ ! -d $mf ]; then
	mkdir "$mf"
fi

addContact() {
        read -p "Enter the name = " name
        if grep -q "^$name:" "$cf" ;then
                echo "id = $name alredy exists"
        fi

        read -p "Enter the number = " number

        if grep -q ",$number," "$cf" ;then
                echo "$number alredy exists"
        fi

        echo "$name:$number" >> "$cf"
	return 0
}

sendMessage(){
	read -p "Enter your phone number: " sender
	read -p "Enter recipient phone number: " recipient
	read -p "Enter the message: " message_body
	send_time=$(date)

	if [ ! -d "$mf/$recipient" ]; then
		mkdir "$mf/$recipient"
	fi

	base="$mf/$recipient"
	if [ ! -f "$base/$sender" ]; then
		touch "$base/$sender"
	fi

	echo "$send_time:$message_body" >> "$base/$sender"

	return 0
}
viewMessage(){
	read -p "Enter your phone number: " user
	echo -e "1. View Sent Messages.\n2. View Recieved Messages.\n3. View latest message."
	read -p "> " ch

	recipients=$(ls $mf)
	recip_arr=($chats)

	recieval_base="$mf/$user"

	case $ch in
		1)
			# sent chats
			for recip in ${recip_arr[@]};do
				curr_chat="$mf/$recip/$user"
				if [ -f "$curr_chat" ]; then
					echo "-- Sent to: $recip --"
					cat "$curr_chat"
					echo "-- -- -- -- -- -- --"
				fi
			done;;
		2)
			user_chats=$(ls "$recieval_base")

			uc_array=($user_chats)

			for chat in ${user_chats[@]}; do 
				echo "-- Recieved from: $chat --"
				cat "$recieval_base/$chat"
				echo "-- -- -- -- -- -- -- -- --"
			done;;
		3)
			# tail -n1 for last message
			user_chats=$(ls "$recieval_base")

			uc_array=($user_chats)

			latest_each=()
			for chat in ${user_chats[@]}; do 
				iter_latest=$(tail -n 1 "$recieval_base/$chat")
				latest_each[${#latest_each[@]}]="$iter_latest"
				# latest_each+=("$iter_latest")
			done

			latest_unformatted=$(echo ${latest_each[0]} | awk -F : '{print $1}')
			latest=$(date -d "$latest_unformatted" +%s)
			latestDates=(["$latest"]=$latest_unformatted)
			for l in "${latest_each[@]}"; do
				current_unf=$(echo $l | awk -F : '{print $1}')
				current=$(date -d "$current_unf" +%s)

				latestDates["$current"]=$l

				if [ $latest -lt $current ];then
					latest=$current
				fi
			done
			echo ${latestDates["$latest"]};;
		*)
			echo "Incorrect input."
			return 1;;
	esac
}


while true; do
	echo -e "1. Add Contact\n2. Display Contacts\n3. Delete Contact\n4. Update Contact\n5. Search Contact\n6. Send message\n7. View Messages\n8. Quit"
	read -p  "> " ch
	 case $ch in
		 1)
			 if ! addContact; then
				 echo "Unable to add Contact"
			 else
				 echo "Contact added Successfully!"
			 fi;;
		 2)
			 displayContact;;
		 3)
			 deleteContact;;
		 4)
			 updateContact;;
		 5)
			 searchContact;;
		 6)
			 sendMessage;;
		 7)
			 viewMessage;;
		 8)
			 exit 0;;
		 *)
			 echo "Incorrect Input";;
	esac
done
