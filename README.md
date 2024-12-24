# Cardano Pool Setup

## [guild-deploy](https://cardano-community.github.io/guild-operators/basics/)

``` bash
curl -sS -o guild-deploy.sh https://raw.githubusercontent.com/cardano-community/guild-operators/master/scripts/cnode-helper-scripts/guild-deploy.sh

chmod +x *.sh
```

``` bash
./guild-deploy.sh -b master -t cnode -s pdlcowx
. "${HOME}/.bashrc"
```

This will create ```/opt/cardano/cnode``` and download executeables to ```$HOME/.local/bin```

make sure .bashrc has:

``` bash
export CNODE_HOME=/opt/cardano/cnode
export MEMPOOL_OVERRIDE="+RTS -N4 --disable-delayed-os-memory-return -I0.3 -Iw300 -A16m -n4m -F1.5 -H3G -T -S -RTS"
```

## config

``` bash
nano $CNODE_HOME/files/config.json
```

make sure ```PeerSharing = true``` for relay; ```false``` for bp.

``` bash
nano $CNODE_HOME/files/topology.json
```

- make sure the peers (both relay & bp) are in ```localRoots``` > ```accessPoints```
- ```trustable = true```
- for relay, ```advertise = true```; for bp, turn it off.
- for relay, ```useLedgerAfterSlot: 128908821```; for bp, ```useLedgerAfterSlot: -1```

## Run as systemd service⚓︎

``` bash
cd $CNODE_HOME/scripts/
./cnode.sh -d
```

``` bash
sudo systemctl enable cnode.service
sudo systemctl start cnode.service

sudo systemctl status cnode.service

journalctl -f -u cnode

sudo systemctl enable cnode-submit-api.service
sudo systemctl start cnode-submit-api.service

journalctl -f -u cnode-submit-api

```

1. follow [build cardano node](build-cardano-node.md) to prepare machine/cardano executables.
1. follow [configure.md](./configure.md) for the configurations.
1. follow [operation guide](.op.md).

Info about setting up a cardano pool and SPO (stake pool operator).

- [Guild Operators](https://cardano-community.github.io/guild-operators/)
- [Operate a Stake Pool](https://developers.cardano.org/docs/operate-a-stake-pool/)
- [StakePool Operator Scripts (SPOS)](https://github.com/gitmachtl/scripts)

- [CoinCashew - Guide: How to Set Up a Cardano Stake Pool](https://www.coincashew.com/coins/overview-ada/guide-how-to-build-a-haskell-stakepool-node)

- [CoinCashew - Installing the Glasgow Haskell Compiler and Cabal](https://www.coincashew.com/coins/overview-ada/guide-how-to-build-a-haskell-stakepool-node/part-i-installation/installing-ghc-and-cabal)

- [10.1.3 Release Note](https://github.com/IntersectMBO/cardano-node/releases/tag/10.1.3)
- [Installing the node from source](https://github.com/input-output-hk/cardano-node-wiki/blob/main/docs/getting-started/install.md)
