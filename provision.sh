#!/bin/bash

INSTALL_DEPENDENCIES=0
START_ANNOUNCEMENT=0

while [[ $# -gt 0 ]]; do
  case $1 in
    -i|--install)
      INSTALL_DEPENDENCIES=1
      shift
      ;;
    -s|--start)
      START_ANNOUNCEMENT=1
      shift
      ;;
    -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
  esac
done

# Check permissions
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root"
    exit    
fi

if [ ! -f /lib/systemd/system/hciuart.service ]; then
    echo "Please make sure you got right drivers for your bluetooth"
fi

# Check bluez-tools dependency
if ! command -v bt-network &> /dev/null; then
    echo "Bluez-tools package not found"
    if [[ $INSTALL_DEPENDENCIES -eq 1 ]]; then
        apt-get install bluez-tools -y
    else
        echo "Please install run 'apt-get install bluez-tools'"
    fi
fi

# Check if ran from oneliner or git clone
if ([ ! -d systemd-files ])
then
    rm -rf /tmp/bt-pan
    git clone https://github.com/Mirdinus/bt-pan /tmp/bt-pan
    cd /tmp/bt-pan
fi

# Copy necessary systemd files
if [[ ! ( -f /etc/systemd/network/pan0.netdev && -f /etc/systemd/network/pan0.network ) ]]; then
    cp ./systemd-files/pan0.netdev /etc/systemd/network/pan0.netdev
    cp ./systemd-files/pan0.network /etc/systemd/network/pan0.network
fi

if [[ ! ( -f /etc/systemd/system/bt-agent.service && -f /etc/systemd/system/bt-network.service ) ]]; then
    cp ./systemd-files/bt-agent.service /etc/systemd/system/bt-agent.service
    cp ./systemd-files/bt-network.service /etc/systemd/system/bt-network.service
fi

# Enable systemd services
SERVICES=( "systemd-networkd" "bt-network" "bt-agent" )

for SERVICE in ${SERVICES[@]}
do
    if ! systemctl is-enabled $SERVICE > /dev/null; then
        systemctl enable $SERVICE
    fi
done

# Allow devices to pair if
if [[ $START_ANNOUNCEMENT -eq 1 ]]; then
    systemctl start systemd-networkd
    systemctl start bt-agent
    systemctl start bt-network

    # Sleep to allow all the services to raise
    sleep 2

    bt-adapter --set Discoverable 1
fi



# dpkg -l