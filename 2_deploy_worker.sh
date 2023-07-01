#!/bin/bash

# Install tools for testing
echo "Install tools for testing"
sudo apt-get update > /dev/null
sudo apt-get install iperf3 htop -y > /dev/null

# Install Docker
echo "In stall docker in "
if command -v docker >/dev/null 2>&1; then 
  echo 'exists docker' 
else 
  curl -fsSL https://test.docker.com -o test-docker.sh
  sudo sh test-docker.sh > /dev/null
fi

# Clone DeathStarBench
if [ ! -d "./DeathStarBench" ]; then
  echo "Clone DeathStarBench"
  git clone https://github.com/delimitrou/DeathStarBench.git > /dev/null
else
    echo "DeathStarBench already exists"
fi

sudo docker swarm leave --force || true > /dev/null
