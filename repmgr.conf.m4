cluster=__CLUSTER_NAME__
node=__NODE_NUM__
node_name=__NODE_NAME__
priority=__NODE_PRIORITY__
conninfo='host=__NODE_NAME__ dbname=repmgr user=repmgr'
use_replication_slots=0

# autofailover options
failover=automatic
promote_command='/apps/__SERVICE__/scripts/pg-promote'
follow_command='/apps/__SERVICE__/scripts/pg-follow'
pg_bindir=/usr/lib/postgresql/9.3/bin/
logfile='/apps/__SERVICE__/logs/repmgr-prod.log'
loglevel=DEBUG

## connection options
rsync_options=-aHAXxv --numeric-ids --archive --inplace --no-whole-file --progress --rsh="ssh -T -o \"StrictHostKeyChecking no\" -x"
ssh_options= -T -o "StrictHostKeyChecking no" -x

reconnect_attempts=2
reconnect_interval=1
