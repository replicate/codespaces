#!/bin/bash
set -eux

# install cog
sudo curl -o /usr/local/bin/cog -L https://github.com/replicate/cog/releases/latest/download/cog_`uname -s`_`uname -m`
sudo chmod +x /usr/local/bin/cog

# install nvidia-docker
pushd /tmp

mkdir install-nvidia-docker
cd install-nvidia-docker

distribution=$(. /etc/os-release;echo $ID$VERSION_ID) \
    && curl -fsSL https://nvidia.github.io/libnvidia-container/gpgkey | sudo gpg --dearmor -o /usr/share/keyrings/nvidia-container-toolkit-keyring.gpg \
    && curl -s -L https://nvidia.github.io/libnvidia-container/$distribution/libnvidia-container.list | \
        sed 's#deb https://#deb [signed-by=/usr/share/keyrings/nvidia-container-toolkit-keyring.gpg] https://#g' | \
        sudo tee /etc/apt/sources.list.d/nvidia-container-toolkit.list
sudo apt-get update
apt-get download nvidia-container-toolkit libnvidia-container-tools libnvidia-container1 nvidia-docker2
sudo dpkg  --ignore-depends=docker-ce -i *.deb

popd

# restart docker
sudo killall -9 dockerd
sudo bash -c "nohup dockerd &>/var/log/dockerd.log &"
