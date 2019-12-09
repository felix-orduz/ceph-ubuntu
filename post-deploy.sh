#!/bin/bash
value=$( grep -ic "entry" /etc/hosts )
if [ $value -eq 0 ]
then
echo "
################ ceph-cookbook host entry ############

192.16.1.101 ceph-node1
192.16.1.102 ceph-node2
192.16.1.103 ceph-node3
192.16.1.104 ceph-node4
192.16.1.115 ceph-node5
192.16.1.116 ceph-node6
192.16.1.117 ceph-node7
192.16.1.118 ceph-node8

192.16.1.106 rgw-node1.cephcookbook.com rgw-node1
192.16.1.107 us-east-1.cephcookbook.com us-east-1 
192.16.1.108 us-west-1.cephcookbook.com us-west-1
192.16.1.110 client-node1
192.16.1.111 os-node1.cephcookbook.com os-node1
192.16.1.120 owncloud.cephcookbook.com owncloud

######################################################
" >> /etc/hosts
fi
if [ -e /etc/redhat-release ]
then
systemctl stop ntpd
systemctl stop ntpdate
ntpdate 0.centos.pool.ntp.org > /dev/null 2> /dev/null
systemctl start ntpdate
systemctl start ntpd

	if [ -e /etc/rc.d/init.d/ceph ]
	then
	service ceph restart mon > /dev/null 2> /dev/null
	fi

fi


### Python Configuration ####
echo "      nameservers:" >> /etc/netplan/01-netcfg.yaml
echo "          addresses: [1.1.1.1]" >> /etc/netplan/01-netcfg.yaml
sudo netplan apply
sudo apt-get update

sudo update-alternatives --config python
sudo update-alternatives --install /usr/bin/python python /usr/bin/python3 1
sudo update-alternatives --set python /usr/bin/python3
sudo apt -y install python3-pip sshpass


### Ansible installation

sudo pip3 install ansible
sudo pip3 install ansible --upgrade
ansible --version


### upgrade system
sudo apt-get upgrade

sudo ufw allow from any to any port 6789 proto tcp
sudo ufw allow from any to any port 6800,7100 proto tcp

### Generar Llave
ssh-keygen  -f /home/vagrant/.ssh/id_rsa -q -N ""
sudo chown -R vagrant:vagrant /home/vagrant/.ssh/ 

### ceph installation
if [ "$HOSTNAME" = ceph-node1 ]; then
	cd /usr/share
	git clone https://github.com/ceph/ceph-ansible.git
	sudo chown -R vagrant:vagrant ceph-ansible
	cd ceph-ansible
	git checkout stable-4.0
	sudo pip3 install -r requirements.txt

	

	mkdir -p /home/vagrant/ansible/
	chown vagrant:vagrant /home/vagrant/ansible/
	#mkdir -p /root/vagrant/ansible/

	touch /home/vagrant/ansible/hosts
	chown vagrant:vagrant /home/vagrant/ansible/hosts

	touch  /home/vagrant/ansible/ansible.log
	#touch  /root/ansible/ansible.log

	chmod 777 /home/vagrant/ansible/ansible.log
	#chmod 777 /root/ansible/ansible.log

	echo "[mons]" >> /home/vagrant/ansible/hosts
	echo "ceph-node1" >> /home/vagrant/ansible/hosts
	echo "" >> /home/vagrant/ansible/hosts
	echo "[osds]" >> /home/vagrant/ansible/hosts
	echo "ceph-node1" >> /home/vagrant/ansible/hosts


	cd ~ && mkdir  ceph-ansible-keys


	ln -s /usr/share/ceph-ansible/group_vars/  /home/vagrant/ansible/group_vars

	cd /home/vagrant/ansible/group_vars
	cp all.yml.sample all.yml

ed -s all.yml <<EOT
2i
fetch_directory: ~/ceph-ansible-keys
ceph_origin: repository
ceph_repository: community
ceph_repository_type: cdn
ceph_stable_release: nautilus
monitor_interface: eth1
public_network: 192.16.1.0/24
cluster_network: "{{ public_network }}"
dashboard_enabled: False
#ceph_mirror: http://download.ceph.com
#ceph_stable_repo: "{{ ceph_mirror }}/debian-{{ ceph_stable_release }}"
#ceph_stable_distro_source: stretch
.
w
q
EOT
	
	cd /home/vagrant/ansible/group_vars
	cp osds.yml.sample osds.yml

ed -s osds.yml <<EOT
2i
devices:
    - /dev/sdb
    - /dev/sdc
    - /dev/sdd
journal_collection: true
.
w
q
EOT

	cd /usr/share/ceph-ansible
	sed -i '6iretry_files_save_path = ~/' ansible.cfg 

	cat ansible.cfg |grep retry_files_save

	cd /usr/share/ceph-ansible/
	cp site.yml.sample site.yml

fi




