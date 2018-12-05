Vagrant.configure("2") do |config|
  config.vm.define :vm1 do |vm1|
    vm1.vm.box = "ubuntu/bionic64"
    vm1.vm.hostname = "server"
    vm1.vm.network :private_network, ip: "10.1.1.200"
    vm1.ssh.username = "vagrant"
    vm1.ssh.password = "vagrant"
    vm1.vm.network "forwarded_port", guest: 80, host: 8182
    vm1.vm.provision "shell", inline: <<-SHELL
      echo "10.1.1.200 server" >> /etc/hosts
      echo "10.1.1.201 chefnode" >> /etc/hosts
      cd /home/vagrant
      wget -q -O chefdk.deb https://packages.chef.io/files/stable/chefdk/3.3.23/ubuntu/18.04/chefdk_3.3.23-1_amd64.deb
      sudo dpkg -i chefdk.deb
      wget -q -O chefserver.deb https://packages.chef.io/files/current/chef-server/12.17.54+20180531095715/ubuntu/18.04/chef-server-core_12.17.54+20180531095715-1_amd64.deb
      sudo dpkg -i chefserver.deb
      chef-server-ctl reconfigure
      sudo chef-server-ctl user-create admin "admin" "new" 'lsureshk@andrew.cmu.edu' 'adminpass' --filename /vagrant/admin.pem
      sudo chef-server-ctl org-create cheforg "Org" --association_user admin --filename /vagrant/cheforg.pem
      sudo chef-server-ctl install chef-manage
      sudo chef-server-ctl reconfigure
      sudo chef-manage-ctl reconfigure --accept-license
      mkdir /home/vagrant/.chef/
      /bin/cp /vagrant/knife.rb /home/vagrant/.chef/
      knife ssl fetch
      knife cookbook upload petclinic
    SHELL
  end
  config.vm.define :vm2 do |vm2|
    vm2.vm.box = "ubuntu/bionic64"
    vm2.vm.hostname = "chefnode"
    vm2.vm.network :private_network, ip: "10.1.1.201"
    vm2.ssh.username = "vagrant"
    vm2.ssh.password = "vagrant"
    vm2.vm.network "forwarded_port", guest: 8080, host: 8080
    vm2.vm.provision "shell", inline: <<-SHELL
      	echo "10.1.1.200 server" >> /etc/hosts
      	echo "10.1.1.201 chefnode" >> /etc/hosts
      	cd /home/vagrant
      	sudo apt-get install -y default-jdk
      	wget -q -O chefdk.deb https://packages.chef.io/files/stable/chefdk/3.3.23/ubuntu/18.04/chefdk_3.3.23-1_amd64.deb
      	sudo dpkg -i chefdk.deb
      	wget -q -O chefclient.deb https://packages.chef.io/files/stable/chef/14.5.33/ubuntu/18.04/chef_14.5.33-1_amd64.deb
      	sudo dpkg -i chefclient.deb
     	mkdir /home/vagrant/.chef/
      	/bin/cp /vagrant/knife.rb /home/vagrant/.chef/
      	knife ssl fetch
      	knife role from file /vagrant/petclinic/roles/chefnode.json
      	knife bootstrap chefnode -x vagrant -P vagrant --sudo --node-name chefnode
      	knife node run_list add chefnode 'role[chefnode]'
      	sudo chef-client
    SHELL
  end

end
