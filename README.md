Workable junior SRE assignment

Tasks
 
1. Create one of the following infrastructure pieces using automation tools: 
    * Replicated MongoDB cluster
    * Master-slave PostgreSQL setup
    * ELK stack 

You can use the automation tool of your choice; terraform(preferred), 
ansible(preferred), puppet, chef, etc 

2. Create a sample web app that has: 
    * A web server and replies to specific endpoints documented below.
    * Optional : Communicates with an external postgres db

This sample app should expose two endpoints: 
1. Reply to a /health endpoint with HTTP code 200 when the pod is up and running
2. Optional : Reply to a /ready endpoint with: 
    * HTTP code of 200 when the app can communicate with the local postgres 
    * HTTP code of 503 when app can’t communicate with the local postgres

You can use the virtualization technology of your choice; kubernetes/docker (preferred), vagrant, etc 
_ _ _
Solution
_ _ _

The suggested solution for this assignment will involve the following technologies:

1. A t2 micro (Free tier) EC2 instance on AWS that will run a docker daemon to containerize each component
2. A postgresql master-slave setup
3. A simple python application written in Flask
4. Ansible will be used from a local machine to setup and run our solution with minimum interaction

In the following sections I will be describing additional steps that need to be taken in advance
before attempting to run the solution both on AWS and the local machine. We will not be going in depth
on how to achive them as it is out of the scope of the assignment but all the requirements will be summed up.
_ _ _
AWS Pre-requirements
_ _ _

1. An aws account with administrator access rights. At the very minimum the account will allow launching 
new instances and managing their state.

2. Active access key id and secret for programmatical access on AWS resources.

3. A vpc and subnet in the vpc to allocate the instance to for a specific availability zone. 

4. A pem formatted key-pair to allow for ssh to the target machine that will be running the solution. Make sure that
the key has restricted access rights on the local machine (400 or 600).

5. A security group to assign to the instance with the following rules:
    * Inbound TCP port 5000 to all ips (0.0.0.0/0) for the flask app.
    * Inbound TCP port 22 to all ips (0.0.0.0/0) to be able to ssh to the target machine.
    * All outbound access.

Do note that the above settings are only suggested for the purposes of this assignment and a more restrictive
approach should be taken on a real life scenario based on the platform that we are working on and the surface that we must expose to the public.

_ _ _
Ansible Pre-requirements
_ _ _

1. Make sure that ansible is present on the local machine. The solution has been tested with ansible version 2.9.12

2. All requirements listed on ansible-requirements.txt are installed to avoid any missing dependencies issues.

3. Ansible and ansible-playbook are on the correct path.

4. The local machine running the ansible playbooks requires rsync to be installed.

_ _ _
Launching the AWS instance
_ _ _

1. Clone the repository localy

2. Switch to the root directory of the cloned repository

3. Make sure that the hosts file is an executable (555 access rights should do the trick).

4. Make sure to uncomment and adjust variables in variables/target.yml to mirror your aws setup.

5. Make sure to adjust aws credentials and region in scripts/envexports

6. Source scripts/envexports
	```	
	. scripts/envexports
	```
7. Run the playbook
	```
	ansible-playbook playbooks/launch_ec2_instance.yml -e "@variables/target.yml" 
	```
8. Wait for the playbook to exit.

What we are doing here is simply launching an ec2 instance on aws and waiting untill we can ssh to it.

If you encounter any errors while running the playbook do not move on to the next step.

_ _ _
Configuring the AWS instance
_ _ _

1. Run the playbook
	```
	ansible-playbook playbooks/configure_instance.yml -e "@variables/target.yml" --private-key <full-path-to-your-private-key>
	```
2. When prompted press yes to proceed with the ssh connection
 
This playbook will install docker, docker-compose and dependencies, reboot the mahcine and then wait untill we can ssh again to it.

Do note that unlike the previous playbook run here we specify a path to private key that will be used to ssh to the target machine.

Do note also that this is the minimum required configuration for this particular
assignment. In real situations we would probably have to configure other aspects of the machine as well such as dns, hostname, apt repositories, time, logging and/or install packages and agents running on the system for mail, monitoring etc.

At the end of this step we have a basic ec2 instance with Debian Stretch that can run docker containers for us.

_ _ _
Running the containers
_ _ _

1. Run the playbook
	```
	ansible-playbook playbooks/run_containers.yml -e "@variables/target.yml" --private-key <full-path-to-your-private-key>
	```
2. When prompted, input a name for the database, a user for the database and a password for the user. These will environmentals for the containers running postgres and the app and will be used by the app to connect to the postgresql backend.

Once the playbook exits verify from your local machine that the app is up and running by making a request to the health endpoint.__
	```
	curl -I <public-ip>:5000/health	
	```
This should return a 200 HTTP Code

You can verify the connectivity with the master Postgresql DB by making a request
to the ready endpoint.__
	```
	curl -I <public-ip>:5000/ready
	```
This should return a 200 HTTP Code

If the app cannot connect to the backend it should return a 503 HTTP code
We can easily verify that by sshing to the target machine and stopping the container of the master database.__
	```
	docker stop src_master_1	
	```
Now repeating the request to the ready endpoint should yield a 503 HTTP Code

TO DO:
* Configure replication between Master and Slave
* Add sections to the README about the flask app and the postgresql master-slave setup
