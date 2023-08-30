#!/bin/bash
set -e

python3 get_urls.py
source manager_ips.sh
source worker_ips.sh
source client_ips.sh
rm manager_ips.sh
rm worker_ips.sh
rm client_ips.sh

ssh -o "StrictHostKeyChecking=no" ${MANAGER_IPS} 'bash -s' < ./1_deploy_manager.sh

echo "create join.sh"
echo -n "sudo" > join.sh
ssh -o "StrictHostKeyChecking=no" ${MANAGER_IPS} sudo docker swarm join-token worker | grep docker >> join.sh

# deploy workers
echo "deploy workers"
count=${#WORKER_IPS[@]}
cat ./2_deploy_worker.sh ./join.sh > ./deploy_worker.sh
for ((i=0;i<$count;i++)); do
  echo "deploy worker $i"
  ssh -o "StrictHostKeyChecking=no" ${WORKER_IPS[i]} 'bash -s' < ./deploy_worker.sh
done
wait
rm join.sh
rm deploy_worker.sh

echo "deploy clients"
ssh -o "StrictHostKeyChecking=no" ${CLIENT_IPS} 'bash -s' < ./3_deploy_client.sh

# echo "start docker"
# ssh -o "StrictHostKeyChecking=no" ${MANAGER_IPS} 'bash -s' < ./4_start_docker.sh
