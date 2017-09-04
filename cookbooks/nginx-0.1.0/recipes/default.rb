#
# Cookbook Name:: nginx
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package 'nginx' do
  action :install
end

service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action [:start, :enable]
end

node["nginx"]["sites"].each do |site_name,site_port|
	document_root="/opt/#{site_name}"


template "/etc/nginx/conf.d/#{site_name}.conf"	do
	source "custom.erb"
	mode "0664"
	variables(
		:document_root => document_root,
		:port => site_port["port"]
	)
   notifies :restart,"service[nginx]"
end

directory document_root do 
	owner 'root'
	group 'root'
	mode "0755"
	recursive true
end

template "#{document_root}/index.html" do 
	source "index.erb"
	mode "0664"
	variables(
	:site_name => site_name,
	:port => site_port["port"]
	)
end
end