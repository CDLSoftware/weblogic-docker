#!/bin/sh
docker rm wls12cdev
docker run -d -p 7001:7001 --name wls12cdev oracle/weblogic12c_dev /u01/oracle/wls12130/user_projects/domains/base_domain/startWebLogic.sh
