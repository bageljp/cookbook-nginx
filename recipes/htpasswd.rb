#
# Cookbook Name:: nginx
# Recipe:: htpasswd
#
# Copyright 2014, bageljp
#
# All rights reserved - Do Not Redistribute
#

package "httpd24-tools"

cookbook_file "/etc/nginx/htpasswd" do
  owner "root"
  group "root"
  mode 00644
end

