#!/bin/sh

# copy files
install --owner=root --group=root --mode=755 monitord /usr/local/bin/monitord
install --owner=root --group=root --mode=644 40-trigger-monitord-hook.rules /etc/udev/rules.d/40-trigger-monitord-hook.rules
install --owner=root --group=root --mode=644 monitord-hook.service /etc/systemd/system/monitord-hook.service

# reload systemd services definitions
systemctl daemon-reload

# reload udev rules
udevadm control --reload-rules
udevadm trigger
