#!/bin/bash
sudo apt update -y
sudo apt upgrade -y

#swap
sudo swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

#routing
echo -e "net.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/10-k8s.conf > /dev/null
sudo sysctl -f /etc/sysctl.d/10-k8s.conf

#containerd
sudo apt-get update
sudo apt-get install -y containerd
sudo systemctl enable containerd
sudo systemctl start containerd

#apt kubernetes
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor --yes -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg 

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list  

#kubernetes packages install
sudo apt-get update -y
sudo apt-get install -y kubeadm kubectl kubelet
