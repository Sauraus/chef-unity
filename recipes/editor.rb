#
# Cookbook Name:: unity
# Recipe:: editor
#
# Copyright (C) 2016 Antek S. Baranski
#
# All rights reserved - Do Not Redistribute
#

platform = node['platform_family']

include_recipe 'ark'

(%w(windows mac_os_x).include?(platform)) ?
    unity_versions = data_bag(node['unity']['editor'][platform]['databag']) :
    (raise "Unsupported platform [#{platform}] for Unity Editor install")

unity_versions.each do |version|
  unity = data_bag_item(node['unity']['editor'][platform]['databag'], version)
  unity_editor unity['id'] do
    url unity['url']
    checksum unity['checksum']
    app unity['app'] if platform.eql?('mac_os_x')
    install_root node['unity']['editor'][platform]['install_root']
    force unity['force'] unless unity['force'].nil?
    action unity['action']
  end
end

windows_service 'Audiosrv' do
  startup_type :automatic
  action [:configure_startup, :start]
  only_if { node['platform_version'].eql?('6.3.9600') } # This is 2012R2 SRV
end if platform_family?('windows')
