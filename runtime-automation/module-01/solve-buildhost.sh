#!/bin/bash
# Solve script for Module 01: Build LAMP Development Container
# This demonstrates the complete workflow for the learner

set -e

echo "Solving Module 01..." >> /tmp/progress.log

# Ensure we're the rhel user
USER=rhel
HOME=/home/rhel

# Navigate to LAMP development directory
cd $HOME/lamp-dev/bootc

# Create application files from templates
cp app/db-setup.sql.example app/db-setup.sql
cp app/index.php.example app/index.php
cp app/myapp.conf.example app/myapp.conf

echo "Application files created" >> /tmp/progress.log

# Note: We don't actually build/run the container in solve because:
# 1. podman login requires interactive authentication (learner does this)
# 2. This is meant as a reference, not automated completion
# The validation checks that the environment is ready

echo "Module 01 solve completed (files ready)" >> /tmp/progress.log
exit 0
