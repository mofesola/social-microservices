1. Title
On-Premise Deployments Solution Guide

2. Project Description

This project ensures deployment of multiple microservice applications in a scalable way. Project URL: https://github.com/mofesola/social-microservices

3. Installation / Usage Instructions
On local development, run docker-compose up. Use the --build switch if you made any changes to the codebase. Make sure to have docker and docker-compose installed, preferably the most recent versions

Once your PR is approved and merged to a baseline branch, e.g develop, staging or master, it will be automatically deployed to the relevant environment once tests are passed.

4. Use Cases and Edge Conditions
This setup will continue to scale container instances and by extension, ec2 instances based on our config

5. Workflow

N/A

6. Data formats and Reporting

Data logs will be streamed from docker containers using the logging driver to Elasticsearch via Fluentd. You can perform queries on the log or use the Kibana Dashboard to view intelligence

7. Performance and Scaling

Scaling will be handled by Amazon ECS based on the rules setup in the terraform config.

8. Unresolved issues

Write the travis build file
Write the nginx docker image
Add New Relic module within application for uptime and application performance monitoring