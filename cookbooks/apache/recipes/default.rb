#
# Cookbook Name:: apache
# Recipe:: default
#
# Copyright 2017, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package "httpd" do 
	action :install
end


service "httpd" do
	action [:enable, :start]
end
#--------------------------simple attribute definations and priority-----------------------------------------------------------------
#node.default["apache"]["indexfile"]="index.html"

#cookbook_file "/var/www/html/index.html" do
#	source node["apache"]["indexfile"]
#	mode "0644"
#end
#---------------------------------------------------------------------------

execute "mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.disabled" do
	only_if do 
		File.exist?("/etc/httpd/conf.d/welcome.conf")
	end
	notifies :restart,"service[httpd]"
end

node["apache"]["sites"].each do |site_name,site_data|
document_root="/var/www/apache/#{site_name}"


template "/etc/httpd/conf.d/#{site_name}.conf"	do
	source "custom.erb"
	mode "0664"
	variables(
		:document_root => document_root,
		:port => site_data["port"]
	)
    notifies :restart,"service[httpd]"
end

directory document_root do 
	mode "0755"
	recursive true
end

template "#{document_root}/index.html" do 
	source "index.erb"
	mode "0664"
	variables(
	:site_name => site_name,
	:port => site_data["port"]
	)
end
end