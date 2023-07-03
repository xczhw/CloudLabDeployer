#!/bin/bash

# Clone DeathStarBench
if [ ! -d "./DeathStarBench" ]; then
  echo "Clone DeathStarBench"
  git clone https://github.com/delimitrou/DeathStarBench.git > /dev/null
else
    echo "DeathStarBench already exists"
fi

# Run workload generator
## make
echo "make wrk2"
cd ../wrk2
sudo make

## back to socialNetwork
cd ../socialNetwork

# register users
python3 scripts/init_social_graph.py --graph=socfb-Reed98

# Compose posts
echo "Compose posts"
../wrk2/wrk -D exp -L -t 2 -c 100 -d 30s -s ./wrk2/scripts/social-network/compose-post.lua http://localhost:8080/wrk2-api/post/compose -R 100