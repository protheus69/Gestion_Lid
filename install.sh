#!/bin/bash

mkdir -p ~/.config/inactivity
cp config ~/.config/inactivity/
cp lid-hibernate.sh /usr/local/bin/
cp lid-hibernate.service /etc/systemd/system/

sudo systemctl enable --now lid-hibernate.service

exit
