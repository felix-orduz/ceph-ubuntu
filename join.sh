sshpass -p 'vagrant' ssh-copy-id -o StrictHostKeyChecking=no vagrant@ceph-node1
sshpass -p 'vagrant' ssh-copy-id -o StrictHostKeyChecking=no vagrant@ceph-node2
sshpass -p 'vagrant' ssh-copy-id -o StrictHostKeyChecking=no vagrant@ceph-node3

ssh ceph-node1 hostname
ssh ceph-node2 hostname
ssh ceph-node3 hostname

if [ "$HOSTNAME" = ceph-node1 ]; then
    sshpass -p 'vagrant' ssh-copy-id -o StrictHostKeyChecking=no vagrant@client-node1
    ssh client-node1 hostname

    ssh ceph-node2 bash -x /vagrant/join.sh
    ssh ceph-node3 bash -x /vagrant/join.sh


    ssh client-node1 bash -x /vagrant/join.sh
fi

if [ "$HOSTNAME" = client-node1 ]; then
    sshpass -p 'vagrant' ssh-copy-id -o StrictHostKeyChecking=no vagrant@ceph-node1
    ssh ceph-node1 hostname
fi
