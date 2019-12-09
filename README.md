# Laboratorio CEPH + Ubuntu

El repositorio contiene un laboratorio de montaje de un cluster de ceph con 3 nodos y un cliente usando ubuntu.

Toma como base el repositorio: https://github.com/robert0714/Ceph-Designing-and-Implementing-Scalable-Storage-Systems/

### Hardware Requirements
For an optimal student experience, we recommend the following hardware configuration:
* **Processor**: Intel Core i5 or equivalent
* **Memory**: 4 GB RAM
* **Storage**: 40 GB available space

### Software Requirements
You'll also need the following software installed in advance:
* VirtualBox (https://www.virtualbox.org/wiki/Downloads)
* GIT (http://www.git-scm.com/downloads)

## Steps

### Crear Server 1
```bash
vagrant up ceph-node-ubuntu1
vagrant ssh ceph-node-ubuntu1
bash -x /vagrant/join.sh
cd /usr/share/ceph-ansible/
ansible-playbook site.yml -i /home/vagrant/ansible/hosts
sudo ceph status
exit
```

### Agregar Server 2 y 3
```
vagrant up ceph-node-ubuntu2 ceph-node-ubuntu3 --parallel
vagrant ssh ceph-node-ubuntu1
bash -x /vagrant/join.sh
bash -x /vagrant/add2nodes.sh
cd /usr/share/ceph-ansible/
ansible-playbook site.yml -i /home/vagrant/ansible/hosts
sudo ceph -s
exit
```

### Agregar un cliente 

```bash
vagrant up client-node-ubuntu1
vagrant ssh ceph-node-ubuntu1
bash -x /vagrant/join.sh
bash -x /vagrant/addClient.sh 
cd /usr/share/ceph-ansible/
ansible-playbook site.yml -i /home/vagrant/ansible/hosts
sudo ceph -s
```

### Resolver WARN
```bash
sudo ceph osd pool set test pg_num 128
sudo ceph -s
```

## Agregar usuario del cliente 1
```bash
bash -x /vagrant/add-key-client1.sh
```

## Crear bloque de 2GB
```bash
ssh client-node1
sudo bash -x /vagrant/update-kernel.sh
ssh client-node1
sudo uname -r
exit
```
saldra un error pero es causado porque virtualbox no soporta el nuevo kernel instalado


## montar bloque
```
scp /vagrant/add-block-client1.sh client-node1:/home/vagrant
ssh client-node1 "sudo bash -x /home/vagrant/add-block-client1.sh"
ssh client-node1
```

## test
```bash
sudo df -h /mnt/ceph-disk1
```
