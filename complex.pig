RUN src/main/pig/common/common.pig

media_imp = load '$path_media_imp' using com.twitter.elephantbird.pig.store.LzoPigStorage(' ') as
(
   mid    : chararray,
   ts     : long,
   city   : chararray,
   os     : int,
   browser: int,
   type   : chararray,
   ip     : chararray,
   uid    : chararray,
   tags   : chararray
);

media_clk = load '$path_media_clk' using com.twitter.elephantbird.pig.store.LzoPigStorage(' ') as
(
   mid    : chararray,
   ts     : long,
   city   : chararray,
   os     : int,
   browser: int,
   type   : chararray,
   ip     : chararray,
   uid    : chararray,
   tags   : chararray
);

media_cm_tag = union media_imp, media_clk;

media_filter = FILTER media_cm_tag BY SIZE(tags)==13;
media_group = group media_filter by (mid,tags);
media_stat = FOREACH media_group
{
   uid_distict = distinct media_filter.uid;
   click_filter = filter media_filter by type=='1';
   generate
      group.mid                    as    mid   : chararray,
      COUNT(media_filter)          as    pv    : biginteger,
      COUNT(uid_distict)           as    uv    : biginteger,
      COUNT(click_filter)          as    click : biginteger,
      group.tags                   as    tags  : chararray,
      MAX(media_filter.ts)/24      as    day   : biginteger;
};
