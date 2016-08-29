#  PostgreSQL Cluster     -*- makefile -*-
#

ifndef ENV
  $(error "You must set the ENV variable")
endif
ifndef HOST
  $(error "You must set the HOST variable")
endif
ifndef SERVICE
  $(error "You must set the SERVICE variable")
endif

SHARED := ./shared
DB_CONF_DIR := ./sample-service-config
PG_VERSION ?= 9.3.14
PG_SHORT_VERSION ?= 9.3
REPMGR_VERSION := 3.1.5-1.pgdg14.04+1
PG_CLUSTER_DIR=${SHARED}/pg-cluster
REPMGR_TO_ZK_VERSION := "0.1.0"
include ${SHARED}/postgresql/Makefile

#################################################################
# Config

pg-cluster: env \
	    postgresql \
	    disable-default-postgres \
	    cluster-check \
            repmgr \
	    zfs-filesystem \
	    hosts \
	    failover-scripts \
	    postgresql-conf \
	    setup-node-for-mode \
	    repmgr-to-zk

disable-default-postgres:
	sudo service postgresql stop
	sudo bash -c "echo disabled > /etc/postgresql/9.3/main/start.conf"

env:
	${SHARED}/m4-conf update shared/pg-cluster/env ${SHARED}/pg-cluster/env \
	  	-D__ENV__=${ENV} \
	  	-D__HOST__=${HOST} \
	  	-D__SERVICE__=${SERVICE} \
	  	-D__DB_CONF_DIR__=${DB_CONF_DIR}

cluster-check:
	${PG_CLUSTER_DIR}/cluster-config-check

hosts:
	${PG_CLUSTER_DIR}/setup-hosts

zfs-filesystem:
	${PG_CLUSTER_DIR}/setup-zfs

failover-scripts:
	${PG_CLUSTER_DIR}/setup-failover-scripts

repmgr:
	${PG_CLUSTER_DIR}/setup-repmgr ${PG_SHORT_VERSION} ${REPMGR_VERSION}

postgresql-conf:
	${PG_CLUSTER_DIR}/setup-postgresql-conf

setup-node-for-mode:
	${PG_CLUSTER_DIR}/setup-node

repmgr-to-zk:
	${PG_CLUSTER_DIR}/setup-repmgr-to-zk ${REPMGR_TO_ZK_VERSION}

#################################################################
# Config check

pg-cluster-check: env \
		  fs-check \
                  postgresql-check \
                  disabled-default-postgresql-check \
		  cluster-check \
		  nodes-info-check \
		  postgresql-conf-check \
	          repmgr-check \
		  node-check-for-mode

repmgr-check:
	${SHARED}/chk-file /usr/lib/postgresql/9.3/bin/repmgr
	${SHARED}/chk-file /usr/bin/repmgr
	${SHARED}/chk-file /usr/bin/repmgrd
	${SHARED}/chk-file /etc/default/repmgrd

fs-check:
	${SHARED}/chk-dir /apps/${SERVICE}/api-db
	sudo -u deploy-user ${SHARED}/chk-dir /apps/${SERVICE}/api-db/pg_xlog
	sudo -u deploy-user ${SHARED}/chk-file /apps/${SERVICE}/api-db/PG_VERSION

disabled-default-postgresql-check:
	sudo service postgresql stop || true

nodes-info-check:
	${PG_CLUSTER_DIR}/nodes-info-check

postgresql-conf-check:
	${PG_CLUSTER_DIR}/postgresql-conf-check

node-check-for-mode:
	${PG_CLUSTER_DIR}/node-check
