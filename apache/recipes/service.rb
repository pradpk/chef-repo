#
# Cookbook:: apache
# Recipe:: service
#
# Copyright:: 2020, The Authors, All Rights Reserved.

service 'httpd' do
  action [:enable, :start]
end