#
# Cookbook:: diiv
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

case node['platform']
when 'redhat', 'centos'
  include_recipe 'diiv::redhat'
when 'windows'
  include_recipe 'diiv::windows'
end
