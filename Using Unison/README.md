#Using unison

1. Install unison and other dependencies on both the machines with this command:

	apt-get -y install unison openssh-server ssh nano

2. Since we're using ssh, we need to create a public and private key pair. Run this command
on machine 1:

	ssh-keygen -t dsa

It is important that you do not enter a passphrase otherwise the mirroring will not work without human interaction so simply hit ENTER!

Next, we copy our public key to machine 2:

	ssh-copy-id -i $HOME/.ssh/id_dsa.pub root@host_02

3. Create a profile for unison using the command:

	nano /root/.unison/default.prf

You can use the default.prf config file I created in this repo after making the rquired changes.

Remember, the most important information in the above are the two root directories to sync. Unison supports SSH, RSH or socket to sync files over network. So we need to specify the 2 root folders on the droids by using one of the formats below:

SSH:

root = ssh://user@remote_host//absolute/path/to/root
root = ssh://user@remote_host/relative/path/to/root

4. Now that we have put all settings in a preferences file (especially the root (and optionally the path) directives), we can run Unison without any arguments using the command:

	unison

5. Creating a Cron job for unison
We want to automate synchronization, that is why we create a cron job for it on machine 1 by running the following:

	crontab -e

And append this inside the crontab:

	*/2 * * * * /usr/bin/unison &> /dev/null
	
This would run Unison every 2 minutes; you can adjust it according to your needs.

