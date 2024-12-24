# Cardano Pool Configuration

## Creating a Non-root User with sudo Privileges

``` bash
# Create a new user called cardano
sudo useradd -m -s /bin/bash cardano

# Set the password for cardano user
sudo passwd cardano

# Add cardano to the sudo group
usermod -aG sudo cardano
```

in archlinux:

``` bash
pacman -S sudo
usermod -aG sudo cardano

sudo -lU cardano
```

## copy files to /home/cardano

``` bash
# switch to the cardano user
su -l cardano

# clone
git clone https://github.com/mingster/cardano.git .

cd cardano
mv * ..
```

Link config.json & topology.json for relay / block producer

``` bash
cd config

# e.g. on block producer
ln -s -f config-bp.json config.json
ln -s -f ln -s -f topology-bp.json topology.json
```

## Firewall

- relay

``` bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp

# allow only bp and peer relay to the port
sudo ufw allow proto tcp from 66.187.76.81 to any port 6000
sudo ufw allow proto tcp from 45.77.133.15 to any port 6000
sudo ufw allow proto tcp from 220.135.171.33 to any port 6000

sudo ufw enable
sudo ufw status
```

- Block Producer

``` bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp

# allow only relay to the port
sudo ufw allow proto tcp from 45.77.133.15 to any port 6000
sudo ufw allow proto tcp from 66.187.76.81 to any port 6000

sudo ufw enable
sudo ufw status
```

## Review and test run startCardanoNode.sh

``` bash
bash startCardanoNode.sh
```

## Service Scripts

``` bash
sudo mv $NODE_HOME/cardano-node.service /etc/systemd/system/cardano-node.service
sudo chmod 644 /etc/systemd/system/cardano-node.service

sudo systemctl daemon-reload
sudo systemctl enable cardano-node.service

sudo systemctl start cardano-node.service
journalctl --unit=cardano-node --follow
```

## Verifying Listening Ports

``` bash
netstat -tulpn

ss -tulpn
```

## References

- [operate-a-stake-pool](https://developers.cardano.org/docs/operate-a-stake-pool/generating-wallet-keys)
- [Solving the Cardano node huge memory usage](https://forum.cardano.org/t/solving-the-cardano-node-huge-memory-usage-done/67032/37)
- [Configuring Glasgow Haskell Compiler Runtime System Options](https://www.coincashew.com/coins/overview-ada/guide-how-to-build-a-haskell-stakepool-node/part-v-tips/configuring-runtime-options)
- [CNODE (Guild-Operators)](https://cardano-community.github.io/guild-operators/)
