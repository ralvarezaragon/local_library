mysqldump --single-transaction --quick --lock-tables=false esme_mesh_tracking virtual_msisdn_go4m > /tmp/virtual_msisdn_go4m.sql
scp -r -i /remote/.ssh/id_rsa /tmp/virtual_msisdn_go4m.sql sshsync@frank2.basebone.com:/tmp/
mysql -e "rename esme_mesh_tracking.virtual_msisdn_go4m to esme_mesh_tracking.virtual_msisdn_go4m_old"

mysql esme_mesh_tracking < /tmp/virtual_msisdn_go4m.sql
---------------------------------------------------------------------------------------------------------------------------------
mysqldump --single-transaction --quick --lock-tables=false esme_mesh_tracking virtual_msisdn_hcnx > /tmp/virtual_msisdn_hcnx.sql
scp -r -i /remote/.ssh/id_rsa /tmp/virtual_msisdn_hcnx.sql sshsync@frank2.basebone.com:/tmp/
mysql -e "rename esme_mesh_tracking.virtual_msisdn_hcnx to esme_mesh_tracking.virtual_msisdn_hcnx_old"

mysql esme_mesh_tracking < /tmp/virtual_msisdn_hcnx.sql
---------------------------------------------------------------------------------------------------------------------------------
mysqldump --single-transaction --quick --lock-tables=false esme_mesh_tracking mesh_portugal > /tmp/mesh_portugal.sql
scp -r -i /remote/.ssh/id_rsa /tmp/mesh_portugal.sql sshsync@frank2.basebone.com:/tmp/
mysql -e "rename esme_mesh_tracking.mesh_portugal to esme_mesh_tracking.mesh_portugal_old"

mysql esme_mesh_tracking < /tmp/mesh_portugal.sql
---------------------------------------------------------------------------------------------------------------------------------
mysqldump --single-transaction --quick --lock-tables=false esme_mesh_tracking mesh_france > /tmp/mesh_france.sql
scp -r -i /remote/.ssh/id_rsa /tmp/mesh_france.sql sshsync@frank2.basebone.com:/tmp/
mysql -e "rename esme_mesh_tracking.mesh_france to esme_mesh_tracking.mesh_france_old"

mysql esme_mesh_tracking < /tmp/mesh_france.sql
-------------------------------- ESME_MESSGING ------------------------------
---------------------------------------------------------------------------------------------------------------------------------
mysqldump --single-transaction --quick --lock-tables=false esme_messaging message_ids > /tmp/message_ids.sql
scp -r -i /remote/.ssh/id_rsa /tmp/message_ids.sql sshsync@frank2.basebone.com:/tmp/
mysql -e "rename esme_messaging.message_ids to esme_messaging.message_ids_old"

mysql esme_messaging < /tmp/message_ids.sql
---------------------------------------------------------------------------------------------------------------------------------
mysqldump --single-transaction --quick --lock-tables=false esme_messaging mids_original > /tmp/mids_original.sql
scp -r -i /remote/.ssh/id_rsa /tmp/mids_original.sql sshsync@frank2.basebone.com:/tmp/
mysql -e "rename esme_messaging.mids_original to esme_messaging.mids_original_old"

mysql esme_messaging < /tmp/mids_original.sql








