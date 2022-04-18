# ddogra1_ACS730_final_project

	
Readme  Steps  to implement :
	
1)	Create three S3 buckets 
	a) ddogra1-acs730-project-dev  [For Dev]
	   *Also create a folder dev-images/ and upload and image dev-environment.png in that folder *
	   
	   This value needs to be updated in the below locations:
	      ddogra1_ACS730_final_project/environments/dev/network/config.tf
		  ddogra1_ACS730_final_project/environments/dev/servers/config.tf		

	b) ddogra1-acs730-project-staging  [For Staging]
	   *Also create a folder staging-images/ and upload and image staging-environment.png in that folder *
	   
	   This value needs to be updated in the below locations:
		  ddogra1_ACS730_final_project/environments/staging/network/config.tf
	      ddogra1_ACS730_final_project/environments/staging/servers/config.tf
		
	c) ddogra1-acs730-project-prod     [For Production]
	   *Also create a folder prod-images/ and upload and image prod-environment.png in that folder *
           	
	   This value needs to be updated in the below locations:
		  ddogra1_ACS730_final_project/environments/prod/network/config.tf
	      ddogra1_ACS730_final_project/environments/prod/servers/config.tf		  


2)  Now clone the git  repository in your local environment from Prod
    
    git clone https://github.com/dhananjaydogra/ddogra1_ACS730_final_project.git

    Once done create 3 ssh key pairs 
	a) path : ddogra1_ACS730_final_project/environments/dev/servers/      key-name: sshkey_Dev
	b) path : ddogra1_ACS730_final_project/environments/staging/servers/  key-name: sshkey_Staging
	b) path : ddogra1_ACS730_final_project/environments/prod/servers/     key-name: sshkey_Prod
	
3)  Validate and update the public and private IP of your cloud9 environment and your IP and update in the given location, **It is important otherwise bastion will not be accessible**
      path :  ddogra1_ACS730_final_project/modules/global_var/output.tf
	  
4) Validate the value of iam_instance profile that should have a policy "AmazonS3ReadOnlyAccess", If you can create one, then create add attach that policy or use an existing profile and update the role assoicated with it and add the above policy.
   Need to use the name of the instance profile and update the default value in the 
    variable "iam_instance_profile_name" 
	present at locations : 
	ddogra1_ACS730_final_project/environments/dev/servers/variables.tf
	ddogra1_ACS730_final_project/environments/staging/servers/variables.tf
	ddogra1_ACS730_final_project/environments/prod/servers/variables.tf
----------------------------------------------------------------------------------------------------------------------------------------------------------------------	

5)#After that you need to deploy infrastructure in sequential order
   use commands at all the below given locations:
	terraform init
	terraform fmt
	terraform validate
	terraform plan
	terraform --auto-approve

   a)Network
		from :  ddogra1_ACS730_final_project/environments/dev/network/
		from :  ddogra1_ACS730_final_project/environments/staging/network/
		from :  ddogra1_ACS730_final_project/environments/prod/network/
   b)Servers 
		from :  ddogra1_ACS730_final_project/environments/dev/servers
		from :  ddogra1_ACS730_final_project/environments/staging/servers
		from :  ddogra1_ACS730_final_project/environments/prod/servers
     "Here take a note of the output having the Bastion Public IP address and URl for DNS name in nonprod VPC, Needed for testing and validation"	
	   
-----------------------------------------------------------------------------------------------------------------------------------------------------------------------
6) For Testing the deployed architecture:

a) You can take the DNS Name from the respective deployment output for servers of dev,prod and staging  environments
   Output DNS Variable : 'Dev_DNS_Name',  'Staging_DNS_Name'  and  'Prod_DNS_Name'

   Use the Urls: To access the LB and webserserers you will get the "Private IP" of servers from there please take a note of them. in case you want to test ssh.


   Another output variablse : 'Dev_Bastion_PublicIP', 'Staging_Bastion_PublicIP' and 'Prod_Bastion_PublicIP'
   They will give the IP for Bastion you can access it from cloud9 environment

b) You can connect to the bastion host using the ssh
	location:  ddogra1_ACS730_final_project/environments/prod/servers/
	command : ssh -i sshkey_Prod ec2-user@<bastion_public_ip>     (You will get the Bastion IP address from the output of Prod servers deployment)
   With this, you have connected to bastion host in Prod public subnet

c) To validate ssh need to copy the key that was created in Step 2 (a) sshkey_Prod need to create the same key in the bastion host with the content of the already created key in cloud9.
   file location: ddogra1_ACS730_final_project/environments/prod/servers/
   >> So copy the contents of sshkey_Prod to a new file and change the permissions to 400 using command : chmod 400 <filename>
   To open ssh use command ssh -i <key filename you created> ec2-user@<private IP address you noted from nonprod webservers deployment>
   
d) Same step is needed for connecting to private servers in Dev and Staging environments, create key in bastion host server based on the content of sshkey_Dev and sshkey_Staging keys.
   file location: ddogra1_ACS730_final_project/environments/dev/servers
   file location: ddogra1_ACS730_final_project/environments/staging/servers
   
   create a new key file with the same content as the above key
   change the persmission of the new file to 400
   Now you can connect to the Dev and Staging vpc servers
   
   
  
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
#To destroy the infrastructure use the reverse order from above 
(use command: terraform destroy --auto-approve ) at all the below locations

1) Servers 
	from :  ddogra1_ACS730_final_project/environments/dev/servers
	from :  ddogra1_ACS730_final_project/environments/staging/servers
	from :  ddogra1_ACS730_final_project/environments/prod/servers

3) Network
	from :  ddogra1_ACS730_final_project/environments/dev/network/
	from :  ddogra1_ACS730_final_project/environments/staging/network/
	from :  ddogra1_ACS730_final_project/environments/prod/network/

