FROM centos:6.7

MAINTAINER Bryan Hunt "admin@binarytemple.co.uk"

RUN yum -y update

ENV JAVA_VERSION 1.8.0

ENV FUSEKI_VERSION apache-jena-fuseki-2.3.1

RUN yum -y update && yum install -y java-"${JAVA_VERSION}"-openjdk-devel unzip which && yum clean all

RUN mkdir -p /opt/fuseki

RUN mkdir /opt/fuseki/config

ADD md5sums.txt /opt/md5sums.txt

ENV FUZEKI_ZIP_DEST /opt/"${FUSEKI_VERSION}".zip 

ADD http://mirrors.muzzy.org.uk/apache/jena/binaries/"${FUSEKI_VERSION}".zip $FUZEKI_ZIP_DEST

RUN md5sum -c /opt/md5sums.txt

RUN unzip $FUZEKI_ZIP_DEST -d /opt/fuseki

RUN rm $FUZEKI_ZIP_DEST 

ADD config.ttl /opt/fuseki/config/config.ttl

ADD run-fuseki /opt/fuseki/

RUN sed -i -e "s/<FUSEKI_VERSION>/$FUSEKI_VERSION/g" /opt/fuseki/run-fuseki

RUN chmod +x /opt/fuseki/run-fuseki
 
RUN mkdir /data
 
VOLUME ["/data", "/opt/fuseki/config"]
 
EXPOSE 3030

CMD ["/opt/fuseki/run-fuseki"]
