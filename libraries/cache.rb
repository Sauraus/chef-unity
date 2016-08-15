#
# Cookbook Name:: unity
# Library:: CacheServer
#
# Copyright (C) 2016 Antek S. Baranski
#
# All rights reserved - Do Not Redistribute
#

require 'chef/resource'
require 'chef/provider'

module Unity
  module Resources
    module UnityCacheServer
      class Resource < Chef::Resource::LWRPBase
        self.resource_name = :unity_cacheserver
        provides(:unity_cacheserver)
        actions(:install, :uninstall)
        default_action(:install)

        attribute(:url, kind_of: String, required: true)
        attribute(:checksum, kind_of: String, required: true)
        attribute(:version, kind_of: String, required: true)
        attribute(:bin_folder, kind_of: String)
        attribute(:data_dir, kind_of: String)
        attribute(:size, kind_of: String, required: true)
        attribute(:port, kind_of: Integer)
        attribute(:unity4_legacy, kind_of: [ TrueClass, FalseClass ], default: false)
        attribute(:user, kind_of: String, default: 'unity')
        attribute(:group, kind_of: String, default: 'unity')
      end

      class Provider < Chef::Provider::LWRPBase
        provides(:unity_cacheserver)
        use_inline_resources

        action :install do
          #return if exists?
          data_4_path = ::File.join(new_resource.data_dir, '4') if new_resource.unity4_legacy
          data_5_path = ::File.join(new_resource.data_dir, '5')

          directory new_resource.bin_folder do
            mode '00755'
            user 'root'
            group 'root'
            recursive true
            action :create
          end

          directory data_4_path do
            mode '00755'
            user new_resource.user
            group new_resource.group
            recursive true
            action :create
          end if new_resource.unity4_legacy

          directory data_5_path do
            mode '00755'
            user new_resource.user
            group new_resource.group
            recursive true
            action :create
          end

          runit_service new_resource.name do
            sv_timeout 60
            default_logger true
            options({
              :user => new_resource.user,
              :server_dir => ::File.join(new_resource.bin_folder, 'unity-cacheserver'),
              :data_5_path => data_5_path,
              :data_4_path => data_4_path,
              :port => new_resource.port,
              :size => new_resource.size
            })
            run_template_name 'unity-cacheserver'
          end

          ark 'unity-cacheserver' do
            url new_resource.url
            checksum new_resource.checksum
            version new_resource.version
            prefix_root new_resource.bin_folder
            home_dir ::File.join(new_resource.bin_folder, 'unity-cacheserver')
            notifies :start, "runit_service[#{new_resource.name}]", :delayed
          end

        end
      end
    end
  end
end
