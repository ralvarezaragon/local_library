select id, command, db, time_ms, state, info
from information_schema.processlist
where  command !='Sleep'
and info not like '%information_schema.processlist%'

-- ----------------------------
-- select id, info, db, time_ms, state
-- from information_schema.processlists
-- where time_ms > 100;


