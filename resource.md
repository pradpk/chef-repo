# Cookbook Resources

- [cookbook_file](#cookbook_file)
- [template](#Using-template-resource)
- [package](#Using-package-resource)


## Using cookbook_file resource
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

## Using template resource
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

## Using package resource
- package resource can be used to manage the installation. 
- Sample for a package resource.
```
package 'httpd' do
  action :install
end
```

## Using service resource
- service resource is used to manage a service.
- Sample for a service resource.
```
service 'httpd' do
  action [:enable, :start]
end
```



