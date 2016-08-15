#
# Cookbook Name:: unity
# Recipe:: default
#
# Copyright (C) 2016 Antek S. Baranski
#
# All rights reserved - Do Not Redistribute
#

include_recipe 'ark'
include_recipe 'runit'

group node['unity']['cache']['group'] do
  action :create
end

user node['unity']['cache']['user'] do
  comment 'Unity Cache Server user created by Chef'
  gid node['unity']['cache']['group']
  system true
  shell '/sbin/nologin'
  action :create
end
