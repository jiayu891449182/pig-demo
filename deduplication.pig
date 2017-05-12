set default_parallel 50;
set mapred.child.java.opts -Xmx4048m;
set mapred.compress.map.output true;
set mapred.map.output.compression.codec com.hadoop.compression.lzo.LzopCodec;
set pig.cachedbag.memusage 0.15;
set io.sort.factor 100;
set opt.multiquery false;

register /root/lib/log4j-1.2.17.jar;
register /root/lib/elephant-bird-core-4.13.jar;
register /root/lib/elephant-bird-pig-4.13.jar;
register /root/lib/elephant-bird-hadoop-compat-4.13.jar;

data = LOAD '$input' USING com.twitter.elephantbird.pig.store.LzoPigStorage(',');
data_grp = GROUP data BY $0;
data_dis = FOREACH data_grp {
order_data = ORDER data by $7 DESC;
limit_data = LIMIT order_data 1;
GENERATE FLATTEN(limit_data);
};
STORE data_dis into '$output' USING com.twitter.elephantbird.pig.store.LzoPigStorage(',');
