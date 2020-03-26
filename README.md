# Setup OVS bridge and bond via MCO

Mark workers, so OpenShiftSDK uses OVS installed on the system after reboot:

```bash
for node in $(oc get nodes -l node.openshift.io/os_id=rhel --no-headers=true -o name | awk -F/ '{print $2}'); do
  oc label node $node network.operator.openshift.io/external-openvswitch=true
done
```

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

Render MachineConfig template with this script encoded as BASE64 and variables
we have set:

```bash
export SCRIPT_BASE64=$(base64 -w 0 setup-ovs.sh)
envsubst '${DEFAULT_DEVICE} ${SECONDARY_DEVICE} ${PROFILE_NAME} ${SECONDARY_PROFILE_NAME} ${SCRIPT_BASE64}' < machineconfig.yaml.tmpl > machineconfig.yaml
```

Finally, apply the MachineConfig:

```bash
oc apply -f machineconfig.yaml
```
