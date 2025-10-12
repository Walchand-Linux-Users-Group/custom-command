#!/bin/bash 
set -euo pipefail

# ensure ssh setup is already installed

echo "checking ssh installation"

if ! command -v ssh >/dev/null 2>&1; then
	echo "installing openssh"
	sudo apt update -y
	sudo apt install -y openssh-client
fi

if ! systemctl list-units --type=service | grep -q "ssh.service"; then
	echo "enabling openssh server"
	sudo apt install -y openssh-server
	sudo systemctl enable ssh
	#sudo apt install -y tree
fi

echo "ssh is ready"


# input connection details

read -rp "Enter ip address: " ip
read -rp "enter remote user name: " user
read -rp "enter ssh port[pc-22 or android(Termux)-8022]: " port

port=${port:-22} # default setting

target="${user}@${ip}"

echo "connecting target: $target (port: $port)"


while true; do
	echo "select option:"
	echo "1) open ssh session"
	echo "2) find file by name in remote pc"
	echo "3) exit"
	read -rp "Enter your choice[1-3]: " choice

	case "$choice" in

		1)
			echo "connecting to remote pc"
			# use variables correctly
			ssh -p "$port" "$target"
			;;

		2)
			read -rp "Enter filename to search (e.g. test.txt): " filename
			read -rp "Enter directory to start search (leave empty for /home/<user>): " filedir

			# use filedir default if empty
			filedir=${filedir:-/home/"$user"}

			#used find command avoided tree(recursive nature may cause high resource usage)
			echo "Searching for '$filename' in $filedir on $target ..."
			ssh -p "$port" -o BatchMode=no "$target" \
			  "if command -v find >/dev/null 2>&1; then
			     find \"${filedir}\" -type f -iname \"${filename}\" 2>/dev/null || true
			   else
			     echo 'find command not available on remote system.'
			   fi" | tee /tmp/ssh_search_results.txt

			if [[ ! -s /tmp/ssh_search_results.txt ]]; then
				echo "No files found matching '$filename'"
			else
				# echo "Search complete."
				echo "File(s) found above."
			fi
			;;
			echo
        

		# 2)
		# 	read -rp "Enter filename to search (e.g. test.txt): " filename
		# 	read -rp "Enter directory to start search (leave empty for /home/<user>): " filedir

		# 	# use filedir default if empty
		# 	filedir=${filedir:-/home/"$user"}

		# 	echo "Searching for '$filename' in $filedir on $target ..."
		# 	# Run tree on remote host and match filename pattern
		# 	ssh -p "$port" -o BatchMode=no "$target" "
		# 	  if command -v tree >/dev/null 2>&1; then
		# 	    echo 'Using tree to search for file...'
		# 	    tree -f -i -P \"${filename}\" \"${filedir}\" 2>/dev/null | grep \"${filename}\" || true
		# 	  else
		# 	    echo 'tree command not available on remote system.'
		# 	  fi
		# 	" | tee /tmp/ssh_search_results.txt

		# 	if [[ ! -s /tmp/ssh_search_results.txt ]]; then
		# 		echo "No files found matching '$filename'"
		# 	else
		# 		echo "Search complete."
		# 		echo "File(s) found above."
		# 	fi
		# 	;;



		3)
			echo "Exiting."
			exit 0
			;;

		*)
			echo "Invalid choice, try again."
			;;
	esac
done

