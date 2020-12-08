#!/bin/bash

cat >> /etc/postgresql/10/main/postgresql.conf <<EOF
listen_addresses='*'
wal_level = replica
max_wal_senders = 5
wal_keep_segments = 32
EOF
cat >> /etc/postgresql/10/main/pg_hba.conf <<EOF
host $PG_DB  $PG_USER    samenet  md5
host replication  rep    samenet  md5
EOF
/usr/lib/postgresql/10/bin/postgres -D /var/lib/postgresql/10/main -c config_file=/etc/postgresql/10/main/postgresql.conf
while true; do
	pg_isready < /dev/null
	if [ $? -eq 0 ]; then
		break
	fi
	echo "Postgres is unavailable - sleeping..."
	sleep 3
done
psql --command "CREATE USER $PG_USER WITH SUPERUSER PASSWORD '$PG_PW';"
createdb -O $PG_USER $PG_DB 
psql --command "CREATE ROLE rep WITH LOGIN PASSWORD '$REPL_PW' REPLICATION;"
