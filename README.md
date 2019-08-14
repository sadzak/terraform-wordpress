

**Quick and dirty wordpress infrastructure using only Terraform. Created for testing purposes only.**

**This will create:**
```
	- VPC
	- Subnets
	- Internet Gateway
	- Routing table
	- Security Groups
	- Elastic Load Balancer
	- RDS (MySQL)
	- EFS 
	- Launch Configuration
	- Autoscaling Group (1 server)
	- Mount EFS to linux instance(s) 
	- Deploy Wordpress + config file (Only first instance)
```

**Usage:**
```
	git clone https://github.com/sadzak/terraform-wordpress.git
	cd terraform-wordpress
	terraform init
	Change vars.tf file accourding to your credentials.
        NOTE: You need to create and download keypair using management console, use existing one or import one.
	      Key must be in the same folder as project or chnage files as you wish.
	terraform plan
	terraform apply
```	 
**TODO**
	Remove ELB and setup EIP (attach) on instances on boot.
	Move EFS to other private subnet.
	Create auto updater for Security Groups with our public IP address.
	

