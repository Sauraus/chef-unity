require_relative '../../../kitchen/data/spec_helper'

describe user('unity') do
  it { should exist }
end

describe user('unity') do
  it { should have_login_shell '/sbin/nologin' }
end

describe file('/var/lib/unity/cache') do
  it { should be_directory }
end

# TODO: ServerSpec can't test for runit service startup
#describe service('unity-cacheserver') do
#  it { should be_enabled }
#end

describe service('unity-cacheserver') do
  it { should be_running }
end
