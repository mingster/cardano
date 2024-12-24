# Cardano node setup

info about setting up a cardano pool.

- [Guide: How to Set Up a Cardano Stake Pool](https://www.coincashew.com/coins/overview-ada/guide-how-to-build-a-haskell-stakepool-node)
- [Operate a Stake Pool](https://developers.cardano.org/docs/operate-a-stake-pool/)
- [StakePool Operator Scripts (SPOS)](https://github.com/gitmachtl/scripts)
- [Installing the node from source](https://github.com/input-output-hk/cardano-node-wiki/blob/main/docs/getting-started/install.md)
- [CoinCashew - Installing the Glasgow Haskell Compiler and Cabal](https://www.coincashew.com/coins/overview-ada/guide-how-to-build-a-haskell-stakepool-node/part-i-installation/installing-ghc-and-cabal)
- [10.1.3 Release Note](https://github.com/IntersectMBO/cardano-node/releases/tag/10.1.3)

## Install on Ubuntu 24.x

``` bash
sudo apt-get update -y && sudo apt-get upgrade -y
```

### Dependencies & Build tools

1. Add archive for libncursesw5:

    ``` bash
    su
    nano /etc/apt/sources.list.d/ubuntu.sources
    ```

    And append this source:

    ``` text
    Types: deb
    URIs: http://security.ubuntu.com/ubuntu
    Suites: focal-security
    Components: main universe
    Signed-By: /usr/share/keyrings/ubuntu-archive-keyring.gpg
    ```

1. install libncurses5

    ``` bash
    sudo apt-get update -y
    sudo apt install libncurses5
    ```

1. Remove the archive source when done.

1. build tools

    ``` bash
    sudo apt-get install autoconf automake build-essential curl g++ git jq libffi-dev libgmp-dev libssl-dev libsystemd-dev libtinfo-dev libtool make pkg-config tmux wget zlib1g-dev liblmdb-dev -y
    ```

### Installing the Haskell environment

``` bash
sudo apt-get install build-essential curl libffi-dev libffi8ubuntu1 libgmp-dev libgmp10 libncurses-dev -y

curl --proto '=https' --tlsv1.2 -sSf https://get-ghcup.haskell.org | sh

source $HOME/.bashrc
ghcup --version
```

``` bash
# run ghcup tui to determine latest version
ghcup install ghc 8.10.7
ghcup set ghc 8.10.7
ghc --version

ghcup install cabal 3.10.2.0
ghcup set cabal 3.10.2.0
cabal --version
```
to remove:

``` bash
ghcup rm ghc <version>

rm -rf /.cabal/store/ghc-<version>
```

### [cardano-node](https://github.com/IntersectMBO/cardano-node/tags)

``` bash
mkdir $HOME/GitHub
```

env variables:

``` bash
CARDANO_NODE_VERSION='10.1.3'
IOHKNIX_VERSION=$(curl https://raw.githubusercontent.com/IntersectMBO/cardano-node/$CARDANO_NODE_VERSION/flake.lock | jq -r '.nodes.iohkNix.locked.rev')
echo "iohk-nix version: $IOHKNIX_VERSION"
```

### Installing sodium

Cardano uses a custom fork of sodium which exposes some internal functions and adds some other new functions. This fork lives in https://github.com/intersectmbo/libsodium. Users need to install that custom version of sodium with the following steps.

Find out the correct sodium version for your build:

``` bash
SODIUM_VERSION=$(curl https://raw.githubusercontent.com/input-output-hk/iohk-nix/$IOHKNIX_VERSION/flake.lock | jq -r '.nodes.sodium.original.rev')
echo "Using sodium version: $SODIUM_VERSION"
```

Download and install sodium:

``` bash
cd $HOME/GitHub
git clone https://github.com/input-output-hk/libsodium
#git clone https://github.com/intersectmbo/libsodium

cd libsodium
git checkout $SODIUM_VERSION
./autogen.sh
./configure
make
sudo make install
```

If you are using Ubuntu on a Raspberry Pi 4, then type the following command to resolve a cannot find -lnuma error message when compiling libsodium:

``` bash
sudo apt install libsodium-dev
```

### Installing secp256k1

``` text
SECP256K1_VERSION=$(curl https://raw.githubusercontent.com/input-output-hk/iohk-nix/$IOHKNIX_VERSION/flake.lock | jq -r '.nodes.secp256k1.original.ref')

echo "Using secp256k1 version: ${SECP256K1_VERSION}"
```

``` bash

cd $HOME/GitHub/

git clone --depth 1 --branch ${SECP256K1_VERSION} https://github.com/bitcoin-core/secp256k1

cd secp256k1
./autogen.sh
./configure --enable-module-schnorrsig --enable-experimental
make
make check
sudo make install
sudo ldconfig
```

### Installing blst

Find out the correct blst version:

``` text
BLST_VERSION=$(curl https://raw.githubusercontent.com/input-output-hk/iohk-nix/master/flake.lock | jq -r '.nodes.blst.original.ref')

echo "Using blst version: ${BLST_VERSION}"
```

Download and install blst so that cardano-base can pick it up (assuming that pkg-config is installed):

``` bash
cd $HOME/GitHub/

git clone https://github.com/supranational/blst

cd blst
git checkout ${BLST_VERSION}

./build.sh

cat > libblst.pc << EOF
prefix=/usr/local
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
includedir=\${prefix}/include

Name: libblst
Description: Multilingual BLS12-381 signature library
URL: https://github.com/supranational/blst
Version: 0.3.11
Cflags: -I\${includedir}
Libs: -L\${libdir} -lblst
EOF
sudo cp libblst.pc /usr/local/lib/pkgconfig/
sudo cp bindings/blst_aux.h bindings/blst.h bindings/blst.hpp /usr/local/include/
sudo cp libblst.a /usr/local/lib
sudo chmod u=rw,go=r /usr/local/{lib/{libblst.a,pkgconfig/libblst.pc},include/{blst.{h,hpp},blst_aux.h}}
```

### Installing the node

Using a text editor, open the $HOME/.bashrc file, and then add the following lines at the end of the file:

``` bash
# Set environment variables so that the compiler finds libsodium on your computer
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
export PKG_CONFIG_PATH="/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH"
# Set an environment variable indicating the file path to configuration files and scripts
# related to operating your Cardano node
export NODE_HOME="$HOME/cardano-my-node"
# Set an environment variable indicating the Cardano network cluster where your node runs
export NODE_CONFIG="mainnet"

export PATH="$HOME/.local/bin:$PATH"
```

To reload your shell profile, type:

``` bash
source $HOME/.bashrc
```

Download the Cardano node sources:

``` bash
cd $HOME/GitHub/

git clone https://github.com/IntersectMBO/cardano-node.git

```

Change the working directory to the downloaded source code folder:

``` bash
cd cardano-node
```

Check out the latest version of cardano-node (choose the tag with the highest version number: TAGGED-VERSION):

``` bash
git fetch --all --recurse-submodules --tags
```

### latest

``` bash
git checkout $(curl -s https://api.github.com/repos/IntersectMBO/cardano-node/releases/latest | jq -r .tag_name)
```

### specify a version

``` bash
git tag | sort -V

#git checkout tags/<TAGGED VERSION>
git checkout tags/10.1.3
```

#### Building and installing the node

Build the node and CLI with cabal:

``` bash
cabal update
#cabal configure -O0 -w ghc-<GHCVersionNumber>
cabal configure -O0 -w ghc-8.10.7

cabal build all
cabal build cardano-cli
```

Install the newly built node and CLI commands to the ```$HOME/.local/bin``` directory:

``` bash
mkdir -p $HOME/.local/bin

cp -p "$(./scripts/bin-path.sh cardano-node)" $HOME/.local/bin/
cp -p "$(./scripts/bin-path.sh cardano-cli)" $HOME/.local/bin/
```

Note: If cardano-cli does not build with ```cabal build all```, run ```cabal build cardano-cli```.

Note: ```$HOME/.local/bin``` should be in the $PATH.

Note, we avoid using cabal install because that method prevents the installed binaries from reporting the git revision with the --version switch.

Check the version that has been installed:

``` bash
cardano-cli --version
```

Repeat the above process when you need to update to a new version.

Note: It might be necessary to delete the db-folder (the database-folder) before running an updated version of the node.

Add Path:

``` bash
export PATH="$HOME/.local/bin:$PATH"
```

## Next Up

[configure the nodes](configure.md).
