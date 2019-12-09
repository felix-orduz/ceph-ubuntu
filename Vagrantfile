# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX='bento/ubuntu-18.04'
VAGRANTFILE_API_VERSION = "2"

client_host= 'client-node1'


# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
    config.vm.synced_folder ".", "/vagrant", mount_options: ["dmode=700,fmode=600"]
  else
    config.vm.synced_folder ".", "/vagrant"
  end

  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
    config.vbguest.no_install = true
    config.vbguest.no_remote = true
  end
    

  (1..4).each do |i| 
    config.vm.define :"ceph-node-ubuntu#{i}" do |node|
      
      node.vm.box = BOX
      node.vm.network "private_network", ip: "192.16.1.10#{i}"

      node.vm.hostname = "ceph-node#{i}"      
      node.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
      node.vm.provision "shell", path: "post-deploy.sh"
      
      disk2 = "./ceph-node-ubuntu#{i}/ceph-node-ubuntu#{i}_disk2.vdi"
      disk3 = "./ceph-node-ubuntu#{i}/ceph-node-ubuntu#{i}_disk3.vdi"
      disk4 = "./ceph-node-ubuntu#{i}/ceph-node-ubuntu#{i}_disk4.vdi"
      
      node.vm.provider "virtualbox" do |v|
        v.customize ["modifyvm", :id, "--memory", "1024"]
        v.name = "ceph-node-ubuntu#{i}"
  
        #v.gui = true

        
        unless File.exist?(disk2)
          v.customize ['createhd', '--filename', disk2,'--size', 1 * 20480]
          v.customize ['storageattach', :id,  '--storagectl', 'SATA Controller', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', disk2]
        end

        unless File.exist?(disk3)
          v.customize ['createhd', '--filename', disk3,'--size', 1 * 20480]
          v.customize ['storageattach', :id,  '--storagectl', 'SATA Controller', '--port',2, '--device', 0, '--type', 'hdd', '--medium', disk3]
        end

        unless File.exist?(disk4)
          v.customize ['createhd', '--filename', disk4,'--size', 1 * 20480]
          v.customize ['storageattach', :id,  '--storagectl', 'SATA Controller', '--port', 3, '--device', 0, '--type', 'hdd', '--medium', disk4]
        end
      end
    end
  end


  config.vm.define :"client-node-ubuntu1" do |os|
    os.vm.box = BOX
    #os.vm.box = BOX
    #os.vm.box_url = BOX_URL
    os.vm.network :private_network, ip: "192.16.1.110"
    os.vm.hostname = client_host
    #os.vm.synced_folder ".", "/vagrant", disabled: true
    os.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
    os.vm.provision "shell", path: "post-deploy.sh"
    os.vm.provider "virtualbox" do |v|
      v.customize ["modifyvm", :id, "--memory", "1024"]
      v.name = 'client-node-ubuntu1'
      v.gui = false
    end
  end

  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://vagrantcloud.com/search.
  #config.vm.box = "base"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # NOTE: This will enable public access to the opened port
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine and only allow access
  # via 127.0.0.1 to disable public access
  # config.vm.network "forwarded_port", guest: 80, host: 8080, host_ip: "127.0.0.1"

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network "private_network", ip: "192.168.33.10"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  # config.vm.provider "virtualbox" do |vb|
  #   # Display the VirtualBox GUI when booting the machine
  #   vb.gui = true
  #
  #   # Customize the amount of memory on the VM:
  #   vb.memory = "1024"
  # end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  # config.vm.provision "shell", inline: <<-SHELL
  #   apt-get update
  #   apt-get install -y apache2
  # SHELL
end
