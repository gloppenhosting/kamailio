#FROM centos:centos6
#MAINTAINER Doug Smith <info@laboratoryb.org>
#ENV build_date 2014-12-05 001

# -------------------- Yum installs
#RUN yum update -y
#RUN yum install -y epel-release
#RUN yum install -y nano wget inotify-tools rsyslog
#RUN wget -O /etc/yum.repos.d/kamailio.repo http://download.opensuse.org/repositories/home:/kamailio:/telephony/CentOS_CentOS-6/home:kamailio:telephony.repo
#RUN yum install -y kamailio

FROM debian:stable
MAINTAINER Andreas Krüger
ENV DEBIAN_FRONTEND noninteractive


RUN apt-key adv --recv-keys --keyserver keyserver.ubuntu.com 0xfb40d3e6508ea4c8
RUN echo "deb http://deb.kamailio.org/kamailio jessie main" >> /etc/apt/sources.list
RUN echo "deb-src http://deb.kamailio.org/kamailio jessie main" >> /etc/apt/sources.list
RUN apt-get update -qq
RUN apt-get install --no-install-recommends --no-install-suggests -yqq nano wget inotify-tools rsyslog kamailio

# -------------------- Kamailio configs

RUN echo "local0.*                        -/var/log/kamailio.log" >> /etc/rsyslog.conf

COPY run.sh /run.sh
COPY dispatcher_watch.sh /
COPY kamailio.cfg /etc/kamailio/kamailio.cfg
COPY dispatcher.list /etc/kamailio/dispatcher.list

CMD /run.sh
