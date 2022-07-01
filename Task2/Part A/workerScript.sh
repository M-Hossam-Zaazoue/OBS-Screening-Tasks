#!/bin/bash
hostnamectl set-hostname worker

# Disable Swap
swapoff -a
sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# Configure Firewall
apt update && apt upgrade -y && apt install -y firewalld
systemctl restart firewalld && systemctl enable firewalld
firewall-cmd --permanent --add-port=10250/tcp --add-port=30000-32767/tcp
firewall-cmd --reload

# Configure IP tables
tee /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF
modprobe overlay
modprobe br_netfilter
tee /etc/sysctl.d/kubernetes.conf <<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF
sysctl --system

# Install Docker Container Runtime 
apt update && apt install -y curl 
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update && apt install -y containerd.io
mkdir -p /etc/containerd
containerd config default > /etc/containerd/config.toml
systemctl restart containerd && systemctl enable containerd

# Install Kubernetes and join Cluster
apt update && apt-get install -y apt-transport-https ca-certificates curl
curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | tee /etc/apt/sources.list.d/kubernetes.list
KUBE_VERSION=1.23.0
apt update && apt-get install -y kubelet=${KUBE_VERSION}-00 kubeadm=${KUBE_VERSION}-00 kubectl=${KUBE_VERSION}-00 kubernetes-cni=0.8.7-00
apt-mark hold kubelet kubeadm kubectl
systemctl enable kubelet && systemctl start kubelet

# The command below is for the cluster created at this time 
kubeadm join $1:6443 --token $2 --discovery-token-ca-cert-hash sha256:$3