# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.

  Vagrant.configure("2") do |config|

    # VM1 (SERVIDOR WEB)
    config.vm.define "vm1" do |vm1|
      vm1.vm.box = "gusztavvargadr/ubuntu-server"
      vm1.vm.network "private_network", ip: "192.168.50.10"
      vm1.vm.provider "virtualbox" do |vb|
      end
      vm1.vm.synced_folder "share_vm1", "/var/www/html"
      vm1.vm.provision "shell", path: "provision/p_vm1.sh"
    end
  
    # VM2 (BANCO DE DADOS)
    config.vm.define "vm2" do |vm2|
      vm2.vm.box = "gusztavvargadr/ubuntu-server"
      vm2.vm.network "private_network", ip: "192.168.50.11"
      vm2.vm.provider "virtualbox" do |vb|
      end
      vm2.vm.provision "shell", path: "provision/p_vm2.sh"
    end
  
    # VM3 (GATEWAY)
    config.vm.define "vm3" do |vm3|
      vm3.vm.box = "gusztavvargadr/ubuntu-server"
      vm3.vm.network "private_network", ip: "192.168.50.12"
      vm3.vm.network "public_network", type: "dhcp"
      vm3.vm.provider "virtualbox" do |vb|
      end
      vm3.vm.provision "shell", path: "provision/p_vm3.sh"
    end
end
