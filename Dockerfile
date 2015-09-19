FROM debian:stable
MAINTAINER Andreas Krüger
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq
RUN apt-get install --no-install-recommends --no-install-suggests -yqq git gcc flex bison libmysqlclient-dev make libssl-dev libcurl4-openssl-dev libxml2-dev libpcre3-dev


# Clone the source
RUN mkdir -p /usr/src/
WORKDIR /usr/src/
RUN git clone --depth 1 --no-single-branch git://git.kamailio.org/kamailio kamailio

WORKDIR /usr/src/kamailio
RUN git checkout -b 4.3 origin/4.3

ENV REAL_PATH /usr/local/kamailio

# Get ready for a build.
RUN make PREFIX=$REAL_PATH FLAVOUR=kamailio cfg
RUN make all && make install
RUN mv $REAL_PATH/etc/kamailio/kamailio.cfg $REAL_PATH/etc/kamailio/kamailio.cfg.old
RUN cp modules/sipcapture/examples/kamailio.cfg $REAL_PATH/etc/kamailio/kamailio.cfg

WORKDIR /

# -------------------- Kamailio configs

RUN echo "local0.*                        -/var/log/kamailio.log" >> /etc/rsyslog.conf

COPY run.sh /run.sh
COPY dispatcher_watch.sh /
COPY kamailio.cfg /etc/kamailio/kamailio.cfg
COPY dispatcher.list /etc/kamailio/dispatcher.list

CMD /run.sh
