#
# Cookbook:: petclinic
# Recipe:: petclinic
#
# Copyright:: 2018, The Authors, All Rights Reserved.
execute "Execute petclinic jar " do
  command "java -jar /vagrant/petclinic.jar &"
  action :run
end