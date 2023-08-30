echo "Compose posts"
# Compose posts

cd DeathStarBench/socialNetwork
../wrk2/wrk -D exp -L -t 16 -c 100 -d 30s -s ./wrk2/scripts/social-network/compose-post.lua http://node0:8080/wrk2-api/post/compose -R 100