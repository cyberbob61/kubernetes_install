# kubernetes_install
a fast and easy way to install kubernetes on last stable ubuntu server

```bash
curl -sL https://raw.githubusercontent.com/cyberbob61/kubernetes_install/refs/heads/main/script.sh | sudo bash
```

```bash
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```

```bash
kubectl taint nodes --all node-role.kubernetes.io/control-plane-
kubectl apply -f https://github.com/flannel-io/flannel/releases/latest/download/kube-flannel.yml
```
