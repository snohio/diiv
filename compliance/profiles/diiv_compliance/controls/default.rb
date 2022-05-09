# copyright: 2022, Mike Butler

control 'subsonic-port' do
  impact 0.6
  title 'Subsonic Port is Listening'
  desc 'Operational Check - Is Subsonic Listening'
  describe port(443) do
    it { should be_listening }
  end
  describe port(8880) do
    it { should be_listening }
  end
end

if os.family == 'redhat'
  control 'Subsonic - Selinux' do
    impact 0.7
    title 'SELinux Mode'
    desc 'SELinux Mode should be Enforcing for Subsonic'
    describe selinux do
      it { should be_installed }
      it { should_not be_disabled }
      it { should be_permissive }
    end
  end
end
