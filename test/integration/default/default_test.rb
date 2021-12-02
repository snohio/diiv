# InSpec test for recipe diiv::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

describe user('vagrant') do
  it { should exist }
end

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
