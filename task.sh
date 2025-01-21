cf="contacts.txt"
if ! -f $cf; then
	touch "$cf"
fi

while true; do
	echo -e 1. Add Contactn2. Display Contactsn3. Delete Contactn4. Update Contactn5. Search Contactn6. Send messagen7. View Messagesn8. Quit
	read -p  "> " ch
	 case $ch in
		 1)
			 addContact;;
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
