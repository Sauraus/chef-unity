# unity-cookbook

This cookbook provides LWRP to install Unity Editors on OSX & Windows. 
And also provides a LWRP to install a Unity Cache server, optionally 
with a haproxy infront of it to load balance between multiple instances.

## Supported Platforms

Editor::
 - Windows
 - Mac OSX

Cache Server::
 - CentOS
 - Ubuntu

## Attributes

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['chef-unity']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

## Usage

### unity::default

Include `unity` in your node's `run_list`:

```json
{
  "run_list": [
    "recipe[unity::default]"
  ]
}
```

## License and Authors

- Author:: Antek S. Baranski (<antek.baranski@gmail.com>)
- Copyright 2016, Antek S. Baranski

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
