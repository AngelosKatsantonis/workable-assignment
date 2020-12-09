#!/bin/bash
if [ ! -e ~/configuration.done ]; then
	echo "*:*:*:rep:$REPL_PW" > ~/.pgpass
	chmod 0600 ~/.pgpass
	until ping -c 1 -W 1 master
	do
		echo "Waiting for master to ping..."
		sleep 1s
	done
	rm -rf /var/lib/postgresql/10/main/*
	until pg_basebackup -h master -D /var/lib/postgresql/10/main/ -U rep -vP
	do
		echo "Waiting for master to connect..."
		sleep 1s
	done
	cat > /var/lib/postgresql/10/main/recovery.conf <<EOF
	standby_mode = 'on'
	primary_conninfo = 'host=master port=5432 user=rep password=$REPL_PW'
	trigger_file = '/tmp/failover.trigger'
EOF
	cat >> /etc/postgresql/10/main/postgresql.conf <<EOF
	listen_addresses='*'
	wal_level = replica
	max_wal_senders = 5
	wal_keep_segments = 32
	hot_standby = on
EOF
	cat >> /etc/postgresql/10/main/pg_hba.conf <<EOF
	host $PG_DB  $PG_USER    samenet  md5
	host replication  rep    samenet  md5
EOF
	touch ~/configuration.done
fi
exec "$@"
