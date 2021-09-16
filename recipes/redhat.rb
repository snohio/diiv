#
# Cookbook:: diiv
# Recipe:: redhat
#
# Copyright:: 2020, Mike Butler, All Rights Reserved.

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
