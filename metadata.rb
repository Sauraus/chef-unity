name 'unity'
maintainer 'Antek S. Baranski'
maintainer_email 'antek.baranski@gmail.com'
license 'Apache License, Version 2.0'
description 'Installs/Configures Unity Editor & Cache Server'
long_description 'Provides LWRP to install Unity Editor on OSX & Windows and also Unity Cache server on CentOS & Ubuntu'
version '2.1.0'

%w(mac_os_x windows centos ubuntu).each do |os|
  supports os
end

depends 'runit'
depends 'windows'
depends 'dmg'
depends 'ark'
depends 'haproxy'
depends 'monit'
