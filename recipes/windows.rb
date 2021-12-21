#
# Cookbook:: diiv
# Recipe:: windows
#
# Copyright:: 2022, Mike Butler, All Rights Reserved.

directory 'C:\temp' do
  action :create
end

windows_package 'Subsonic' do
  source node['diiv']['install_source'] + node['diiv']['install_file']
  checksum node['diiv']['checksum']
  remote_file_attributes path: 'C:\temp\subsonic-6.1.6-setup.exe'
  action :install
  not_if { node['packages']['Subsonic'] }
end

windows_service 'Subsonic' do
  action [:configure, :start]
end
