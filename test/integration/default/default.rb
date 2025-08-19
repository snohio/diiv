# InSpec test for Subsonic login page accessibility and title check

if os.windows?
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
else
  describe http('https://localhost/login.view', ssl_verify: false) do
    its('body') { should match(%r{<title>Subsonic</title>}) }
    its('status') { should eq 200 }
  end
end
