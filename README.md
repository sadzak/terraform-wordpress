

Quick and dirty wordpress infrastructure using only Terraform.

This will create:
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

Usage:
	git clone projecturl
	

NOTE: you need to create and download keypair using management console
