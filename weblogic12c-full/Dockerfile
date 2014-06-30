#
# Oracle Dockerfile for WebLogic 12.1.3 FULL Distro
# 
# Download fmw_12.1.3.0.0_wls.jar from www.oracle.com/technetwork/middleware/weblogic/downloads/index.html
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
ADD oraInst.loc /u01/oraInst.loc
ADD install.file /u01/install.file
ADD fmw_12.1.3.0.0_wls.jar /u01/fmw_12.1.3.0.0_wls.jar

RUN chown oracle:oracle -R /u01

WORKDIR /u01

USER oracle

RUN mkdir /u01/oracle/.inventory
ENV CONFIG_JVM_ARGS -Djava.security.egd=file:/dev/./urandom
RUN java -jar fmw_12.1.3.0.0_wls.jar -silent -responseFile /u01/install.file -invPtrLoc /u01/oraInst.loc -jreLoc /usr/lib/jvm/java-7-oracle
RUN /u01/oracle/home/wlserver/common/bin/wlst.sh -skipWLSModuleScanning /u01/create-wls-domain.py
RUN rm -f /u01/create-wls-domain.py /u01/oraInst.loc /u01/install.file /u01/fmw_12.1.3.0.0_wls.jar
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
