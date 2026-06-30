#docker buildx rm $(docker buildx ls | grep docker-container | awk '{print $1}')
docker builder prune -a --volumes
docker system prune -a --volumes
docker buildx prune -f
#docker system df
