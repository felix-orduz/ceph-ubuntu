sudo ceph auth get-or-create client.test mon 'allow r' osd 'allow class-read object_prefix  rbd_children, allow rwx pool=test'
sudo ceph auth get-or-create client.test | ssh client-node1 sudo tee /etc/ceph/ceph.client.test.keyring

ssh client-node1 sudo ls /etc/ceph/
ssh client-node1 sudo touch /etc/ceph/keyring
ssh client-node1 sudo chmod 777 /etc/ceph/keyring
ssh client-node1 sudo chown vagrant:vagrant /etc/ceph/keyring
ssh client-node1 "sudo cat /etc/ceph/ceph.client.test.keyring >> /etc/ceph/keyring"
ssh client-node1 sudo cat /etc/ceph/ceph.client.test.keyring

ssh client-node1 "ceph -s --name client.test"