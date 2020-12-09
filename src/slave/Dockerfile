FROM ubuntu:16.04
RUN apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get update && apt-get install -y inetutils-ping python-software-properties software-properties-common postgresql-10 postgresql-client-10 postgresql-contrib-10
COPY ./setup-slave.sh /setup-slave.sh
RUN chmod 555 /setup-slave.sh
USER postgres
ENTRYPOINT ["/setup-slave.sh"]
CMD ["/usr/lib/postgresql/10/bin/postgres", "-D", "/var/lib/postgresql/10/main", "-c", "config_file=/etc/postgresql/10/main/postgresql.conf"]
