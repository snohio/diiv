#
# Cookbook:: diiv
# Recipe:: windows
#
# Copyright:: 2025, Mike Butler, All Rights Reserved.

# Create a user for Subsonic if it does not already exist
require 'securerandom'

CHARS = ('0'..'9').to_a + ('A'..'Z').to_a + ('a'..'z').to_a + ('!'..'~').to_a
def random_password(length = 18)
  CHARS.sort_by { SecureRandom.random_number }.join[0...length]
end
randpass = random_password

log "Password is #{randpass}. Forget I ever told you that." do
  not_if { shell_out('net user subsonic').exitstatus == 0 }
end

windows_user 'subsonic' do
  password randpass
  action :create
  not_if { shell_out('net user subsonic').exitstatus == 0 }
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

windows_firewall_rule 'Allow HTTP 8880' do
  localport '8880'
  protocol 'TCP'
  firewall_action :allow
  direction :inbound
  description 'Allow inbound HTTP traffic on port 8880'
end

windows_firewall_rule 'Allow HTTPS 443' do
  localport '443'
  protocol 'TCP'
  firewall_action :allow
  direction :inbound
  description 'Allow inbound HTTPS traffic on port 443'
end

windows_firewall_rule 'Enable World Wide Web Services (HTTPS Traffic-In)' do
  displayname 'World Wide Web Services (HTTPS Traffic-In)'
  enabled true
  action :create
end

# Download the music first so when Subsonic is installed, it can find and index it.
node['diiv']['music_url'].each do |music_url|
  subdir = ::File.basename(music_url, '.zip')
  get_music "download_#{subdir}" do
    zip_urls [music_url]
    extract_subdir subdir
    # music_dir defaults to node['diiv']['music_dir']
    action :create
  end
end

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

ruby_block 'wait for subsonic install' do
  block do
    require 'timeout'
    Timeout.timeout(240) do # wait up to 4 minutes
      sleep 2 until ::File.exist?('C:/subsonic/lastfmcache2')
    end
  end
  action :run
  not_if { node['packages']['Subsonic'] }
end

# Configure service with credentials only when user is first created
windows_service 'Subsonic Initial Setup' do
  service_name 'Subsonic'
  action [:configure, :start]
  run_as_user '.\subsonic'
  run_as_password "#{randpass}"
  not_if { shell_out('net user subsonic').exitstatus == 0 }
end

# On subsequent runs, just ensure service is started (don't reconfigure credentials)
windows_service 'Subsonic' do
  action :start
  only_if { shell_out('net user subsonic').exitstatus == 0 }
end

# This is used for sleeping after the Subsonic service is started to ensure it is fully operational before proceeding.
# This is called by the notifies function.
ruby_block 'sleep after Subsonic restart' do
  block do
    sleep 10  # Pauses for 10 seconds
  end
  action :nothing
end

cookbook_file 'c:/Program Files (x86)/Subsonic/subsonic-service.exe.vmoptions' do
  source 'subsonic-service.exe.vmoptions'
  action :create
  notifies :restart, 'windows_service[Subsonic]', :immediately
  notifies :run, 'ruby_block[sleep after Subsonic restart]', :immediately
end
