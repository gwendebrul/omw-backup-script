With this script you can backup a folder from a remote computer to another local computer (this can be a NAS or server).
The script can be added to crontab for regular backups. The script must be executed on a computer or server where the backups will be stored.

It uses rsync over ssh to create a timemachine like backup.

##Usage##
```bash
./backup.sh joe@example.com:~/projects ~/projects 22 5
```

This will backup the projects folder from example.com server to the projects folder in your homefolder on the computer or server where this script is executed.

###parameters###
```bash
./backup.sh <target folder> <destination folder> <ssh port> <number of backups>
```

* target folder is from where you want to do a backup.
* destination folder is where to you want to backup
* ssh port is the port over which ssh can access the target
* number of backups is the amount of backups to be stored

**All 4 parameters are required**