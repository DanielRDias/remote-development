#!/bin/bash

echo "@@@ Start user.sh @@@"

# Mount Data volume
# Wait for ebs volume to be attached
while [ ! -e $(readlink -f ${device_name}) ]; do echo Waiting for EBS volume to attach; sleep 5; done

devpath=$(readlink -f ${device_name})
mkdir ${mount_point}

mkfs -t xfs $devpath
yum install xfsprogs

devid=$(blkid $devpath -o value -s UUID)
devtype=$(blkid $devpath -o value -s TYPE)
echo "UUID=$devid ${mount_point} $devtype defaults,nofail  0  2" | sudo tee -a /etc/fstab > /dev/null
mount $devpath ${mount_point}

# Add user
adduser ${username}

chown -R ${username}:${username} ${mount_point}
chmod 0775 ${mount_point}

# Add user to sudoers
touch /etc/sudoers.d/${username}
echo "${username} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/${username}

# Change HOME to data EBS
usermod -m -d ${mount_point}/${username} ${username}

# Run as user
sudo su - ${username}

runuser -l ${username} -c 'mkdir -p ~/.ssh'
runuser -l ${username} -c 'chmod 700 ~/.ssh'
runuser -l ${username} -c 'touch ~/.ssh/authorized_keys'
runuser -l ${username} -c 'chmod 600 ~/.ssh/authorized_keys'
runuser -l ${username} -c 'echo ${ssh_public_key} >> ~/.ssh/authorized_keys'

echo "@@@ End user.sh @@@"
