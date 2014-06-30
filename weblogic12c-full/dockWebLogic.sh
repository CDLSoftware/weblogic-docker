#!/bin/sh
docker rm wls12c
docker run -d -p 7001:7001 --name wls12c oracle/weblogic12c /u01/oracle/home/user_projects/domains/base_domain/bin/startWebLogic.sh
