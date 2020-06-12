#
# Cookbook:: apache
# Recipe:: index
#
# Copyright:: 2020, The Authors, All Rights Reserved.

template '/var/www/html/index.html' do
  source 'index.html.erb'
end