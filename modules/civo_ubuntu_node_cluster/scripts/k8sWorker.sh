#!/bin/bash
#/* **************** LFD259:2022-07-25 s_02/k8sWorker.sh **************** */
#/*
# * The code herein is: Copyright the Linux Foundation, 2022
# *
# * This Copyright is retained for the purpose of protecting free
# * redistribution of source.
# *
# *     URL:    https://training.linuxfoundation.org
# *     email:  info@linuxfoundation.org
# *
# * This code is distributed under Version 2 of the GNU General Public
# * License, which you should have received with the source.
# *
# */
#Version 1.24.1
#
# This script is intended to be run on an Ubuntu 20.04, 
# 2cpu, 8G.
# By Tim Serewicz, 05/2022 GPL

# Note there is a lot of software downloaded, which may require
# some troubleshooting if any of the sites updates their code,
# which should be expected


# Check to see if the script has been run before. Exit out if so.
FILE=/k8scp_run
if [ -f "$FILE" ]; then
    echo "WARNING!"
    echo "$FILE exists. CP script has already been used. Do not run worker on control plane."
    echo
    echo "This script should be run on the worker node."
    echo
    exit 1
else 
    echo "$FILE does not exist. Running  script"
fi


# Create a file when this script is started to keep it from running 
# on the control plane node.
sudo touch /k8scp_run

# Update the system
sudo apt update ; sudo apt upgrade -y

# Install necessary software
sudo apt install curl apt-transport-https vim git wget gnupg2 software-properties-common apt-transport-https ca-certificates uidmap -y

# Add repo for Kubernetes
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

# Install the Kubernetes software, and lock the version 
sudo apt update
sudo apt -y install kubelet=1.24.1-00 kubeadm=1.24.1-00 kubectl=1.24.1-00
sudo apt-mark hold kubelet kubeadm kubectl

# Ensure Kubelet is running
# sudo systemctl enable --now kubelet

# Disable swap just in case 
sudo swapoff -a

# Ensure Kernel has modules
sudo modprobe overlay
sudo modprobe br_netfilter

# Update networking to allow traffic
cat <<EOF | sudo tee /etc/sysctl.d/kubernetes.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
net.ipv4.ip_forward = 1
EOF

sudo sysctl --system

# Configure containerd settings
￼
cat <<EOF | sudo tee /etc/modules-load.d/containerd.conf 
overlay
br_netfilter
EOF

sudo sysctl --system

# Install the containerd software
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update
sudo apt install containerd -y

# Configure containerd and restart
sudo mkdir -p /etc/containerd
containerd config default | sudo tee /etc/containerd/config.toml
sudo systemctl restart containerd
sudo systemctl enable containerd

# Install podman for students
curl -fsSL -o podman-linux-amd64.tar.gz https://github.com/mgoltzsche/podman-static/releases/latest/download/podman-linux-amd64.tar.gz
tar -xf podman-linux-amd64.tar.gz
sudo cp -r podman-linux-amd64/usr podman-linux-amd64/etc /

# Start Podman configuration files
sudo mkdir -p /etc/containers/registries.conf.d/

cat <<EOF | sudo tee -a /etc/containers/registries.conf.d/registry.conf
[[registry]]
location = "<YOUR-registry-IP-Here:5000"
insecure = true
EOF


# Ready to continue
sleep 3
echo
echo
echo '***************************'
echo
echo "Continue to the next step"
echo
echo "Use sudo and copy over kubeadm join command from"
echo "control plane."
echo
echo '***************************'
echo
echo

