#
# Cookbook:: diiv
# Recipe:: debian
#
# Copyright:: 2022, Mike Butler, All Rights Reserved.

apt_repository 'java' do
  uri 'ppa:webupd8team/java'
  components ['main']
  action :add
end

apt_package 'openjdk-8-jdk' do
  action :install
end

remote_file '/tmp/' + node['diiv']['install_file'] do
  source node['diiv']['install_source'] + node['diiv']['install_file']
  owner 'root'
  group 'root'
  mode '0777'
  action :create
  not_if { node['packages']['subsonic'] }
end

dpkg_package 'subsonic' do
  source '/tmp/' + node['diiv']['install_file']
  action :install
  not_if { node['packages']['subsonic'] }
end

service 'subsonic' do
  action [:enable, :start]
end

cookbook_file '/etc/default/subsonic' do
  source 'subsonic'
  mode '644'
  action :create
  notifies :restart, 'service[subsonic]', :delayed
end
