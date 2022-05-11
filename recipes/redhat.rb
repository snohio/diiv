#
# Cookbook:: diiv
# Recipe:: redhat
#
# Copyright:: 2022, Mike Butler, All Rights Reserved.

include_recipe 'selinux::permissive'

package 'java-1.8.0-openjdk' do
  action :install
end

rpm_package 'subsonic' do
  source node['diiv']['install_source'] + node['diiv']['install_file']
  action :install
  not_if { node['packages']['subsonic'] }
end

service 'subsonic' do
  action [:enable, :start]
end

cookbook_file '/etc/sysconfig/subsonic' do
  source 'subsonic'
  mode '644'
  action :create
  notifies :restart, 'service[subsonic]', :delayed
end

# THE BELOW SECTION IS NOT WORKING. THERE IS AN ISSUE WITH THE FIREWALLD_ZONE RESOURCE
# UNTIL THAT SEEMS TO GET FIXED, YOU CAN RUN THE NEXT THREE COMMANDS ON THE MACHING TO CONFIGFURE IT MANUALLY
# firewall-cmd --permanent --zone=public --add-port=8880/tcp
# firewall-cmd --permanent --zone=public --add-service=https
# firewall-cmd --complete-reload

# firewalld 'firewall config'

# firewalld_zone 'public' do
#  short 'public'
#  description 'Configured with Chef. For use in public areas. You do not trust the other computers on networks to not harm your computer. Only selected incoming connections are accepted.'
#  services %w(ssh dhcpv6-client https)
#  version '1'
# end
