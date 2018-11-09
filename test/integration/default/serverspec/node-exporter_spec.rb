require "serverspec"

set :backend, :exec

describe service("node_exporter") do
  it { should be_enabled }
  it { should be_running }
end

describe port("9100") do
  it { should be_listening }
end

describe command("curl -L localhost:9100") do
  its(:stdout) { should match /Node Exporter/ }
end
