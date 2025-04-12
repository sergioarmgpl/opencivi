K3S_VERSION=v1.32.3%2Bk3s1
K3S_ARCH=arm64


function download(){
  rm install.sh k3s k3s-airgap-images-$K3S_ARCH.tar
  echo "Downloading K3s binary"
  curl -#LO https://github.com/k3s-io/k3s/releases/download/$K3S_VERSION/k3s
  echo  "Download K3s install.sh script"
  curl -#L  https://get.k3s.io -o install.sh
  echo "Downloading airgap images"
  curl -#LO https://github.com/k3s-io/k3s/releases/download/$K3S_VERSION/k3s-airgap-images-$K3S_ARCH.tar
  echo "setting permissions to k3s and install.sh"
  chmod +x k3s
  chmod +x install.sh
  tar -vzcf k3s_airgapped.tgz $(ls)
}

function pre-install(){
  mkdir /opt/k3s
  tar -vzxf k3s_airgapped.tgz -C /opt/k3s
  cd /opt/k3s
}


function set-network(){
  echo ">>>> Setting Network"
  ip link add dummy0 type dummy
  ip link set dummy0 up
  ip addr add 172.16.0.0/16 dev dummy0
  ip route add default via 172.16.0.1 dev dummy0 metric 1000
  echo ">>>> Done"
}

function k3s-install(){
  echo ">>>> Installing K3s"
  set-network
  cd /opt/k3s
  mkdir -p /var/lib/rancher/k3s/agent/images/ 
  mv k3s /usr/local/bin/
  mv k3s-airgap-images-amd64.tar /var/lib/rancher/k3s/agent/images/

  chmod +x /usr/local/bin/k3s
  chmod +x /opt/k3s/install.sh

# For agents
#  INSTALL_K3S_SKIP_DOWNLOAD=true K3S_URL=https://$MASTER_NODE_IP_OR_FQDN:6443 K3S_TOKEN=$TOKEN_TO_USE ./install.sh
  INSTALL_K3S_SKIP_DOWNLOAD=true ./install.sh
  echo ">>>> Done"
}

#call the proper function
$1
