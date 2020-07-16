#
# Cookbook:: enterprise-chef
# Recipe:: default
#
# Copyright:: 2020, The Authors, All Rights Reserved.

chef_server_url = node['chef-server']['url']
chef_server_package_name = ::File.basename(chef_server_url)

chef_manage_url = node['chef-manage']['url']
chef_manage_package_name = ::File.basename(chef_manage_url)

chef_server_package_local_path = "#{Chef::Config[:file_cache_path]}/#{chef_server_package_name}"
chef_manage_package_local_path = "#{Chef::Config[:file_cache_path]}/#{chef_manage_package_name}"

directory '/home/user/' do
    action :create
end

remote_file chef_server_package_local_path do
    source chef_server_url
end

remote_file chef_manage_package_local_path do
    source chef_manage_url
end

package chef_server_package_local_path do
    source chef_server_package_local_path
    provider Chef::Provider::Package::Rpm
    notifies :run, 'execute[chef_server_configure]', :immediately
end

execute 'chef_server_configure' do
    command 'chef-server-ctl reconfigure --chef-license=accept'
end

execute 'chef_user_create' do
    command "chef-server-ctl user-create userone userfname userlname userone@user.com 'password' --filename /home/user/userone.pem"
end

execute 'chef_org_create' do
    command "chef-server-ctl org-create userorg 'User Org' --association_user userone --filename /home/user/userorg-validator.pem"
end

package chef_manage_package_local_path do
    source chef_manage_package_local_path
    provider Chef::Provider::Package::Rpm
    notifies :run, 'execute[chef_manage_configure]', :immediately
end

execute 'chef_server_configure_post_manage' do
    command 'chef-server-ctl reconfigure --chef-license=accept'
end

execute 'chef_manage_configure' do
    command 'chef-manage-ctl reconfigure --chef-license=accept'
end