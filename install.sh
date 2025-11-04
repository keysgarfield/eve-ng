#!/bin/bash

set -e

EVE_ISO_URL="https://customers.eve-ng.net/eve-ce-prod-6.2.0-4-full.iso"
EVE_PATH="${EVE_PATH:-$HOME/eve-ng}"
ISO_FILE="$EVE_PATH/eve-ng.iso"
QCOW2_FILE="$EVE_PATH/eve-ng.qcow2"
XML_FILE="$EVE_PATH/eve-ng.xml"

echo "======================================"
echo "EVE-NG Image Downloader & Converter"
echo "======================================"
echo ""

if ! command -v qemu-img &> /dev/null; then
    echo "Error: qemu-img is not installed"
    echo "Install with: sudo apt-get install qemu-utils"
    exit 1
fi

mkdir -p "$EVE_PATH"
echo "EVE_PATH: $EVE_PATH"
echo ""

if [ -f "$ISO_FILE" ]; then
    echo "ISO file already exists: $ISO_FILE"
    read -p "Overwrite? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping download..."
    else
        echo "Downloading EVE-NG ISO..."
        wget -O "$ISO_FILE" "$EVE_ISO_URL"
    fi
else
    echo "Downloading EVE-NG ISO..."
    wget -O "$ISO_FILE" "$EVE_ISO_URL"
fi

echo ""
echo "Converting ISO to QCOW2 format..."
qemu-img convert -f raw -O qcow2 "$ISO_FILE" "$QCOW2_FILE"

echo ""
echo "Generating libvirt XML configuration..."
cat > "$XML_FILE" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<domain type="kvm">
  <name>eve-ng</name>
  <uuid>00000000-0000-0000-0000-000000000000</uuid>
  <memory unit="GiB">8</memory>
  <currentMemory unit="GiB">8</currentMemory>
  <vcpu placement="static">8</vcpu>
  <os>
    <type arch="x86_64" machine="pc">hvm</type>
    <boot dev="hd"/>
  </os>
  <features>
    <acpi/>
    <apic/>
    <pae/>
  </features>
  <cpu mode="host-passthrough">
    <topology sockets="1" cores="8" threads="1"/>
  </cpu>
  <clock offset="utc">
    <timer name="rtc" tickpolicy="catchup"/>
    <timer name="pit" tickpolicy="delay"/>
    <timer name="hpet" present="no"/>
  </clock>
  <on_poweroff>destroy</on_poweroff>
  <on_reboot>restart</on_reboot>
  <on_crash>restart</on_crash>
  <devices>
    <emulator>/usr/bin/qemu-system-x86_64</emulator>
    <disk type="file" device="disk">
      <driver name="qemu" type="qcow2" cache="writeback"/>
      <source file="$QCOW2_FILE"/>
      <target dev="vda" bus="virtio"/>
      <address type="pci" domain="0x0000" bus="0x00" slot="0x04" function="0x0"/>
    </disk>
    <controller type="usb" index="0" model="ich9-ehci1"/>
    <controller type="pci" index="0" model="pci-root"/>
    <interface type="network">
      <source network="default"/>
      <model type="virtio"/>
      <address type="pci" domain="0x0000" bus="0x00" slot="0x03" function="0x0"/>
    </interface>
    <serial type="pty">
      <target port="0"/>
    </serial>
    <console type="pty">
      <target type="serial" port="0"/>
    </console>
    <input type="tablet" bus="usb"/>
    <input type="mouse" bus="ps2"/>
    <input type="keyboard" bus="ps2"/>
    <graphics type="vnc" port="-1" autoport="yes" listen="0.0.0.0">
      <listen type="address" address="0.0.0.0"/>
    </graphics>
    <video>
      <model type="cirrus" vram="16384" heads="1"/>
      <address type="pci" domain="0x0000" bus="0x00" slot="0x02" function="0x0"/>
    </video>
    <memballoon model="virtio">
      <address type="pci" domain="0x0000" bus="0x00" slot="0x05" function="0x0"/>
    </memballoon>
  </devices>
</domain>
EOF

echo ""
echo "======================================"
echo "Setup Complete!"
echo "======================================"
echo "ISO file: $ISO_FILE"
echo "QCOW2 file: $QCOW2_FILE"
echo "XML config: $XML_FILE"
echo ""
echo "To create the VM, run:"
echo "  virsh define $XML_FILE"
echo "  virsh start eve-ng"
echo ""
