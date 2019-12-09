sudo rbd create rbd1 --size 10240 --name client.test --pool test
rbd list --name client.test --pool test
rbd ls --name client.test -p test


rbd --image rbd1 info --name client.test -p test
sudo rbd map --image rbd1 --name client.test -p test

rbd showmapped --name client.test
sudo fdisk -l /dev/rbd0

sudo mkfs.xfs /dev/rbd0
sudo mkdir /mnt/ceph-disk1
sudo mount /dev/rbd0 /mnt/ceph-disk1
df -h /mnt/ceph-disk1

