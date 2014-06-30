#
# Oracle Dockerfile for WebLogic 12.1.3 ZIP Distro
# 
# Download wls1213_dev.zip from www.oracle.com/technetwork/middleware/weblogic/downloads/index.html
# and put it in the same dir as this Dockerfile
#
# https://github.com/weblogic-community/weblogic-docker
#

# Pull base image
FROM dockerfile/java

MAINTAINER Bruno Borges <bruno.borges@oracle.com>

RUN mkdir /u01
RUN chmod a+x /u01
RUN chmod a+r /u01

RUN useradd -b /u01 -m -s /bin/bash oracle
RUN echo oracle:welcome1 | chpasswd

ADD create-wls-domain.py /u01/create-wls-domain.py
ADD wls1213_dev.zip /u01/wls1213_dev.zip

RUN chown oracle:oracle -R /u01

WORKDIR /u01

USER oracle

ENV JAVA_HOME /usr/lib/jvm/java-7-oracle
RUN unzip /u01/wls1213_dev.zip -d /u01/oracle/
WORKDIR /u01/oracle/wls12130
RUN sh configure.sh -silent
ENV CONFIG_JVM_ARGS -Djava.security.egd=file:/dev/./urandom
RUN /u01/oracle/wls12130/wlserver/common/bin/wlst.sh -skipWLSModuleScanning /u01/create-wls-domain.py
RUN rm /u01/create-wls-domain.py /u01/wls1213_dev.zip

RUN echo ". /u01/oracle/wls12130/user_projects/domains/base_domain/bin/setDomainEnv.sh" >> /u01/oracle/.bashrc
RUN echo "export PATH=$PATH:/u01/oracle/wls12130/user_projects/domains/base_domain/bin" >> /u01/oracle/.bashrc

# Expose Node Manager default port, and also default http/https ports for admin console
EXPOSE 5556 7001 7002

USER root

RUN echo ". /u01/oracle/wls12130/user_projects/domains/base_domain/bin/setDomainEnv.sh" >> /root/.bashrc
RUN echo "export PATH=$PATH:/u01/oracle/wls12130/user_projects/domains/base_domain/bin" >> /root/.bashrc

WORKDIR /u01/oracle/home

# Define default command to start bash. 
# Modify if you want to start a nodemanager or the admin server by default
CMD ["/bin/bash"]
# CMD ["/u01/oracle/wls12130/user_projects/domains/base_domain/bin/startNodeManager.sh"]
# CMD ["/u01/oracle/wls12130/user_projects/domains/base_domain/bin/startWebLogic.sh"]

