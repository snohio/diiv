#
# Cookbook:: diiv
# Spec:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

require 'spec_helper'

describe 'diiv::default' do
  context 'When all attributes are default, on Redhat 7' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'redhat', version: '7')
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
  context 'When all attributes are default, on Windows 2016' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new(platform: 'windows', version: '2016')
      runner.converge(described_recipe)
    end

    before do
      stub_command('(Get-WindowsFeature Subsonic-service).Installed -eq "True"').and_return(true)

      # for uninitialized constant Win32 error
      stub_const('Win32::Service', Module.new) unless defined?(Win32::Service)
      allow(Win32::Service).to receive(:exists?).and_return(false)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
