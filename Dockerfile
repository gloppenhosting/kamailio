FROM debian:stable
MAINTAINER Andreas Krüger
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -qq
RUN apt-get install --no-install-recommends --no-install-suggests -yqq git gcc flex bison libmysqlclient-dev make libssl-dev libcurl4-openssl-dev libxml2-dev libpcre3-dev rsyslog inotify-tools


# Clone the source
RUN mkdir -p /usr/src/
WORKDIR /usr/src/
RUN git clone --depth 1 --no-single-branch git://git.kamailio.org/kamailio kamailio

WORKDIR /usr/src/kamailio
RUN git checkout -b 4.3 origin/4.3
# Get ready for a build.
# include_modules="db_mysql mi_fifo kex tm tmx sl rr pv maxfwd textops siputils xlog bind_ob sanity ctl mi_rpc acc dispatcher sipcapture"
RUN make cfg
RUN make all && make install
RUN mv /usr/local/etc/kamailio/kamailio.cfg /usr/local/etc/kamailio/kamailio.cfg.old
#RUN cp modules/sipcapture/examples/kamailio.cfg $REAL_PATH/etc/kamailio/kamailio.cfg

WORKDIR /

# -------------------- Kamailio configs

RUN echo "local0.*                        -/var/log/kamailio.log" >> /etc/rsyslog.conf

COPY run.sh /run.sh
COPY dispatcher_watch.sh /
COPY kamailio.cfg /usr/local/etc/kamailio/kamailio.cfg
COPY dispatcher.list /etc/kamailio/dispatcher.list

CMD /run.sh
