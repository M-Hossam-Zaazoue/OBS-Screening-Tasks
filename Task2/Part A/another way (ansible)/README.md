# Task 2
## A) K8s Setup

#### Setup

- VM Ubuntu with IP address `192.168.172.129` (ansible server)
- VM Ubuntu with IP address `192.168.172.131` (K8s Master node)
- VM Ubuntu with IP address `192.168.172.132` (K8s Worker node)

#### Steps

1. on ansible server, install ansible, generate key pair and copy the public key

2. Run `nodeSetup.sh` script with public key as argument on both K8s nodes as root user 

3. Test by ansible ping

4. Run `install-k8s.yml` playbook 

5. Run `init-master.yml` playbook 

6. Run `join-worker.yml` playbook 

7. Verify cluster status