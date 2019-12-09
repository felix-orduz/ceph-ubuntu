
sudo echo "nameserver 1.1.1.1" >> /etc/resolv.conf

# sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 10

sudo add-apt-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get upgrade

sudo nano /etc/resolv.conf
sudo apt install -y git python-pip parted ansible python3-pip software-properties-common ntp ntpdate
#pip3 install ansible

ssh-keygen
ssh-copy-id vagrant@ceph-node1 
ssh ceph-node1 hostname

cd /usr/share
sudo git clone https://github.com/ceph/ceph-ansible.git
sudo chown -R vagrant:vagrant ceph-ansible

cd ceph-ansible
git checkout stable-4.0

pip3 install -r requirements.txt
pip install -r requirements.txt

sudo nano /etc/ansible/hosts

[mons]
ceph-node1

[mgrs]
ceph-node1

[osds]
ceph-node1

[mons:vars]
ansible_python_interpreter=/usr/bin/python3

[mgrs:vars]
ansible_python_interpreter=/usr/bin/python3

[osds:vars]
ansible_python_interpreter=/usr/bin/python3

ansible all -m ping

sudo ufw allow from any to any port 6789 proto tcp
sudo ufw allow from any to any port 6800,7100 proto tcp

cd ~ && mkdir  ceph-ansible-keys
sudo ln -s /usr/share/ceph-ansible/group_vars/  /etc/ansible/group_vars
