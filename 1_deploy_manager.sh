## Install Docker
if command -v docker >/dev/null 2>&1; then 
  echo 'exists docker' 
else 
  curl -fsSL https://test.docker.com -o test-docker.sh
  sudo sh test-docker.sh
fi

## Install All Dependencies in Ubuntu
echo "Install All Dependencies in Ubuntu"
sudo apt-get update > /dev/null
sudo apt-get install docker-compose python3-pip git libssl-dev libz-dev lua5.1 luarocks -y > /dev/null
# Install tools for testing
sudo apt-get install iperf3 htop -y > /dev/null

# Install lua-socket library
sudo luarocks install luasocket > /dev/null

# Install python libraries
pip install aiohttp > /dev/null
pip install asyncio > /dev/null

# Description: Docker installation and configuration
# if not in any docker swarm
sudo usermod -aG docker $USER

sudo docker swarm leave --force || true
sudo docker swarm init --advertise-addr=10.10.1.1

# Clone DeathStarBench
if [ ! -d "./DeathStarBench" ]; then
  echo "Clone DeathStarBench"
  git clone https://github.com/delimitrou/DeathStarBench.git
else
    echo "DeathStarBench already exists"
fi