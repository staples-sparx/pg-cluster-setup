#!/bin/sh

ENV=__ENV__
HOST=__HOST__
SERVICE=__SERVICE__
DB_CONF_DIR=__DB_CONF_DIR__

CLUSTER=${DB_CONF_DIR}/cluster.info
NODES=${DB_CONF_DIR}/nodes.info.${ENV}

print_error() {
    printf "\n\033[31m   *** ERROR *** $1 \033[0m\n\n"
}

node_info() {
    cat ${NODES} | grep ${HOST} | cut -d ' ' -f ${1}
}

cluster_info() {
    cat ${CLUSTER} | grep ${1} | cut -d ' ' -f 2
}

SHARED=../../shared
PG_CLUSTER_DIR=../../shared/pg-cluster
CLUSTER_NAME=${ENV}
NODE_NAME=${HOST}
SERVICE=${SERVICE}

NODE_MODE=$(node_info 3)
NODE_NUM=$(node_info 4)
NODE_PRIORITY=$(node_info 5)
ZFS_RECORD_SIZE=$(node_info 8)
ZFS_PRIMARY_CACHE=$(node_info 9)

DB_PARENT_DIR=$(cluster_info db-parent-dir)
DB_DIR_NAME=$(cluster_info db-dir-name)
DB_DIR=${DB_PARENT_DIR}/${DB_DIR_NAME}
DB_NAME=$(cluster_info db-name)
DB_SERVICE_NAME=$(cluster_info db-service-name)
DB_CREATION_SCRIPT=$(cluster_info db-creation-script)
DB_MIGRATION_SCRIPT=$(cluster_info db-migration-script)

POSTGRESQL_CONF_PATH=${DB_DIR}/postgresql.conf
