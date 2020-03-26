#!/usr/bin/env bash

set -ex

default_device=${DEFAULT_DEVICE}
secondary_device=${SECONDARY_DEVICE}
profile_name=${PROFILE_NAME}
secondary_profile_name=${SECONDARY_PROFILE_NAME}

mac=$(sudo nmcli -g GENERAL.HWADDR dev show $default_device | sed -e 's/\\//g')

# make bridge
nmcli conn add type ovs-bridge conn.interface brcnv ipv4.dhcp-client-id 01:$mac
nmcli conn add type ovs-port conn.interface port0 master brcnv
nmcli conn add type ovs-port conn.interface brcnv-port master brcnv
nmcli conn add type ovs-interface conn.id brcnv-iface conn.interface brcnv master brcnv-port ipv4.method auto connection.autoconnect no

# make bond
nmcli conn add type ovs-port conn.interface bond0 master brcnv ovs-port.bond-mode balance-slb
nmcli conn add type ethernet conn.interface $default_device master bond0
nmcli conn add type ethernet conn.interface $secondary_device master bond0
nmcli conn down "$profile_name" || true
nmcli conn mod "$profile_name" connection.autoconnect no
nmcli conn down "$secondary_profile_name" || true
nmcli conn mod "$secondary_profile_name" connection.autoconnect no
nmcli conn up brcnv-iface
nmcli conn mod brcnv-iface connection.autoconnect yes
