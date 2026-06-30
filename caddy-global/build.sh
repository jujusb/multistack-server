# Step 1: Build ARM64 image
cd caddy-global
docker buildx create --use  # if not already using buildx
docker buildx build --platform linux/arm64 -t caddy:2-built --load .