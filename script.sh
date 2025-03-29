#!/bin/bash
#network configuration
echo -e "overlay\nbr_netfilter" | sudo tee /etc/modules-load.d/k8s.conf > /dev/null
sudo modprobe overlay
sudo modprobe br_netfilter

#swap
sudo swapoff -a
sudo sed -i '/swap/d' /etc/fstab

#routing
echo -e "net.bridge.bridge-nf-call-ip6tables = 1\nnet.bridge.bridge-nf-call-iptables = 1\nnet.ipv4.ip_forward = 1" | sudo tee /etc/sysctl.d/10-k8s.conf > /dev/null
sudo sysctl -f /etc/sysctl.d/10-k8s.conf

#apt kubernetes
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.32/deb/Release.key | sudo gpg --dearmor --yes -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
sudo chmod 644 /etc/apt/keyrings/kubernetes-apt-keyring.gpg 

echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.32/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo chmod 644 /etc/apt/sources.list.d/kubernetes.list  

#kubernetes packages install
sudo apt-get update -y
sudo apt-get install -y kubeadm kubectl kubelet

#containerd
sudo apt-get update
sudo apt-get install -y containerd
sudo systemctl enable containerd
sudo systemctl start containerd

sudo tee /etc/crictl.yaml > /dev/null << _EOF
runtime-endpoint: unix:///var/run/containerd/containerd.sock
_EOF

#finish
echo "done"

