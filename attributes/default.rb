#
# Cookbook:: diiv

default['diiv']['install_source'] = 'https://s3-eu-west-1.amazonaws.com/subsonic-public/download/'

default['audit']['compliance_phase'] = true
default['audit']['fetcher'] = 'chef-automate'
default['audit']['reporter'] = 'chef-server-automate', 'cli'

case node['platform_family']

when 'rhel'
  default['diiv']['install_file'] = 'subsonic-6.1.6.rpm'
  default['diiv']['checksum'] = 'e7962a867a217e00515634dd15c0403d4b5cad052da54aa028ca0eb2081d6d5c'

when 'debian'
  default['diiv']['install_file'] = 'subsonic-6.1.6.deb'
  default['diiv']['checksum'] = '4fca9650bb62dce158281fb10a0de00976b3cea545cde4ee0194cebe1c1da5c4'

when 'windows'
  default['diiv']['install_file'] = 'subsonic-6.1.6-setup.exe'
  default['diiv']['checksum'] = '4a997d516ca053455f66b9de036c9eaddde013dbfdebeb36485408b58016ec09'
end
