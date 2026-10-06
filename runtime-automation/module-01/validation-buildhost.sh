#!/bin/bash
# Validation script for Module 01: Build LAMP Development Container
# This validates that the lab environment is ready and learner has completed basic tasks

set -e

echo "Validating Module 01..." >> /tmp/progress.log

# Check if LAMP development directory exists
if [ ! -d /home/rhel/lamp-dev/bootc ]; then
    echo "FAIL: LAMP development directory not found" >> /tmp/progress.log
    exit 1
fi

# Check if template files exist
if [ ! -f /home/rhel/lamp-dev/bootc/Containerfile ]; then
    echo "FAIL: Containerfile not found" >> /tmp/progress.log
    exit 1
fi

# Check if libvirt is running
if ! systemctl is-active --quiet libvirtd; then
    echo "FAIL: libvirtd is not running" >> /tmp/progress.log
    exit 1
fi

# Check if podman is available
if ! command -v podman &> /dev/null; then
    echo "FAIL: podman not installed" >> /tmp/progress.log
    exit 1
fi

# Success
echo "Module 01 validation passed" >> /tmp/progress.log
exit 0
