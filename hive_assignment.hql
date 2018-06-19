SET hive.map.aggr=true;
SET hive.exec.mode.local.auto=true;
set hive.mapred.mode =strict;
set hive.exec.dynamic.partition.mode=nonstrict;
set hive.exec.dynamic.partition=true;
Create external table if not exists windows_log_update(
log_date string,
log_time string,
event_id string,
log_id string,
source string,
message string
)
row format delimited
fields terminated by '\t'
;
Load Data local Inpath '/home/training/hive/WindowsUpdate.log' Into TABLE windows_log_update;  
select count(distinct event_id) from windows_log_update;
select source, count(*) as num_events from windows_log_update group by source;                                                                               
select substring(log_date,1,10) as log_date_without_timestamp, count(*) as num_events from windows_log_update group by substring(log_date,1,10);
select count(*) from windows_log_update where source = 'DnldMgr'; 
select count(*) from windows_log_update where message like concat('%', 'Download', '%') and message like concat('%', 'succeeded', '%');
select log_date, log_time from windows_log_update where message like concat('%', 'Download', '%') and message like concat('%', 'succeeded', '%') and  substring(log_date,1,10) = '2014-03-11';
select log_date, count(*) as download_succeed from windows_log_update where message like concat('%', 'Download', '%') and message like concat('%', 'succeeded', '%') group by log_date order by download_succeed  desc limit 1;


