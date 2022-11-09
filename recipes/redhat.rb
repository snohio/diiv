#
# Cookbook:: diiv
# Recipe:: redhat
#
# Copyright:: 2022, Mike Butler, All Rights Reserved.

# include_recipe 'selinux::permissive'

selinux_state 'permissive' do
  automatic_reboot true
  action :permissive
end

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

firewall 'default'

# open standard ssh port
firewall_rule 'ssh' do
  port     22
  command  :allow
end

# open standard http port to tcp traffic only; insert as first rule
firewall_rule 'http/https' do
  protocol :tcp
  port     [8880, 443]
  command :allow
end
