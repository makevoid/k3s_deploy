# k3s-deploy

Setup a K3S cluster with one master and two workers on 3 VMs

---


 My recommendation is to follow this Readme to set up a 3 VMs highly available Kube (using k3s with the default setup) cluster on AWS Lightsail using three VMs and a load balancer

For kube CNI, in this project we follow the k3s recommendation to use the default Traefik which exposes one port for our ingress service (nginx)

As stated, on that port there's Nginx with a reverse proxy to be easily able to access the deployed services

### Prerequisite: Setup an AWS cluster where we configure/deploy K3S

K3S uses https://github.com/appliedblockchain/provisioner#k3s / provisioner/infra to setup the AWS Lightsail VMs


#### Provisioning of the infrastructure

    git clone https://github.com/appliedblockchain/provisioner
    git checkout k3s
    cd infra
    rake

#### Run Provisioning

    source env.sh && rake CMD=provision


### K3S Deploy

Run `rake` to prepare and deploy

`rake` will run and check if k3s is already provisioned, and will perform a deployment using the `docker-compose.yml` for pods definition

you can choose to use the raw verison `rake KOMPOSE=y` (or `rake KOMPOSE=1`) which instead of kompose will use `docker stack deploy --orchestrator=kubernetes`


### Run:

    rake

---

### Notes / Tags

    #kubernetes, #k3s, #ruby, #ops, #devops, #compose, #docker, #kompose

### Contributors

- @makevoid
