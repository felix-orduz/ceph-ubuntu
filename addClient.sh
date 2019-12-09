echo '' >> /home/vagrant/ansible/hosts
echo '[clients]' >> /home/vagrant/ansible/hosts
echo 'client-node1' >> /home/vagrant/ansible/hosts

cd /usr/share/ceph-ansible/group_vars/
cp clients.yml.sample clients.yml


sed -i "/^#.*user_config: false/s/^#//" /usr/share/ceph-ansible/group_vars/clients.yml

sed -i "/user_config: false/s/false/true/" /usr/share/ceph-ansible/group_vars/clients.yml
