#
# Cookbook:: diiv
# Recipe:: windows
#
# Copyright:: 2022, Mike Butler, All Rights Reserved.

# This is the Random Password section. I wanted to save this for future reference
# but the issue here is that a new password is generated every run and the User resource
# gets updated every run. Interestingly, the windows_service resource does not update and 
# then you end up with a mismatch. In the future I would like to guard the user resource
# but needed to wrap this up for now...

# CHARS = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a + ('!'..')').to_a
# def random_password(length = 18)
#   CHARS.sort_by { rand }.join[0...length]
# end
# randpass = random_password
# log "Password is #{randpass}. Forget I every told you that."

randpass = 'THISisNOTr@nd0m!<3'

directory 'C:\temp' do
  action :create
end

user 'subsonic' do
  password "#{randpass}"
end

group 'Administrators' do
  action :modify
  members 'subsonic'
  append true
end

windows_user_privilege 'Log on as a service' do
  privilege   'SeServiceLogonRight'
  users       node['machinename'] + '\subsonic'
  action      :set
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
  run_as_user '.\subsonic'
  run_as_password "#{randpass}"
end

cookbook_file 'c:/Program Files (x86)/Subsonic/subsonic-service.exe.vmoptions' do
  source 'subsonic-service.exe.vmoptions'
  action :create
  notifies :restart, 'windows_service[Subsonic]', :immediately
end
