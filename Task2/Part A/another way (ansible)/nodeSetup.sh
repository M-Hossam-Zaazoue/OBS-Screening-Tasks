#!/bin/bash
# Configure ssh
apt update && apt upgrade -y && apt install -y openssh-server
tee /etc/ssh/sshd_config <<EOF
PermitRootLogin yes
PasswordAuthentication yes
EOF
systemctl restart sshd
mkdir .ssh && touch .ssh/authorized_keys
echo $1 >> .ssh/authorized_keys