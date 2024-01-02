## How to deploy

- execute the run.sh for the deployment
- execute the destroy.sh to cleanup

## What we doing here

- We will be deploying 2 instances of neo4j on aks
- One instance will act as admin panal, which is functional on browser only.
- Another instance will be std user.
- std user instance can be configured with the backend code.

## How to use

- Since we are deploying the 2 instance, connection urls are different.
- Browser access of Admin - https://yourdomain
- DB access of admin - neo4j+s or bolt+s://yourdomain:443
- Browser access of std user - https://yourdomain:7473
- DB access of std user - neo4j+s://yourdomain:7687
