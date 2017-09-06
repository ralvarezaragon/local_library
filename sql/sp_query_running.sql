-- call admin_resources.sp_query_running(0, 0, "");
-- Parameters:
-- * sleep: define if sleeping connectiosn should be shown. 0 no, 1 yes
-- * running_time filter in time_ms column. Specify filer in ms
-- * obj_filer. Use it case you want to filter only by a given table or DB name. "" means no filter

DROP PROCEDURE IF EXISTS sp_query_running;

delimiter $$

CREATE PROCEDURE sp_query_running(
  sleep tinyint(1),
  running_time int(4),
  obj_filter varchar(50)
)
BEGIN  
   SET @main_query = "select id, command, db, time_ms, state, info
      from information_schema.processlist
      where 1=1";
      
      if (sleep = 0) then		
        set @sleep_clause := "and command !='Sleep'";
      else
        set @sleep_clause := "";
      end if;
      
      if (running_time > 0) then
		set @running_time_clause := concat("and time_ms >=", running_time);
      else
		set @running_time_clause := "";
	  end if;
      
      if (obj_filter != "") then
		set @obj_filter_clause := concat("and info like '%`", obj_filter, "`%'");
      else
		set @obj_filter_clause := "";
	  end if;
      
      set @ordering_clause = "order by 4 desc;";      
      set @query = concat(@main_query, " ", @sleep_clause, " ", @running_time_clause, " ", @obj_filter_clause, " ", @ordering_clause);
   PREPARE stmt FROM @query;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
END $$

delimiter ;