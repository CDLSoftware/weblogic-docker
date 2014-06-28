#
# Oracle Dockerfile for WebLogic 12.1.2 Full Distro
#
# https://github.com/oracle/docker
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
ADD oraInst.loc /u01/oraInst.loc
ADD install.file /u01/install.file
ADD wls12c_full.jar /u01/wls12c_full.jar

RUN chown oracle:oracle -R /u01

WORKDIR /u01

USER oracle

RUN mkdir /u01/oracle/.inventory
RUN java -jar wls12c_full.jar -silent -responseFile /u01/install.file -invPtrLoc /u01/oraInst.loc -jreLoc /usr/lib/jvm/java-7-oracle
RUN /u01/oracle/home/wlserver/common/bin/wlst.sh -skipWLSModuleScanning /u01/create-wls-domain.py
RUN rm -f /u01/create-wls-domain.py /u01/oraInst.loc /u01/install.file
RUN echo ". /u01/oracle/home/user_projects/domains/base_domain/bin/setDomainEnv.sh" >> /u01/oracle/.bashrc
RUN echo "export PATH=$PATH:/u01/oracle/home/user_projects/domains/base_domain/bin" >> /u01/oracle/.bashrc

# Expose Node Manager default port, and also default http/https ports for admin console
EXPOSE 5556 7001 7002

USER root

RUN echo ". /u01/oracle/home/user_projects/domains/base_domain/bin/setDomainEnv.sh" >> /root/.bashrc
RUN echo "export PATH=$PATH:/u01/oracle/home/user_projects/domains/base_domain/bin" >> /root/.bashrc

WORKDIR /u01/oracle/home

# Define default command to start bash. 
# Modify if you want to start a nodemanager or the admin server by default
CMD ["/bin/bash"]
# CMD ["/u01/oracle/home/user_projects/domains/base_domain/bin/startNodeManager.sh"]
# CMD ["/u01/oracle/home/user_projects/domains/base_domain/bin/startWebLogic.sh"]
