#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2014, bageljp
#
# All rights reserved - Do Not Redistribute
#

case node['nginx']['install_flavor']
when "yum"
  # yum
  package "nginx"

  template "/etc/sysconfig/nginx" do
    owner "root"
    group "root"
    mode 00644
    if File.file?("nginx.sysconfig-#{node['nginx']['version']['major']}.#{node['nginx']['version']['minor']}.erb")
      source "nginx.sysconfig-#{node['nginx']['version']['major']}.#{node['nginx']['version']['minor']}.erb"
    else
      source "nginx.sysconfig.erb"
    end
    notifies :restart, "service[nginx]"
  end

  template "/etc/logrotate.d/nginx" do
    owner "root"
    group "root"
    mode 00644
    if File.file?("nginx.logrotate-#{node['nginx']['version']['major']}.#{node['nginx']['version']['minor']}.erb")
      source "nginx.logrotate-#{node['nginx']['version']['major']}.#{node['nginx']['version']['minor']}.erb"
    else
      source "nginx.logrotate.erb"
    end
  end

  template "/etc/security/limits.d/90-nginx.conf" do
    owner "root"
    group "root"
    mode 00644
    source "limits.conf.erb"
    notifies :restart, "service[nginx]"
  end

  if node['nginx']['group']['add'] != nil
    group "#{node['nginx']['group']['add']}" do
      action :modify
      members "#{node['nginx']['user']}"
      append true
    end
  end

  service "nginx" do
    supports :status => true, :restart => true, :reload => true
    action [ :enable, :start ]
  end
end

