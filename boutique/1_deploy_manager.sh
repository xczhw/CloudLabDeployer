#!/bin/bash
set -e

sudo mv ~/flannel.yaml /root/flannel.yaml

sudo -i

sudo apt update > /dev/null
apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y > /dev/null

# Install kubeadm
echo "1.1 *********Install kubeadm*********"
# curl -fsSL https://dl.k8s.io/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-archive-keyring.gpg
# echo "deb [signed-by=/etc/apt/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
# echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.20.4-00/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat << EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

apt-get update > /dev/null
apt install cri-tools=1.13.0-01 kubeadm=1.20.4-00 kubectl=1.20.4-00 kubelet=1.20.4-00 kubernetes-cni=0.8.7-00 -y > /dev/null
apt-mark hold cri-tools=1.13.0-01 kubeadm=1.20.4-00 kubectl=1.20.4-00 kubelet=1.20.4-00 kubernetes-cni=0.8.7-00 > /dev/null

# check version
echo "1.2 *********check version*********"
kubeadm version
kubectl version --client
kubelet --version

# close swap
echo "1.3 *********close swap*********"
swapoff -a 
sed -i '/swap/d' /etc/fstab

# close firewall
# ufw disable

# Install Docker
echo "1.4 *********Install Docker*********"
apt-get remove docker docker-engine docker.io containerd runc
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update > /dev/null
apt install containerd.io=1.4.4-1 docker-ce=5:19.03.15~3-0~ubuntu-focal docker-ce-cli=5:19.03.15~3-0~ubuntu-focal -y > /dev/null
apt-mark hold containerd.io=1.4.4-1 docker-ce=5:19.03.15~3-0~ubuntu-focal docker-ce-cli=5:19.03.15~3-0~ubuntu-focal > /dev/null
# sudo usermod -aG docker $USER

# To solve [ERROR CRI]: container runtime is not running:
# sudo rm -rf /etc/containerd/config.toml
# sudo systemctl restart containerd

# self starting
sudo systemctl enable kubelet
sudo systemctl start kubelet
sudo systemctl enable docker
sudo systemctl start docker

# init kubeadm
echo "1.5 *********init kubeadm*********"
sudo kubeadm init --pod-network-cidr=10.244.0.0/16
# KUBECONFIG=/etc/kubernetes/admin.conf

# To start using your cluster, you need to run the following as a regular user:
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
# Alternatively, if you are the root user, you can run:
# export KUBECONFIG=/etc/kubernetes/admin.conf
kubectl apply -f flannel.yaml

# sudo kubeadm token create --print-join-command

# # Install minikube
# curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
# sudo install minikube-linux-amd64 /usr/local/bin/minikube

# # Install kind
# go install sigs.k8s.io/kind@v0.20.0
# echo export PATH="$(go env GOPATH)/bin:$PATH" >> .bashrc
# source .bashrc
# kind create cluster

# echo export PATH="~/istio-1.18.2/bin:$PATH" >> .bashrc

  