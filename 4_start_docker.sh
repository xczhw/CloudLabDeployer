cd DeathStarBench/socialNetwork

# Swarm
echo "Start Swarm"
sudo docker stack deploy --compose-file=docker-compose-swarm.yml dsb

sleep 10
# Register users and construct social graphs
echo "Register users and construct social graphs"
python3 scripts/init_social_graph.py --graph=socfb-Reed98
