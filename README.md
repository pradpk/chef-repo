# Chef
Chef is an automation platform to configure and manage the infrastructure.

## Installing Chef
- Download ChefDK from https://downloads.chef.io/chefdk/
- Run these commands to verify the installation.<br/>
    <code>where ruby</code> <br/> 
    <code>chef-client -v</code> 
- We need [Vagrant](https://www.vagrantup.com/downloads.html) and [Virtualbox](https://www.virtualbox.org/wiki/Downloads) as well.
- We need to have admin privileges to run chef commands as it configures the system. 
## Running Recipe
<code>chef-apply helloworld/hello.rb</code>
## Creating sandbox environment
- Chef codes can be written in the host machine and will be run on nodes using chef-client.
We can use TestKitchen to create sandbox/virtual environments which will act as nodes.
- Create a directory and run below commands to create the setup files. <br/>
<code>kitchen init --create-gemfile <br/>
bundle install </code>
- Run below commands to create a virtual machine. <br/>
<code>kitchen list</code> (it will provide the list of virtual machines) <br/>
<code>kitchen create default-centos-7</code> (name of the virtual machine will be available from command)
<br/><code>kitchen login default-centos-7</code> (to login into virtual machine)  

## Configuring node
- Nodes should have chef-client to run the chef code. We can install chef-client on the node from the host machine.
<br><code>kitchen setup default-centos-7</code> (will install chef-client)
<br><code>kitchen login default-centos-7</code>
<br><code>chef-client --version</code> (to verify the installation)

## Creating and running cookbooks
- We can generate cookbooks on the host and converge, which is the process of deploying cookbook on the node.
<br><code>chef generate cookbok motd</code>
- Get into the directory motd.
<br><code>chef generate file hello</code>
- Add a content within hello file created above. Example, Hello World.
- Edit recipes/default.rb and add the below Ruby file content.
```
cookbook_file '/etc/motd' do
    source 'hello'
end
```
- Converse into the node to run the cookbook in the node.
<br><code>kitchen converge default-centos-7</code>
<br><code>kitchen login default-centos-7</code>

[Using Cookbook resources](resource.md)
[Chef Server](chefserver.md)