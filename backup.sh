#!/bin/bash

# This if checks if there are 4 parameters.
# If not the usage info is printed.

if [ $# -ne 4 ]
  then
    echo "usage: ./backup.sh <target path> <destination path> <ssh port> <number of backups>"
    exit 1
fi

# This is the regex for an integer. This is used to check if parameter 3 and 4 are integers

is_number='^[0-9]+$'

# This if checks if parameter 3 (ssh port) is an integer.
# If not an error message will be printed

if ! [[ $3 =~ $is_number ]]
  then
    echo "ssh port parameter must be an integer"
    exit 1
fi

# This if checks if parameter 4 (number of backups) is an integer.
# If not an error message will be printed

if ! [[ $4 =~ $is_number ]]
  then
    echo "number of backups must be an integer"
    exit 1
fi

# This if checks if the backup directory exists.
# If not the directory and it subdirectories are created.

if ! [ -d $2 ]
  then
    mkdir $2
    mkdir "$2/current"
    mkdir "$2/backups"
    echo "$2 directory and subdirectories has been created"
fi

# This next line syncs the target path with the destination path.
# $1 contains the target path. 
# $2 contains the destination path.
# $3 contains the ssh port.

echo "Syncing..."
rsync -ahe "ssh -p $3" $1 "$2/current"
echo "Done syncing"

# The next line gets the current date and time, which is used as filename for the tarball backup file.
# It will have the format YYYY-MM-DD-HH:MM
current_date=`date +%Y-%m-%d-%H:%M`

# The next line creates a tarball of the current backup directory and names it YYYY-MM-DD-HH:MM
tar_file="$2/backups/$current_date.tar.gz"
tar_dir="$2/current/"

echo "Starting tarball compression"
tar -czf $tar_file $tar_dir
echo "Done tarball compression"

# This variable sets the number of backups who will be saved.
# Example: if you want to store 7 days of backups then number of backups is 7.

number_of_backups=$4

# This if checks if the backup limit is reached.
# If it's reached the backup limit then it removes the oldest ones.
# how many there are to be deleted depends on parameter $4 which contains how many backups to be stored.

actual_backups_number=`ls -l "$2/backups/" | wc -l`
backups_to_remove=$((actual_backups_number-1-number_of_backups))
counter=0

echo "Deleting $backups_to_remove backups..."

while [ $counter -lt $backups_to_remove ]
do
	filename=`ls -l "$2/backups" | head -n 2 | grep -v 'total' | awk '{print $9}'`
	echo "deleting $filename"
	rm "$2/backups/$filename"
	
	counter=$[counter+1]
done

echo "Done."