# rancher-tf-aws
## Scripts and files to create a rancher kubernetes cluster using terraform on AWS with minimum steps.

### Overview
The terraform files and scripts in this repo will allow you to create a rancher kubernetes cluster on AWS with very little effort.
There are few steps to do as a one time activity
and after that, 
if you want to create a cluster, all you need to do is run: `terraform apply` and to destroy the cluster just run `terraform destroy`
You will get following resources created:
- VPC
- NAT instance
- Public Subnet
- Private subnet
- Security groups
- Your custom keypair
- EC2 instances on ubuntu 14.04

### Pre requisites

* AWS account with privileges to create EC2, VPC resources.
* Access Key and Secret Access Key for above account
* ssh keypair generated for your user
* terminal which understands bash (Mac users can open regular command prompt), while Windows users need a bash emulator like [gitbash](https://git-scm.com/download/win) or [cygwin](https://cygwin.com/install.html) or [MobaXterm] (http://mobaxterm.mobatek.net/download.html)

### One time setup steps

* Clone this repo in an empty folder 
* Copy your public and private keys in ssh folder 
* Create a file called terraform.tfvars in rancher-tf-aws folder and add following content to it 
~~~
access_key = "YOUR_AWS_ACCESS_KEY"
secret_key = "YOUR_AWS_SECRET_ACCESS_KEY"
# Select among following: us-west-1 us-east-1 ap-southeast-1 eu-central-1 , 
# we can add more regions later or if you want to send pull requests, you are welcome.
region = "YOUR_REGION"
# Add contents of your public key below
aws_public_key = "CONTENTS_OF_YOUR_PUBLIC_KEY" 
aws_private_key_name = "NAME_FOR_YOUR_KEYPAIR"
#
# The default k8s project name is "k8srancher", if you want to overwrite this name,
# uncomment the line below and use your own name
#rs_proj_name = "YOUR_OWN_PROJECT_NAME"
~~~

### Steps to create kubernetes on rancher 

* Run `terraform apply` This will do following steps:
  1. Create an VPC, security groups and EC2 instance as master and start rancher server on it 
  2. Once EC2 instance is created, script waits 50 seconds for the rancher server to boot up. 
  3. API are triggered to create a rancher environment called "k8srancher" (or your own defined name if you have overwritten the default in terraform.tfvars), and rancher server is activated as first host of the cluster.
  4. Terraform is called again to create remaining EC2 instances and join them to the cluster. 

### Steps to destroy the cluster 

* cd to repo folder and run `terraform destroy`. There will be a prompt from terraform for confirmation, type `yes` and all resources will be destroyed.

