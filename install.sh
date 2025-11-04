#!/bin/bash

set -e

EVE_ISO_URL="https://customers.eve-ng.net/eve-ce-prod-6.2.0-4-full.iso"
EVE_PATH="${EVE_PATH:-$HOME/eve-ng}"
ISO_FILE="$EVE_PATH/eve-ng.iso"
QCOW2_FILE="$EVE_PATH/eve-ng.qcow2"

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
echo "======================================"
echo "Conversion Complete!"
echo "======================================"
echo "ISO file: $ISO_FILE"
echo "QCOW2 file: $QCOW2_FILE"
echo ""
