# WebAnno3 Docker container
# mysql:latest is based on debian (latest?)
FROM mysql:latest
MAINTAINER David Lukeš <lukes@korpus.cz>

# add Oracle Java 8 repo
# RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
# RUN echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
# RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886

RUN echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list && \
  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886

# silence Java package's request to accept license (see <http://askubuntu.com/questions/190582/installing-java-automatically-with-silent-option>)
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections

RUN apt-get update

# install java
RUN apt-get install -y oracle-java8-installer oracle-java8-set-default

# install tomcat and configure instance
RUN apt-get install -y tomcat8-user authbind
WORKDIR /opt
RUN tomcat8-instance-create -p 18080 -c 18005 webanno && \
  chown -R www-data:www-data /opt/webanno
WORKDIR /

# install webanno
ADD https://webanno.github.io/webanno/releases/3.0.0/docs/admin-guide/scripts/webanno /etc/init.d
ADD https://github.com/webanno/webanno/releases/download/webanno-3.0.0/webanno-webapp-3.0.0.war /opt/webanno/webapps/webanno.war
RUN chmod 755 /etc/init.d/webanno && \
  chmod 644 /opt/webanno/webapps/webanno.war && \
  update-rc.d webanno defaults && \
  mkdir /srv/webanno
COPY settings.properties /srv/webanno/
RUN chown -R www-data:www-data /srv/webanno

# customize entry point
WORKDIR /usr/local/bin
RUN head -n-1 docker-entrypoint.sh >tmp && \
  mv tmp docker-entrypoint.sh && \
  chmod 775 docker-entrypoint.sh && \
  echo 'service webanno start' >>docker-entrypoint.sh && \
  echo 'service mysql start' >>docker-entrypoint.sh && \
  echo 'exec "$@"' >>docker-entrypoint.sh
WORKDIR /

ENTRYPOINT ["docker-entrypoint.sh"]
# webanno tomcat port
EXPOSE 18080
CMD ["bash"]
