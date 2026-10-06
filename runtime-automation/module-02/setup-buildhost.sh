#!/bin/bash
# Setup script for Module 02
# No additional setup needed - module assumes container from Module 01 is running

set -e

echo "Setting up Module 02..." >> /tmp/progress.log

# Verify container is running from Module 01
if ! podman ps | grep -q lamp-dev; then
    echo "WARNING: lamp-dev container not running - Module 01 should be completed first" >> /tmp/progress.log
fi

echo "Module 02 setup complete" >> /tmp/progress.log
exit 0
