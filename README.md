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
