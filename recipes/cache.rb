#
# Cookbook Name:: unity
# Recipe:: cache
#
# Copyright (C) 2016 Antek S. Baranski
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'unity::default'

unity_cacheserver 'unity-cacheserver' do
  url node['unity']['cache']['url']
  checksum node['unity']['cache']['checksum']
  version node['unity']['cache']['version']
  bin_folder node['unity']['cache']['bin_folder']
  data_dir node['unity']['cache']['data_dir']
  unity4_legacy node['unity']['cache']['legacy']
  size node['unity']['cache']['size']
end
