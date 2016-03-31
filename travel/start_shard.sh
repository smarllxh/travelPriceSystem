#!bin/bash
basepath=$(cd `dirname $0`;pwd)
mongod --config $basepath/"configs_rs0"/"rs0_0.conf"
mongod --config $basepath/"configs_rs0"/"rs0_1.conf"
mongod --config $basepath/"configs_rs0"/"rs0_2.conf"

mongod --config $basepath/"configs_rs1"/"rs1_0.conf"
mongod --config $basepath/"configs_rs1"/"rs1_1.conf"
mongod --config $basepath/"configs_rs1"/"rs1_2.conf"

mongod --config $basepath/"configs_cfgservers"/"cfgserver_0.conf"
mongod --config $basepath/"configs_cfgservers"/"cfgserver_1.conf"
mongod --config $basepath/"configs_cfgservers"/"cfgserver_2.conf"


mongos --config $basepath/"mongos/cfg_mongos.conf"
