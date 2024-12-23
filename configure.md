# Cardano Pool Configuration

## Creating a Non-root User with sudo Privileges

``` bash
# Create a new user called cardano
sudo useradd -m -s /bin/bash cardano

# Set the password for cardano user
sudo passwd cardano

# Add cardano to the sudo group
sudo usermod -aG sudo cardano
```

in archlinux:

``` bash
pacman -S sudo
usermod -aG sudo cardano

sudo -lU cardano
```

## setup files

``` bash
# switch to the cardano user
su -l cardano


```

1. copy files to /home/cardano

1. download config files
1. Configuring Topology

## Relay

``` bash
sudo iptables -I INPUT -p tcp -m tcp --dport <RELAY NODE PORT> --tcp-flags FIN,SYN,RST,ACK SYN -m connlimit --connlimit-above 5 --connlimit-mask 32 --connlimit-saddr -j REJECT --reject-with tcp-reset
```

## Block Producer

``` bash
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow 22/tcp

# allow only relay to bp port
sudo ufw allow proto tcp from 45.77.133.15 to any port 6000
sudo ufw allow proto tcp from 66.187.76.81 to any port 6000

sudo ufw enable
sudo ufw status
```

Verifying Listening Ports

``` bash
netstat -tulpn

ss -tulpn
```

## References

- [operate-a-stake-pool](https://developers.cardano.org/docs/operate-a-stake-pool/generating-wallet-keys)
- [Solving the Cardano node huge memory usage](https://forum.cardano.org/t/solving-the-cardano-node-huge-memory-usage-done/67032/37)
- [Configuring Glasgow Haskell Compiler Runtime System Options](https://www.coincashew.com/coins/overview-ada/guide-how-to-build-a-haskell-stakepool-node/part-v-tips/configuring-runtime-options)
