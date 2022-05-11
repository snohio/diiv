#
# Cookbook:: diiv
# Recipe:: default
#
# Copyright:: 2022, The Authors, All Rights Reserved.

include_profile 'diiv::diiv_compliance'

case node['platform']
when 'redhat', 'centos', 'rocky', 'almalinux'
  include_recipe 'diiv::redhat'
when 'ubuntu', 'debian'
  include_recipe 'diiv::debian'
when 'windows'
  include_recipe 'diiv::windows'
end
