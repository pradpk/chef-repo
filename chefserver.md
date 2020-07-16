#Chef Server

- Chef server is the centralized store (stores and indexes cookbooks, environments, templates, metadata, files and distribution policies) for configuration data in your infrastructure.
- Chef server consists of Erchef (written in Erlang), web server (nginx), bookshelf (contains Chef cookbooks, is flat-file database), web interface (Ruby on Rails), search index (Apache Solr server), messaging queue (handles all messages sent to Search Index, managed by RabbitMQ) and backend database (PostgreSQL). 
- We can download Chef server @ https://downloads.chef.io/chef-server/

##Types of Chef Servers
- Hosted Enterprise Chef: Cloud based and highly scalable.
- Enterprise Chef On Premise: Private Chef server inside organization's firewall. Can manage up to 5 nodes freely.
- Open Source Chef Server: Free and open source version of Chef server, can manage unlimited number of nodes.

##Installing Chef Server
- Move the download Chef server component to a linux machine using test kitchen.
- First, create a VM where you can install [Chef server](https://packages.chef.io/files/stable/chef-server/13.2.0/el/7/chef-server-core-13.2.0-1.el7.x86_64.rpm) and [Chef Manage](https://packages.chef.io/files/stable/chef-manage/3.0.11/el/7/chef-manage-3.0.11-1.el7.x86_64.rpm). 
We need to have recipes that will move Chef server and Chef manage artifacts to the VM. Run below commands to converge them.
```
cd cookbooks/enterprise-chef
kitchen create default-centos-7
kitchen converge default-centos-7
```
- Above commands will install Chef Server and Chef Manage and have the server ready. Chef Manage is needed as it will provide UI to Chef server.
- Optional: In case, if you want to do manual installation of Chef server instead of running above 2 steps, please follow the below steps.
```
kitchen create (creating VM)
kitchen login (login to VM)
sudo su
cd /user
mkdir keys
cd /tmp/kitchen/cache
rpm -Uvh chef-server-core-13.2.0-1.el7.x86_64.rpm
chef-server-ctl reconfigure --chef-license=accept
chef-server-ctl service-list (this will display chef server's service list) 
chef-server-ctl user-create <username> <firstname> <lastname> <emailaddress> '<password>' --filename /user/keys/<keyname>.pem
chef-server-ctl org-create <orgname> '<fullorgname>' --association_user <adminusername> --filename /user/keys/<orgkey>>-validator.pem  
chef-server-ctl reconfigure --chef-license=accept
cd /tmp/kitchen/cache
rpm -Uvh chef-manage-3.0.11-1.el7.x86_64.rpm
chef-manage-ctl reconfigure
```
- Enter http://192.168.33.34 in the browser (192.168.33.34 comes from private_network section in kitchen.yml). It will request for username and password. 
You can provide the username and password of the user.
- Click on Administration tab -> Organizations -> Select Organization -> Actions -> Reset Validation Key. 
Download the orgname-validator.pem and paste it under cookboooks/enterprise-chef/.chef. Click on Actions -> Generate Knife Config and copy it to cookbooks/enterprise-chef/.chef.
- Click on Users -> Actions -> Reset Key.
Download username.pem and keep it under cookbooks/enterprise-chef/.chef.
- In Chef workstation, run 'knife ssl fetch' command to create truststore for the Chef server in Chef workstation. This will be used by Chef workstation to connect to Chef server. 
- Run 'knife ssl check' command to check ssl connection to Chef server.
``` 
knife ssl fetch
knife ssl check
``` 
- Run below command to view a list of registered clients. It should display 'orgname-validator' mentioned in validation_client_name field in knife.rb.
```
knife client list
```
- Chef server installation is complete.

##Bootstrapping a node to register with Chef server

- Create node directory within enterprise-chef/ and run below command to initiate TestKitchen configuration.
```
cd node
kitchen init --create-gemfile
bundle install
```
- Update the suite name to 'node' in kitchen.yaml and register the ip 192.168.33.35 (different from server). 
```
kitchen create
```
- Login into VM and every node needs to have 3 files -> client.rb, first-boot.json and .pem file.
```
cd /etc
mkdir chef
cp /chef-repo/cookbooks/enterprise/.chef/<orgname>-validator.pem /etc/chef
cd /etc/chef
vi client.rb
```
- Contents of client.rb
```
current_dir = File.dirname(__FILE__)
        log_level               :info
        log_location            STDOUT
        chef_server_url         "https://default-centos-7.vagrantup.com/organizations/userorg"
        ssl_verify_mode         :verify_none
        chef_license            "accept"
        validation_key          '/etc/chef/userorg-validator.pem'
        validation_key          '/etc/chef/userorg-validator.pem'
        validation_client_name  'userorg-validator'
```
- Lastly, create first_boot.json. Before running below command, go to Chef Manage UI -> Policy
-> Roles -> Create with name as 'base'. 
```
vi first_boot.json

{
	"run_list" :[
		"role[base]"
	]
}
```
- Edit ths hosts to include below entry in the node. This will be used when the node registers to the server.
```
sudo vi /etc/hosts
192.168.33.34   default-centos-7.vagrantup.com
```
- Log out of the VM and run below command to bootstrap the node. 
Bootstrap is the process of installing Chef client on the node and registering the node with Chef server.
```
knife bootstrap node-centos-7.vagrantup.com -U vagrant -N node --chef-license accept --sudo
```


