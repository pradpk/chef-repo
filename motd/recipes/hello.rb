#
# Cookbook:: motd
# Recipe:: hello
#
# Copyright:: 2020, The Authors, All Rights Reserved.

file '/etc/file_example.txt' do
  content 'File resource example'
end

cookbook_file '/etc/cookbook_example.txt' do
  source 'hello'
end

template '/etc/motd' do
  source 'info.erb'
end
