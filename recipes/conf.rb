#
# Cookbook Name:: nginx
# Recipe:: conf
#
# Copyright 2014, bageljp
#
# All rights reserved - Do Not Redistribute
#

include_recipe "nginx::default"

case node['nginx']['conf']['template_dir']
when nil
  template "/etc/nginx/nginx.conf" do
    owner "root"
    group "root"
    mode 00644
    if File.file?("nginx.conf-#{node['nginx']['version']['major']}.#{node['nginx']['version']['minor']}.erb")
      source "nginx.conf-#{node['nginx']['version']['major']}.#{node['nginx']['version']['minor']}.erb"
    end
    notifies :restart, "service[nginx]"
  end
else
  Chef::Config[:cookbook_path].each{|elem|
    if File.exists?(File.join(elem, "/nginx/templates/default/", node['nginx']['conf']['template_dir']))
      conf_dir = File.join(elem, "/nginx/templates/default/", node['nginx']['conf']['template_dir'])
      Dir.chdir conf_dir
      confs = Dir::glob("**/*")

      confs.each do |t|
        if File::ftype("#{conf_dir}/#{t}") == "file"
          template "/etc/nginx/#{t}" do
            owner "root"
            group "root"
            mode 00644
            source "#{node['nginx']['conf']['template_dir']}/#{t}"
            notifies :restart, "service[nginx]"
          end
        end
      end
    end
  }
end

if node['nginx']['ssl']['enable']
  directory "#{node['nginx']['ssl']['root_dir']}" do
    owner "root"
    group "root"
    mode 00755
    recursive true
  end
  
  directory "#{node['nginx']['ssl']['root_dir']}/#{node['nginx']['ssl']['link_dir']}" do
    owner "root"
    group "root"
    mode 00755
    recursive true
  end
  
  %W(
    #{node['nginx']['ssl']['server_key']}
    #{node['nginx']['ssl']['server_crt']}
  ).each do |pem|
    if !pem.empty?
      cookbook_file "#{node['nginx']['ssl']['root_dir']}/#{pem}" do
        owner "root"
        group "root"
        mode 00644
        source "#{pem}.erb"
      end
      link "#{node['nginx']['ssl']['root_dir']}/#{pem}" do
        owner "root"
        group "root"
        to "#{node['nginx']['ssl']['link_dir']}/#{pem}"
      end
    else
      package "mod24_ssl"
    end
  end
end
