addContact()
{
        read -p "Enter the name = " name
        if grep -q "^$name:" "$cf" ;then
                echo "id = $name alredy exists"
        fi

        read -p "Enter the number = " number

        if grep -q ",$number," "$cf" ;then
                echo "$number alredy exists"
        fi

        echo "$name:$number" >> "$cf"
	echo "Added the new contact $name:$number"
        return 0
}


displayContacts(){
        if [ ! -s "$cf" ]; then
                echo "Your contact list is empty."
        else
                echo "My contacts:"
                echo "------------"
                cat "$cf"
        fi
}


deleteContact() {
	read -p "Enter the name of the contact to delete: " name
	if grep -q -i "^$name:" "$cf"; then
        	sed -i "/^$name:/I d" "$cf"
		echo "Contact $name was deleted successfully."
	else
		echo "Contact $name not found."
	fi
}


updateContact() {
	read -p "Enter the name of the contact to update: " name
	if grep -q -i "^$name:" "$cf"; then
		contact=$(grep -i "^$name:" "$cf")
		current_name=$(echo "$contact" | cut -d ':' -f 1)
        	current_phone=$(echo "$contact" | cut -d ':' -f 2)
		echo "Contact: Name: $current_name Phone: $current_phone"
		read -p "What would you like to update? 1 Name 2 Phone Number 3 Both: " ch
		case $ch in
			1) read -p "Enter the new name: " new_name
			sed -i "s/^$current_name:$current_phone/$new_name:$current_phone/" "$cf"
                	echo "Contact name updated successfully.";;
			2) read -p "Enter the new number: " new_number
                        sed -i "s/^$current_name:$current_phone/$current_name:$new_phone/" "$cf"
                        echo "Contact number updated successfully.";;
			3) read -p "Enter the new name: " new_name
                	read -p "Enter the new phone: " new_phone
                	sed -i "s/^$current_name:$current_phone/$new_name:$new_phone/" "$cf"
                	echo "Contact name and phone updated successfully." ;;
			*) "invalid input! Try again! No updates made!" ;;
		esac
	else
		echo "Error: Contact '$name' not found."
	fi
}


searchContact() {
	read -p "1 Search by name 2 Search by number" ch
                case $ch in
                        1) read -p "Enter the name for the search: " name
				if grep -q -i "^$name:" "$cf"; then
                			grep -i "^$name:" "$cf"
        			else
                			echo "No contact found with the name $name."
                                fi ;;
                        2) read -p "Enter the phone number for the search: " number
                        	if grep -q "$number" "$cf" ; then
                                	grep "$number" "$cf"
                        	else
                                	echo "No contact found with the name $number."
                        	fi ;;
                        *) echo "invalid choice"
                esac

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
