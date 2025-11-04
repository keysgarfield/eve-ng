#!/bin/bash

set -e

EVE_PATH="${EVE_PATH:-$HOME/eve-ng}"
XML_FILE="$EVE_PATH/eve-ng.xml"
VM_NAME="eve-ng"

echo "======================================"
echo "EVE-NG VM Starter"
echo "======================================"
echo ""

if ! command -v virsh &> /dev/null; then
    echo "Error: virsh is not installed"
    echo "Install with: sudo apt-get install libvirt-clients"
    exit 1
fi

if [ ! -f "$XML_FILE" ]; then
    echo "Error: XML configuration not found at $XML_FILE"
    echo "Please run install.sh first"
    exit 1
fi

if ! virsh list --all | grep -q "$VM_NAME"; then
    echo "VM not defined, importing configuration..."
    virsh define "$XML_FILE"
fi

if virsh list --state-running | grep -q "$VM_NAME"; then
    echo "VM is already running"
    virsh dominfo "$VM_NAME"
else
    echo "Starting EVE-NG VM..."
    virsh start "$VM_NAME"
    echo ""
    echo "======================================"
    echo "VM Started Successfully!"
    echo "======================================"
    virsh dominfo "$VM_NAME"
    echo ""
    echo "To connect via VNC, get the port with:"
    echo "  virsh vncdisplay $VM_NAME"
    echo ""
    echo "To stop the VM, run:"
    echo "  virsh shutdown $VM_NAME"
fi
