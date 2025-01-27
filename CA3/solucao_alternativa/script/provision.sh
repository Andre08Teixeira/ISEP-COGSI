#!/bin/bash
mkdir -p /home/ubuntu/.ssh
mv /home/ubuntu/authorized_keys /home/ubuntu/.ssh
mv /home/ubuntu/id_ed25519 /home/ubuntu/.ssh
chmod 600 /home/ubuntu/.ssh/id_ed25519
chown -R ubuntu:ubuntu /home/ubuntu/.ssh

echo "PubkeyAuthentication yes" >> /etc/ssh/sshd_config
echo "PasswordAuthentication no" >> /etc/ssh/sshd_config

echo 'Host github.com' >> /etc/ssh/ssh_config
echo '    IdentityFile /home/ubuntu/.ssh/id_ed25519' >> /etc/ssh/ssh_config
echo '    User git' >> /etc/ssh/ssh_config

ssh-keyscan github.com >> /home/ubuntu/.ssh/known_hosts

sudo -u ubuntu git clone git@github.com:1181210/cogsi2425-1181210-1190384-1181242.git /home/ubuntu/repositorio

service ssh restart

