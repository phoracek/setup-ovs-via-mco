#!/usr/bin/env bash

set -ex

default_device=${DEFAULT_DEVICE}
secondary_device=${SECONDARY_DEVICE}
profile_name=${PROFILE_NAME}
secondary_profile_name=${SECONDARY_PROFILE_NAME}
clone_mac_on_bridge=${CLONE_MAC_ON_BRIDGE}

mac=$(sudo nmcli -g GENERAL.HWADDR dev show $default_device | sed -e 's/\\//g')

# make bridge
if [[ ! -z ${clone_mac_on_bridge} ]]; then
	sudo nmcli conn add type ovs-bridge conn.interface brcnv 802-3-ethernet.cloned-mac-address $mac
else
	sudo nmcli conn add type ovs-bridge conn.interface brcnv
fi

sudo nmcli conn add type ovs-port conn.interface brcnv-port master brcnv
sudo nmcli conn add type ovs-interface conn.id brcnv-iface conn.interface brcnv master brcnv-port ipv4.method auto ipv4.dhcp-client-id "01:$mac" connection.autoconnect no

# make bond
sudo nmcli conn mod "$profile_name" connection.autoconnect no
sudo nmcli conn mod "$secondary_profile_name" connection.autoconnect no
sudo nmcli conn add type ovs-port conn.interface bond0 master brcnv ovs-port.bond-mode balance-slb
sudo nmcli conn add type ethernet conn.interface $default_device master bond0
sudo nmcli conn add type ethernet conn.interface $secondary_device master bond0
sudo nmcli conn mod brcnv-iface connection.autoconnect yes
