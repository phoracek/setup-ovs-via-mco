# Setup OVS bridge and bond via MCO

Login to your hosts and figure out which interfaces you want to bond. Then
export names of relevant NICs as environment variables:

```bash
export DEFAULT_DEVICE=enp1s0
export SECONDARY_DEVICE=enp2s0
```

Find active profiles of these interfaces with `nmcli c` and export their names
too:

```bash
export PROFILE_NAME='Wired connection 1'
export SECONDARY_PROFILE_NAME='Wired connection 2'
```

Specify whether the MAC of the primary device should be explicitly assigned to the bridge:

```bash
export CLONE_MAC_ON_BRIDGE=1
```

Render configuration script to setup OVS bridge and bonds with these values:

```bash
envsubst '${DEFAULT_DEVICE} ${SECONDARY_DEVICE} ${PROFILE_NAME} ${SECONDARY_PROFILE_NAME} ${CLONE_MAC_ON_BRIDGE}' < setup-ovs.sh.tmpl > setup-ovs.sh
```

Render MachineConfig template with this script encoded as BASE64:

```bash
export SCRIPT_BASE64=$(base64 -w 0 setup-ovs.sh)
envsubst '${SCRIPT_BASE64}' < machineconfig.yaml.tmpl > machineconfig.yaml
```

Finally, apply the MachineConfig:

```bash
oc apply -f machineconfig.yaml
```
