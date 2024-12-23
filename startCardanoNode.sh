#!/bin/bash

NODE_HOME=/home/cardano

#
# Set variables to indicate Cardano Node options
#
# Set a variable to indicate the port where the Cardano Node listens
PORT=6000
# Set a variable to indicate the local IP address of the computer where Cardano Node runs
# 0.0.0.0 listens on all local IP addresses for the computer
HOSTADDR=0.0.0.0
# Set a variable to indicate the file path to your topology file
TOPOLOGY=${NODE_HOME}/config/topology.json
# Set a variable to indicate the folder where Cardano Node stores blockchain data
DB_PATH=${NODE_HOME}/db
# Set a variable to indicate the path to the Cardano Node socket for Inter-process communication (IPC)
SOCKET_PATH=${NODE_HOME}/db/socket
# Set a variable to indicate the file path to your main Cardano Node configuration file
CONFIG=${NODE_HOME}/config/config.json

# Run Cardano Node using the options that you set using variables
#

${NODE_HOME}/bin/cardano-node run --topology ${TOPOLOGY} \
    --database-path ${DB_PATH} --socket-path ${SOCKET_PATH} \
    --host-addr ${HOSTADDR} --port ${PORT} --config ${CONFIG} \
    +RTS -N4 --disable-delayed-os-memory-return -I0.3 -Iw300 -A16m -n4m -F1.5 -H3G -T -S -RTS
