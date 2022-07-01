# Task 2
## A) K8s Setup

#### Setup

- VM Ubuntu with IP address `192.168.172.131` (Master node)
- VM Ubuntu with IP address `192.168.172.132` (Worker node)

#### Steps

1. Run `masterSetup.sh` script on master node as root user

2. Run `workerSetup.sh` script on worker node as root user and pass ip of master, token and sha256 hash as arguments

3. Verify cluster status