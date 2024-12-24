#!/bin/bash

cat <<EOF >>.bashrc

# Set an environment variable indicating the file path to configuration files and scripts

# related to operating your Cardano node
export NODE_HOME="$HOME"

export PATH="$HOME/bin:$PATH"
EOF

mkdir -p ${HOME}/db/

sudo mv $NODE_HOME/cardano-node.service /etc/systemd/system/cardano-node.service
sudo chmod 644 /etc/systemd/system/cardano-node.service

sudo systemctl daemon-reload
sudo systemctl enable cardano-node.service

sudo systemctl start cardano-node.service
journalctl --unit=cardano-node --follow
