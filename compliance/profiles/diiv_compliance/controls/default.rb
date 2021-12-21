# copyright: 2018, The Authors

control 'subsonic-port' do
  impact 0.6
  title 'Subsonic Port is Listening'
  desc 'Operational Check - Is Subsonic Listening'
  if os.family == 'redhat'
    describe port(4443) do
      it { should be_listening }
    end
    describe port(4040) do
      it { should be_listening }
    end
  elsif os.family == 'windows'
    describe port(4040) do
      it { should be_listening }
    end
  end
end

control 'Subsonic - Selinux' do
  impact 0.7
  title 'SELinux Mode'
  desc 'SELinux Mode should be Enforcing for Subsonic'
  describe selinux do
    it { should be_installed }
    it { should_not be_disabled }
    it { should be_enforcing }
    it { should_not be_permissive }
  end
end