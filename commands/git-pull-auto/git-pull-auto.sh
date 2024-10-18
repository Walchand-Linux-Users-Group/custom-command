#!/bin/bash


if [ "$EUID" -ne 0 ]; then
  echo "Please run as root or use sudo"
  exit 1
fi

echo "Pulling latest changes from the repository..."
git pull origin master

command_name="git-pull-auto"
script_path=$(realpath "$0")

echo "Script path: $script_path"  


add_cron_job() {
  if ! crontab -l | grep -q "$script_path"; then
    echo "Adding cron job for the first time..."

    read -p "Enter minute (0-59 or *): " minute
    read -p "Enter hour (0-23 or *): " hour
    read -p "Enter day of month (1-31 or *): " day
    read -p "Enter month (1-12 or *): " month
    read -p "Enter day of week (0-6 or *): " day_of_week

    cron_schedule="$minute $hour $day $month $day_of_week"
    
    # Attempt to copy the script
    echo "Attempting to copy the script to /usr/local/bin/$command_name..."
    if cp "$script_path" "/usr/local/bin/$command_name"; then
      chmod +x "/usr/local/bin/$command_name"
      echo "Script copied to /usr/local/bin successfully."
      
      # Add the cron job
      (crontab -l; echo "$cron_schedule $script_path") | crontab -
      echo "New cron job added: $cron_schedule $script_path"
    else
      echo "Failed to copy script to /usr/local/bin. Check for errors."
      exit 1
    fi
  else
    echo "Cron job already exists. Skipping cron scheduling."
  fi
}


delete_cron_job() {
  if crontab -l | grep -q "$script_path"; then
    echo "Deleting the existing cron job..."
    # Remove the specific cron job
    (crontab -l | grep -v "$script_path") | crontab -
    echo "Cron job deleted."
  else
    echo "No cron job found for this script."
  fi
}


echo "Do you want to (a)dd or (d)elete the cron job? (Enter 'a' or 'd')"
read -r action

if [[ "$action" == "a" ]]; then
  add_cron_job
elif [[ "$action" == "d" ]]; then
  delete_cron_job
else
  echo "Invalid option. Exiting."
  exit 1
fi
