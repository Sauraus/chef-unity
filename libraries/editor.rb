#
# Cookbook Name:: unity
# Library:: editor
#
# Copyright (C) 2016 Antek S. Baranski
#
# All rights reserved - Do Not Redistribute
#

require 'chef/resource'
require 'chef/provider'

module Unity
  module Resources
    module UnityEditor
      # A 'unity_editor' resource to install and uninstall Unity Editor.

      class Resource < Chef::Resource::LWRPBase
        self.resource_name = :unity_editor
        provides(:unity_editor)
        actions(:install, :uninstall)
        default_action(:install)

        attribute(:version, kind_of: String, name_attribute: true)
        attribute(:url, kind_of: String, required: true)
        attribute(:checksum, kind_of: String, required: true)
        attribute(:app, kind_of: String, required: true) if Chef.node.platform_family?('mac_os_x')
        attribute(:install_root, kind_of: String, required: true, default: (Chef.node.platform_family?('mac_os_x')) ? '/Applications' : 'c:\unity')
        attribute(:force, kind_of: [TrueClass, FalseClass], default: false)
      end

      class Provider < Chef::Provider::LWRPBase
        provides(:unity_editor)
        use_inline_resources

        action :install do
          return if exists?
          case Chef.node.platform_family
            when 'mac_os_x'
              install_mac_os_x
            when 'windows'
              install_windows
            else
              raise "Unity Editor LWRP only support OSX & Windows"
          end
        end

        action :uninstall do
          if exists?
            directory install_dir do
              recursive true
              action :delete
            end
          end
        end

        def install_mac_os_x
          # Remove folder if it exists and we force the install.
          directory install_dir do
            recursive true
            action :delete
          end if new_resource.force && exists?

          # Conditional to test whether Unity version is 5.x.x or greater
          # If not, use "dmg" cookbook to handle the .dmg file
          # Else use "remote_file" to download PKG file and "execute" to install
          if new_resource.url.end_with?('dmg')
            dmg_package "Unity3D" do
              app new_resource.app
              source new_resource.url
              checksum new_resource.checksum
              volumes_dir 'Unity Installer'
              type 'pkg'
              action :install
            end
          elsif new_resource.url.end_with?('pkg')
            pkg_file = ::File.join(Chef::Config[:file_cache_path], "#{new_resource.app}.pkg")
            remote_file pkg_file do
              source new_resource.url
              checksum new_resource.checksum
            end

            execute "installer -pkg '#{pkg_file}' -target /" do
              user 'root'
            end
          elsif new_resource.url.end_with?('tar.gz')
            ark "Unity" do
              url new_resource.url
              checksum new_resource.checksum
              path new_resource.install_root
              action :put
            end
          end

          # Default installs /Applications/Unity, so move it in case we want multiple installs
          execute "mv -f /Applications/Unity #{install_dir}" do
            only_if { Dir.exist?('/Applications/Unity') }
          end

          # clean up installer file but check if the install dir moved 1st
          if exists?
            base_filename = ::File.basename(new_resource.url)
            temp_pkg_file = ::File.join(Chef::Config[:file_cache_path], base_filename)
            delete_installer_file(temp_pkg_file)
          end

        end

        def install_windows
          # Remove folder if it exists and we force the install.
          directory install_dir do
            recursive true
            action :delete
          end if new_resource.force && exists?

          registry_key 'HKCU\Software\Unity Technologies' do
            recursive true
            action :delete_key
          end

          directory ::File.join('c:', 'Program Files (x86)', 'Unity') do
            recursive true
            action :delete
          end

          directory ::File.join('c:', 'Program Files', 'Unity') do
            recursive true
            action :delete
          end

          # Unity installer will ignore the /D option if Unity was already installed on the system before
          if new_resource.url.end_with?('exe')
            windows_package 'Unity' do
              source new_resource.url
              checksum new_resource.checksum
              version new_resource.version
              options '/S /AllUsers'
              installer_type :custom
              action :install
            end
          elsif new_resource.url.end_with?('zip')
            pkg_file = ::File.join(Chef::Config[:file_cache_path], "Unity_#{new_resource.version}.zip")

            remote_file pkg_file do
              source new_resource.url
              checksum new_resource.checksum
            end

            execute "Unzipping #{pkg_file}" do
              command "7z.exe x \"#{pkg_file}\" -o\"c:\\Program Files\""
            end
          end

          directory install_dir do
            recursive true
            action :create
          end

          # NOTE: Unity side2side installs are complicated
          if new_resource.version[1].eql?('4')
            execute "Moving Unity #{new_resource.version} to #{install_dir}" do
              command "move \"c:\\Program Files (x86)\\Unity\\Editor\" #{install_dir}"
            end
          elsif new_resource.version[1].eql?('5')
            execute "Moving Unity #{new_resource.version} to #{install_dir}" do
              command "move \"c:\\Program Files\\Unity\\Editor\" #{install_dir}"
            end
          end

          # clean up installer file but check if the install dir moved 1st
          if exists?
            base_filename = ::File.basename(new_resource.url)
            temp_pkg_file = ::File.join(Chef::Config[:file_cache_path], base_filename)
            delete_installer_file(temp_pkg_file)
          end
        end

        def install_dir
          ::File.join(new_resource.install_root, "Unity_#{new_resource.version}")
        end

        def exists?
          new_resource.force ? false : Dir.exists?(Chef.node.platform_family?('mac_os_x') ? install_dir : ::File.join(install_dir , 'Editor'))
        end

        # remove the installer file from chef cache dir
        # this help save some storage space
        def delete_installer_file(pkg_file)
          file pkg_file do
            action :delete
            only_if { ::File.exist?(pkg_file) }
          end
        end
      end
    end
  end
end
