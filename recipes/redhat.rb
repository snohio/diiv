#
# Cookbook:: diiv
# Recipe:: redhat
#
# Copyright:: 2025, Mike Butler, All Rights Reserved.

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

# include_recipe 'selinux::permissive'

selinux_state 'permissive' do
  automatic_reboot true
  action :permissive
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

yum_repository 'adoptium' do
  description 'Adoptium'
  baseurl "https://packages.adoptium.net/artifactory/rpm/centos/#{node['platform_version'].to_i}/#{node['kernel']['machine']}"
  gpgkey 'https://packages.adoptium.net/artifactory/api/gpg/key/public'
  gpgcheck true
  enabled true
  action :create
end

package 'temurin-8-jdk' do
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

# This is used for sleeping after the Subsonic service is started to ensure it is fully operational before proceeding.
# This is called by the notifies function.
ruby_block 'sleep after Subsonic restart' do
  block do
    sleep 10 # Pauses for 10 seconds
  end
  action :nothing
end

cookbook_file '/etc/sysconfig/subsonic' do
  source 'subsonic'
  mode '644'
  action :create
  notifies :restart, 'service[subsonic]', :immediately
  notifies :run, 'ruby_block[sleep after Subsonic restart]', :immediately
end

# Ensure the /var/music directory exists
directory '/var/music' do
  owner 'root'
  group 'root'
  mode '0777'
  action :create
end
