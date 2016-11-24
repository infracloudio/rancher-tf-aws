# rancher-tf-aws
## Scripts and files to create a rancher kubernetes cluster using terraform on AWS with minimum steps.

### Overview
The terraform files and scripts in this repo will allow you to create a rancher kubernetes cluster on AWS with very little effort.
There are few steps to do as a one time activity
and after that, 
if you want to create a cluster, all you need to do is run: `runme.sh all` and to destroy the cluster just run `runme.sh del`
### Pre requisites

* AWS account with privileges to create EC2, VPC resources.
* Access Key and Secret Access Key for above account
* ssh keypair generated for your user
* terminal which understands bash (Mac users can open regular command prompt), while Windows users need a bash emulator like [gitbash](https://git-scm.com/download/win) or [cygwin](https://cygwin.com/install.html) or [MobaXterm] (http://mobaxterm.mobatek.net/download.html)

### One time setup steps

* Clone this repo in an empty folder 
* Copy your public and private keys in ssh folder 
* 


