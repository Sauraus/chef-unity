#
# Cookbook Name:: unity
# Recipe:: cache-cluster
#
# Copyright (C) 2016 Antek S. Baranski
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'unity::default'

unity_cacheserver 'unity-cacheserver-1' do
  url node['unity']['cache']['url']
  checksum node['unity']['cache']['checksum']
  version node['unity']['cache']['version']
  bin_folder node['unity']['cache']['bin_folder']
  data_dir node['unity']['cache']['data_dir']
  unity4_legacy false
  size node['unity']['cache']['size']
  port 8127
end

unity_cacheserver 'unity-cacheserver-2' do
  url node['unity']['cache']['url']
  checksum node['unity']['cache']['checksum']
  version node['unity']['cache']['version']
  bin_folder node['unity']['cache']['bin_folder']
  data_dir node['unity']['cache']['data_dir']
  unity4_legacy false
  size node['unity']['cache']['size']
  port 8128
end

unity_cacheserver 'unity-cacheserver-3' do
  url node['unity']['cache']['url']
  checksum node['unity']['cache']['checksum']
  version node['unity']['cache']['version']
  bin_folder node['unity']['cache']['bin_folder']
  data_dir node['unity']['cache']['data_dir']
  unity4_legacy false
  size node['unity']['cache']['size']
  port 8129
end

conf = node['haproxy']
member_max_conn = conf['member_max_connections']
member_weight = conf['member_weight']
haproxy_lb 'unity-proxy' do
  type 'frontend'
  params({
             'maxconn' => conf['frontend_max_connections'],
             'bind' => "#{conf['incoming_address']}:#{conf['incoming_port']}",
             'default_backend' => 'unity-cacheservers'
         })
end

pool = []
pool << 'stick store-request url'
pool << 'stick-table type string len 256 size 8k expire 1m'
pool << 'stick match url table unity-cacheservers'
servers = node['haproxy']['members'].map do |member|
  "#{member['hostname']} #{member['ipaddress']}:#{member['port']} weight #{member['weight'] || member_weight} maxconn #{member['max_connections'] || member_max_conn} check #{node['haproxy']['pool_members_option']}"
end

haproxy_lb 'unity-cacheservers' do
  type 'backend'
  params pool
  servers servers
end

include_recipe 'haproxy::default'
