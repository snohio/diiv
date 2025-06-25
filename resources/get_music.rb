provides :get_music
unified_mode true

property :zip_urls, Array, required: false, default: []
property :extract_subdir, String, required: false, default: ''
property :music_dir, String, required: false, default: lazy { node['diiv']['music_dir'] }

action :create do
  directory new_resource.music_dir do
    recursive true
    mode '0777' unless platform?('windows')
    action :create
  end

  new_resource.zip_urls.each do |zip_url|
    zip_filename = ::File.basename(zip_url)
    zip_path = ::File.join(Chef::Config[:file_cache_path], zip_filename)
    extract_dir = new_resource.extract_subdir.empty? ? new_resource.music_dir : ::File.join(new_resource.music_dir, new_resource.extract_subdir)

    remote_file zip_path do
      source zip_url
      action :create_if_missing
    end

    directory extract_dir do
      recursive true
      mode '0777' unless platform?('windows')
      action :create
    end

    archive_file "extract_#{zip_filename}" do
      path zip_path
      destination extract_dir
      overwrite true
      not_if { ::Dir.exist?(extract_dir) && !Dir.glob(::File.join(extract_dir, '*')).empty? }
    end
  end
end
