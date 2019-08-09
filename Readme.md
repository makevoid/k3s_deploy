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

you can choose to use the raw verison `rake KOMPOSE=y` (or `rake KOMPOSE=1`) which instead of `stack deploy` will use kompose (which actually also builds and automatically pushes the containers)

The default command used internally is: `docker stack deploy --orchestrator=kubernetes`

As simple as that!

### Run:

    rake


Your deploy will start!


### Notes

It is recommended to close port 80 on the workers as k3s can (dynamically) assign it as a port

Use dockerhub (using a private docker registry needs extra setup infos)

### TODO

- implement close port
- close port 80
- write troubleshooting guide

### Troubleshooting

- TODO: write difference between kompose and stack deploy
- TODO: write readme about what to check when things go wrong


---

### Notes / Tags

    #kubernetes, #k3s, #ruby, #ops, #devops, #compose, #docker, #kompose

### Contributors

- @makevoid
