-- call admin_resources.sp_clone_table("current_db", "current_table", "new_db", "new_table");

DROP PROCEDURE IF EXISTS sp_clone_table;

delimiter $$

CREATE PROCEDURE sp_clone_table(
  db_cur VARCHAR(255),
  t_cur VARCHAR(255),
  db_new VARCHAR(255),
  t_new VARCHAR(255)
)
proc_label:BEGIN  
  SET @db_cur := db_cur;
  SET @t_cur := t_cur;
  SET @db_new := db_new;
  SET @t_new := t_new;
  -- Check if the target table to clone is too big
  SET @query = concat("SELECT table_rows 
    FROM information_schema.TABLES 
    WHERE TABLE_TYPE='BASE TABLE' 
    AND table_schema = '",dbname,"' 
    AND table_name = '",tname,"' 
    into @row_count"
  );
  PREPARE stmt FROM @query;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;
  
  IF (@row_count > 100000) then		
    SELECT "The table contains too many rows. Clonation aborted" as 'OUTPUT MESSAGE';
    LEAVE proc_label;	
  END IF;
  -- If it's smaller than 100k rows then clone the structure
  SET @query = concat("CREATE TABLE ", @db_cur, ".", @t_cur, " LIKE ", @db_new, "." , @t_new);
  PREPARE stmt FROM @query;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;
  -- and finally copy the data
  SET @query = concat("INSERT INTO ", @db_cur, ".", @t_cur, " SELECT * FROM ", @db_new, "." , @t_new);
  PREPARE stmt FROM @query;
  EXECUTE stmt;
  DEALLOCATE PREPARE stmt;
END $$

delimiter ;