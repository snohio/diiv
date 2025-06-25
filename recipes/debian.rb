#
# Cookbook:: diiv
# Recipe:: debian
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

apt_update 'update_packages' do
  action :nothing
end

apt_repository 'adoptium' do
  uri          'https://packages.adoptium.net/artifactory/deb'
  components   ['main']
  key          'https://packages.adoptium.net/artifactory/api/gpg/key/public'
  action       :add
  notifies :update, 'apt_update[update_packages]', :immediately
end

# Install Eclipse Temurin 8
package 'temurin-8-jdk' do
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
end

service 'subsonic' do
  action [:enable, :start]
end

ruby_block 'sleep after Subsonic restart' do
  block do
    sleep 10  # Pauses for 10 seconds
  end
  action :nothing
end

cookbook_file '/etc/default/subsonic' do
  source 'subsonic'
  mode '644'
  action :create
  notifies :restart, 'service[subsonic]', :immediately
  notifies :run, 'ruby_block[sleep after Subsonic restart]', :immediately
end
