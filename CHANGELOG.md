# unity Cookbook Change Log

##2.1.0
* Refactor cache server recipes to accomodate wrapper recipes.

##2.0.1
* Size needs to be a String to allow very large cache servers

##2.0.0
* Refactor Unity Cacheserver install to be a LWRP
* Add a haproxy based cluster config of Unity Cacheserver for big build farms.

##1.0.8
* add clean up step to delete unity installer file from chef cache folder, which will save disk space

##1.0.7
* Cleanup Windows AudioSvc service start
* Fixed bad paths for cleaning up previous Windows Unity editor installs locations

##1.0.6
* Fixed Unity 5.3.x editor install for windows to use 7zip directly instead of "ark"

##1.0.5
* Added Unity 5.3.x editor install for Windows via hand-rolled zip file using "ark"
* Changed Unity 5.3.x editor install for OSX via hand-rolled tarball to using "ark"

##1.0.4
* Enable and start 2012R2 Audio service, required by Unity

##1.0.3
* Bump Unity CacheServer to 5.3.1f1

##1.0.2
* Added support to install Unity editor via hand-rolled tarball

##1.0.1
* Bump Unity cache server to 150GB
* Fixup /var folder usage which is limited in size

##1.0.0
* Added Unity Cache server install & config on CentOS

##0.3.0
* Fix up breaking chef-client 12.5.1 LWRP changes

##0.2.2
* Fix OSX install check regression

##0.2.1
* Unity installer does respect destination folder
* Harden installer to recover bad installs

##0.2.0
* Cleanup and small refactor

##0.1.1
* Cleanup implementation
* Change Unity editor installer location in data bags for kitchen

##0.1.0
* Initial release of the Unity cookbook, with support for Unity Editor installs on OSX
