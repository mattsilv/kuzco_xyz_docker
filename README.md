# Kuzco NVIDIA Worker Script

This script is designed to run Docker **NVIDIA** workers for [kuzco.xyz](https://kuzco.xyz/), a project for the distributed GPU cluster for LLM inference on Solana. The script, named `kuzco_nvidia.sh`, handles pulling the latest Docker image, stopping any existing containers, and starting new containers across available GPUs.

## Prerequisites

- [Kuzco Docker Setup](https://docs.kuzco.xyz/docker)
- `nvidia-smi` command available

## Usage

### Running the Script

1. Save the script as `kuzco_nvidia.sh`.
2. Make the script executable:
   ```bash
   chmod +x kuzco_nvidia.sh
   ```
3. Run the script with the desired number of containers, worker ID, and code:
    ```bash
    ./kuzco_nvidia.sh <NUM_CONTAINERS> <WORKER_ID> <CODE>
    ```

**Example**

To run 3 containers with a specific worker ID and code:

```bash
./kuzco_nvidia.sh 3 "your_worker_id" "your_code"
```

### Setting Up a Cron Job
To ensure the Docker image is updated and containers are restarted daily, you can set up a cron job.

1. Open the crontab editor:
  ```bash
  crontab -e
  ```
2. Add the following line to run the script every day at 2 AM. Adjust the path to your script as needed:
  ```bash
  0 2 * * * /path/to/kuzco_nvidia.sh <NUM_CONTAINERS> <WORKER_ID> <CODE> >> /root/kuzco.log 2>&1
  ```

### Configuring the Number of Workers

The number of workers you can run depends on the GPU capacity of your machine. The script will distribute the containers evenly across available GPUs. Ensure you have sufficient resources (memory, GPU power) to handle the desired number of containers.
