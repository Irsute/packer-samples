#!/bin/bash

# Add vagrant user to sudoers.
sudo echo "vagrant ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/vagrant
sudo chmod 440 /etc/sudoers.d/vagrant