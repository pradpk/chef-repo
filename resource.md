#Cookbook Resources

- [cookbook_file](#cookbook_file)
- [template](#Using-template-resource)
- [package](#Using-package-resource)


##<a name="cookbook_file"></a>Using cookbook_file resource
- Cookbook_file resource is used to transfer files from cookbook_name/files to the specified path on the node.
- Create a new file within a cookbook.
```
chef generate file hello
```
- Edit the recipe file to copy the contents from file hello to a path in the node.
```
cookbook_file '/etc/motd' do
  source 'hello'
end
```

##Using template resource
- Template lets you create file content using variables from Embedded Ruby template (ERB).
- Create a new template within a cookbook.
<br><code>chef generate template info</code>
- Edit templates/info.erb.
```
  Hostname: <%= node['hostname'] %>
  Ipaddress: <%= node['ipaddress'] %>
```
- Edit the recipe file to include info.erb.
```
template '/etc/motd' do
  source 'info.erb'
end
```

##Using package resource
- Template lets you create file content using variables from Embedded Ruby template (ERB).
- Create a new template within a cookbook.
<br><code>chef generate template info</code>
- Edit templates/info.erb.
```
  Hostname: <%= node['hostname'] %>
  Ipaddress: <%= node['ipaddress'] %>
```
- Edit the recipe file to include info.erb.
```
template '/etc/motd' do
  source 'info.erb'
end
```



