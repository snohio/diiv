# InSpec test for recipe diiv::default

# The InSpec reference, with examples and extensive documentation, can be
# found at https://www.inspec.io/docs/reference/resources/

describe port(443) do
  it { should be_listening }
end
describe port(8880) do
  it { should be_listening }
end
