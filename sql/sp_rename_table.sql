-- call admin_resources.sp_rename_table("current_db", "current_table", "new_db", "new_table");

delimiter $$

DROP PROCEDURE IF EXISTS sp_rename_table $$

CREATE PROCEDURE sp_rename_table(
  db_cur VARCHAR(255),
  t_cur VARCHAR(255),
  db_new VARCHAR(255),
  t_new VARCHAR(255)
)
BEGIN
   SET @db_cur := db_cur;
   SET @t_cur := t_cur;
   SET @db_new := db_new;
   SET @t_new := t_new;
   SET @query = concat("RENAME TABLE ", @db_cur, ".", @t_cur, " TO ", @db_new, "." , @t_new);

   PREPARE stmt FROM @query;
   EXECUTE stmt;
   DEALLOCATE PREPARE stmt;
END $$

delimiter ;