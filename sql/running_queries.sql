select id, command, db, time_ms, state, info
from information_schema.processlist
where  command !='Sleep'
and info not like '%information_schema.processlist%'
and id = 2502591;
-- ----------------------------
-- select id, info, db, time_ms, state
-- from information_schema.processlist
-- where time_ms > 100;