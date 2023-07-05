#!/bin/bash

# Install tools for testing
sudo apt-get update > /dev/null
sudo apt-get install git libssl-dev libz-dev lua5.1 luarocks iperf3 -y > /dev/null

# Install lua-socket library
sudo luarocks install luasocket > /dev/null

# Clone DeathStarBench
if [ ! -d "./DeathStarBench" ]; then
  echo "Clone DeathStarBench"
  git clone https://github.com/delimitrou/DeathStarBench.git > /dev/null
else
    echo "DeathStarBench already exists"
fi

# Make workload generator
echo "make wrk2"
cd DeathStarBench/wrk2
sudo make > /dev/null