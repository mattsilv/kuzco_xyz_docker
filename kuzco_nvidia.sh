#!/bin/bash

# Variables
IMAGE_NAME="kuzcoxyz/worker:latest"
NUM_CONTAINERS=${1:-1}
WORKER=${2:-"default_worker"}
CODE=${3:-"default_code"}

# Define the name pattern for the containers you want to stop
NAME_PATTERN="kuzcoxyz_worker_latest"

# Command arguments
COMMAND_ARGS="--worker $WORKER --code $CODE"

# Pull the latest image
docker pull $IMAGE_NAME

# Function to start a container with a specific GPU
start_container() {
    local container_name=$1
    local gpu_device=$2
    echo "Starting container $container_name with GPU $gpu_device..."
    docker run --rm --runtime=nvidia --gpus "device=$gpu_device" -d --name $container_name $IMAGE_NAME $COMMAND_ARGS
}

# Stop and remove all running containers of the specified image
running_containers=$(docker ps --filter "name=$NAME_PATTERN" -q)
if [ ! -z "$running_containers" ]; then
    echo "Stopping and removing running containers..."
    docker stop $running_containers
fi

sleep 5

# Get the list of available GPU devices
gpu_devices=$(nvidia-smi --query-gpu=index --format=csv,noheader)
gpu_array=($gpu_devices)
num_gpus=${#gpu_array[@]}

# Start the specified number of containers, evenly distributing GPUs
for i in $(seq 1 $NUM_CONTAINERS); do
    gpu_index=$(( (i - 1) % num_gpus ))
    start_container "${IMAGE_NAME//[:\/]/_}_$i" "${gpu_array[$gpu_index]}"
    sleep 30
done

echo "$NUM_CONTAINERS containers started with image $IMAGE_NAME using worker $WORKER and code $CODE."
