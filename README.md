Workable junior SRE assignment

Tasks
 
1. Create one of the following infrastructure pieces using automation tools: 
..* Replicated MongoDB cluster
..* Master-slave PostgreSQL setup
..* ELK stack You can use the automation tool of your choice; terraform(preferred), 
ansible(preferred), puppet, chef, etc 

2. Create a sample web app that has: 
..* A web server and replies to specific endpoints documented below.
..* Optional : Communicates with an external postgres db

This sample app should expose two endpoints: 
1. Reply to a /health endpoint with HTTP code 200 when the pod is up and running
2. Optional : Reply to a /ready endpoint with: 
..* HTTP code of 200 when the app can communicate with the local postgres 
..* HTTP code of 503 when app can’t communicate with the local postgres

You can use the virtualization technology of your choice; kubernetes/docker (preferred), vagrant, etc 
