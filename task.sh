#! /bin/bash

source ./contacts.sh

cf="contacts.txt"
mf="messages"
if [ ! -f $cf ]; then
	touch "$cf"
fi
if [ ! -d $mf ]; then
	mkdir "$mf"
fi


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
			 displayContacts;;
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
