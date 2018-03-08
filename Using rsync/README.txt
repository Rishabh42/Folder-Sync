1. Install all the dependencies on the 2 machines with this command:

apt update && apt -y install openssh-server rsync inotify-tools

2. Generate a public-private key link for secure file transfer that rsync can use. Follow these steps to configure it:

ssh-keygen -t rsa -f ~/rsync-key -N ''

# Paste the output in your destination servers' ~/.ssh/authorized_keys file:
cat ~/rsync-key.pub

# Removing public key for security purposes..
rm ~/rsync-key.pub

# Remember to execute this script on all servers separately! Then, copy the output of the script in all of your servers' authorized_keys files.

3. The script which will be used to perform the sync operation on 2 servers has been created in this repo by the name of ‘file-sync.sh’. All you have to do now is to create a systemd service file that can start, stop or reset the script on demand or on system bootup.

4. Create a file called sync.service in the directory /etc/systemd/system/ and put the following contents in it:

[Unit]
Description = SyncService
After = network.target

[Service]
PIDFile = /run/syncservice/syncservice.pid
User = root
Group = root
WorkingDirectory = /<path_to_repo>
ExecStartPre = /bin/mkdir /run/syncservice
ExecStartPre = /bin/chown -R root:root /run/syncservice
ExecStart = /bin/bash /<path_to_repo>/file-sync.sh
ExecReload = /bin/kill -s HUP $MAINPID
ExecStop = /bin/kill -s TERM $MAINPID
ExecStopPost = /bin/rm -rf /run/syncservice
PrivateTmp = true

[Install]
WantedBy = multi-user.target


5. Chmod this service file and reload the system daemon:

chmod 755 /etc/systemd/system/sync.service  
systemctl daemon-reload

6.  You are all set! Use these commands to manage your self-made directory sync daemon:

# Start your service
systemctl start sync.service

# Obtain your services' status
systemctl status sync.service

# Stop your service
systemctl stop sync.service

# Restart your service
systemctl restart sync.service 

