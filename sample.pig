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

sample_media_imp = sample media_imp $sample_rate;

