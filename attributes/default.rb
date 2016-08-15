#
# Cookbook Name:: unity
# Attribute:: default
#
# Copyright (C) 2016 Antek S. Baranski
#
# All rights reserved - Do Not Redistribute
#

default['unity']['editor']['mac_os_x']['databag'] = 'unity_macosx_versions'
default['unity']['editor']['mac_os_x']['install_root'] = '/Applications'
default['unity']['editor']['windows']['databag'] = 'unity_windows_versions'
default['unity']['editor']['windows']['install_root'] = 'C:/unity'
default['unity']['editor']['cache']['enable'] = 1
default['unity']['editor']['cache']['server'] = 'localhost'

default['unity']['cache']['name'] = 'CacheServer'
default['unity']['cache']['version'] = '5.3.5f1'
default['unity']['cache']['bin_folder'] = '/usr/local/bin'
default['unity']['cache']['data_dir'] = '/var/lib/unity/cache'
default['unity']['cache']['url'] = #ADD the unity cache server binary ZIP file download link here
default['unity']['cache']['checksum'] = '04eb29f601739ba6ecbed46073c134296fd6e1b38bbe6c30b03773f70199e581'
default['unity']['cache']['user'] = 'unity'
default['unity']['cache']['group'] = 'unity'
default['unity']['cache']['size'] = '150000000000'
default['unity']['cache']['legacy'] = false

default['haproxy']['mode'] = 'tcp'
default['haproxy']['enable_default_http'] = false
default['haproxy']['defaults_options'] = ["tcplog", "dontlognull", "redispatch"]
default['haproxy']['incoming_address'] = '0.0.0.0'
default['haproxy']['incoming_port'] = 8126
default['haproxy']['members'] = [{
    'hostname' => 'unity-cacheserver-1',
    'ipaddress' => '127.0.0.1',
    'port' => 8127
  }, {
    'hostname' => 'unity-cacheserver-2',
    'ipaddress' => '127.0.0.1',
    'port' => 8128
  }, {
    'hostname' => 'unity-cacheserver-3',
    'ipaddress' => '127.0.0.1',
    'port' => 8129
  }]
