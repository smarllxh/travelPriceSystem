#!/bin/bash
basepath=$(cd `dirname $0`;pwd)
db0=`sed -n '/dbpath/p' $basepath/"configs_rs0"/"rs0_0.conf"`
db0=${db0##*dbpath=}
logpath0=`sed -n /logpath/p $basepath/"configs_rs0/rs0_0.conf"`
logpath0=${logpath0##*logpath=}
port0=`sed -n '/port/p' $basepath/"configs_rs0"/"rs0_0.conf"`
port0=${port0##port=}

db1=`sed -n '/dbpath/p' $basepath/"configs_rs0"/"rs0_1.conf"`
db1=${db1##*dbpath=}
logpath1=`sed -n /logpath/p $basepath/"configs_rs0/rs0_1.conf"`
logpath1=${logpath1##*logpath=}
port1=`sed -n '/port/p' $basepath/"configs_rs0"/"rs0_1.conf"`
port1=${port1##port=}


db2=`sed -n '/dbpath/p' $basepath/"configs_rs0"/"rs0_2.conf"`
db2=${db2##*dbpath=}
logpath2=`sed -n /logpath/p $basepath/"configs_rs0/rs0_2.conf"`
logpath2=${logpath2##*logpath=}
port2=`sed -n '/port/p' $basepath/"configs_rs0"/"rs0_2.conf"`
port2=${port2##port=}

db3=`sed -n '/dbpath/p' $basepath/"configs_rs1/rs1_0.conf"`
db3=${db3##dbpath=}
logpath3=`sed -n /logpath/p $basepath/"configs_rs1/rs1_0.conf"`
logpath3=${logpath3##*logpath=}
port3=`sed -n '/port/p' $basepath/"configs_rs1/rs1_0.conf"`
port3=${port3##port=}

db4=`sed -n '/dbpath/p' $basepath/"configs_rs1/rs1_1.conf"`
db4=${db4##dbpath=}
logpath4=`sed -n /logpath/p $basepath/"configs_rs1/rs1_1.conf"`
logpath4=${logpath4##*logpath=}
port4=`sed -n '/port/p' $basepath/"configs_rs1/rs1_1.conf"`
port4=${port4##port=}


db5=`sed -n '/dbpath/p' $basepath/"configs_rs1/rs1_2.conf"`
db5=${db5##dbpath=}
logpath5=`sed -n /logpath/p $basepath/"configs_rs1/rs1_2.conf"`
logpath5=${logpath5##*logpath=}
echo #$logpath5
port5=`sed -n '/port/p' $basepath/"configs_rs1/rs1_2.conf"`
port5=${port5##port=}

# get the mongos server port and the position of log
mongos_log=`sed -n '/logpath/p' $basepath/"mongos/cfg_mongos.conf"`
mongos_log=${mongos_log##logpath=}
mongos_log=${mongos_log%%mongos.log}
mongos_port=`sed -n '/port/p' $basepath/"mongos/cfg_mongos.conf"`
mongos_port=${mongos_port##port=}

if ! [ -e $mongos_log ]
then
    mkdir -p $mongos_log
    touch $mongos_log/"mongos.log"
fi

if ! [ -e $mongos_log ]
then
    touch $mongos_log
fi
if ! [ -e $db0 ]
then 
    mkdir -p $db0
fi
if ! [ -e $db1 ]
then
    mkdir -p $db1
fi
if ! [ -e $db2 ]
then
    mkdir -p $db2
fi
if ! [ -e $db3 ]
then
    mkdir -p $db3
fi
if ! [ -e $db4 ]
then 
    mkdir -p $db4
fi
if ! [ -e $db5 ]
then
    mkdir -p $db5
fi
if ! [ -e $logpath0 ]
then 
    touch $logpath0
fi
if ! [ -e $logpath1 ]
then 
    touch $logpath1
fi

if ! [ -e $logpath2 ]
then 
    touch $logpath2
fi
if ! [ -e $logpath3 ]
then 
    touch $logpath3
fi
if ! [ -e $logpath4 ]
then 
    touch $logpath4
fi
if ! [ -e $logpath5 ]
then 
    touch $logpath5
fi

#start th3 3 servers of rset0

mongod --config $basepath/"configs_rs0"/"rs0_0.conf" &
sleep 5
mongod --config $basepath/"configs_rs0"/"rs0_1.conf" &
sleep 5
mongod --config $basepath/"configs_rs0"/"rs0_2.conf" &
sleep 5
#start the 3 servres of rset1


mongod --config $basepath/"configs_rs1"/"rs1_0.conf" &
sleep 10
mongod --config $basepath/"configs_rs1"/"rs1_1.conf" &
sleep 10
mongod --config $basepath/"configs_rs1"/"rs1_2.conf" &
sleep 10

# config the rset 
#mongo "localhost:$port0" --shell "$basepath/addrset0.js"
mongo "localhost:$port0" --eval "rs.initiate()"  
sleep 15
mongo "localhost:$port0" --eval "rs.add('lenovo:$port1')"
sleep 15
mongo "localhost:$port0" --eval "rs.addArb('lenovo:$port2')"
sleep 15
#mongo  "localhost:$port3" --shell "$basepath/addrset1.js"

mongo "localhost:$port3" --eval "rs.initiate()"  
sleep 15

mongo "localhost:$port3" --eval "rs.add('lenovo:$port4')"
sleep 15
mongo "localhost:$port3" --eval "rs.addArb('lenovo:$port5')"

sleep 15

#

#start the configservers (the number must be 1 or 3)

config_db0=`sed -n '/dbpath/p' $basepath/"configs_cfgservers"/"cfgserver_0.conf"`
config_db0=${config_db0##*dbpath=}
config_logpath0=`sed -n /logpath/p $basepath/"configs_cfgservers/cfgserver_0.conf"`
config_logpath0=${logpath0##*logpath=}
config_port0=`sed -n '/port/p' $basepath/"configs_cfgservers/cfgserver_0.conf"`
config_port0=${config_port0##port=}

if ! [ -e $config_db0 ]
then 
    mkdir -p $config_db0
fi
if ! [ -e $config_logpath0 ]
then 
    touch $config_logpath0
fi


config_db1=`sed -n '/dbpath/p' $basepath/"configs_cfgservers"/"cfgserver_1.conf"`
config_db1=${config_db1##*dbpath=}
config_logpath1=`sed -n /logpath/p $basepath/"configs_cfgservers/cfgserver_1.conf"`
config_logpath1=${config_logpath1##*logpath=}
config_port1=`sed -n '/port/p' $basepath/"configs_cfgservers/cfgserver_1.conf"`
config_port1=${config_port1##port=}

if ! [ -e $config_db1 ]
then 
    mkdir -p $config_db1
fi
if ! [ -e $config_logpath1 ]
then 
    touch $config_logpath1
fi


config_db2=`sed -n '/dbpath/p' $basepath/"configs_cfgservers"/"cfgserver_2.conf"`
config_db2=${config_db2##*dbpath=}
config_logpath2=`sed -n /logpath/p $basepath/"configs_cfgservers/cfgserver_2.conf"`
config_logpath2=${config_logpath2##*logpath=}
config_port2=`sed -n '/port/p' $basepath/"configs_cfgservers/cfgserver_2.conf"`
config_port2=${config_port2##port=}

if ! [ -e $config_db2 ]
then 
    mkdir -p $config_db2
fi
if ! [ -e $config_logpath2 ]
then 
    touch $config_logpath2
fi

#start the 3 servers of configer

mongod --config $basepath/"configs_cfgservers"/"cfgserver_0.conf" &
sleep 15
mongod --config $basepath/"configs_cfgservers"/"cfgserver_1.conf" &
sleep 15
mongod --config $basepath/"configs_cfgservers"/"cfgserver_2.conf" &
sleep 15

#start the mongos server
mongos --config $basepath/"mongos/cfg_mongos.conf" &
sleep 15
##
##config the shard 
#mongo "localhost:$mongos_port" --shell "$basepath/addshard.js"
mongo "localhost:$mongos_port" --eval "sh.addShard('rs3/lenovo:$port0,lenovo:$port1')"
sleep 10
mongo "localhost:$mongos_port" --eval "sh.addShard('rs4/lenovo:$port3,lenovo:$port4')"
python `dirname $basepath`/init_shard_mongodb.py

mongo "localhost:$mongos_port" --eval "sh.enableSharding('Travel')"

mongo "localhost:$mongos_port" --eval "sh.shardCollection('Travel.Data',{'destination':1,'_id':1})";
