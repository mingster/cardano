# Operations


## gLiveView

To monitor your Cardano nodes, install gLiveView.
gLiveView displays crucial node status information and works well with systemd services.

``` bash

cd $NODE_HOME
sudo apt install bc tcptraceroute jq -y

curl -s -o gLiveView.sh https://raw.githubusercontent.com/cardano-community/guild-operators/master/scripts/cnode-helper-scripts/gLiveView.sh

curl -s -o env https://raw.githubusercontent.com/cardano-community/guild-operators/master/scripts/cnode-helper-scripts/env

chmod 755 gLiveView.sh
```

Run the following to modify env with the updated file locations.

``` bash
sed -i env \
    -e "s/\#CONFIG=\"\${CNODE_HOME}\/files\/config.json\"/CONFIG=\"\${NODE_HOME}\/config.json\"/g" \
    -e "s/\#SOCKET=\"\${CNODE_HOME}\/sockets\/node0.socket\"/SOCKET=\"\${NODE_HOME}\/db\/socket\"/g"
```

Review the ```env``` file.

## Generating Keys for the Block-producing Node

- [Generating Keys for the Block-producing Node](https://www.coincashew.com/coins/overview-ada/guide-how-to-build-a-haskell-stakepool-node/part-iii-operation/generating-keys-for-the-block-producing-node)

``` bash
cd $NODE_HOME

cardano-cli conway node key-gen-KES \
    --verification-key-file kes.vkey \
    --signing-key-file kes.skey
```

## Referneces

[Starting the nodes](https://www.coincashew.com/coins/overview-ada/guide-how-to-build-a-haskell-stakepool-node/part-iii-operation/starting-the-nodes)
