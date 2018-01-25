Hbase: Hadoop database
Hive: ETL for hadoop
PIG: For mapReduce code


Two main components:
- HDFS file structure: 
    - Designed to manage very large files, the bigger the better because file seeking, the larger the files is the less time Haddop is seeking for the next data location.
    - Stored in blokc of 64Mb to default but recommended to 128
    - Blocks for single file are spread across multiple nodes in cluster
    - Fix size makes easy to calculate disk needed
    - Good for replication. It can be setup per node or even per file
- Mapreduce engine:
    - NameNode. The NameNode does not contain any data and manages the filesystem namespace 
    and metadata in memory (NameNode consumes large RAM memory). 
    A good idea for fault tolerance is mirroring the NameNode as it's a single point of failure 
    and don't use inexpensive commodity hardware.
    - The DataNodes store teh data and communicate the metadata (list of blocks) to the NameNode periodically. 
    These ones are majority in the cluster and can be used with cheap hardware
    - jobTracker. Manages the MapReduce jobs in cluster and there in only one per cluster.
    It schedules and monitor jobs requested by clients on teh TaskTrackers.
    - TaskTrackers. There are many of them in the cluster and thanks to them MapReduce achieve parallelism
- YARN and Hadoop 2.2:
    - Present in hadoop 2.2 
    - Refereed as MapReduce V2
    - DataNodes still exists but not TaskTrackers and JobTrackers
    - It manages resources and scheduler by itself out of MapReduce
    - In MapReduce VC1, the client was responsible to assign slots and resources based on the job and nodes. 
    with YARN this is no longer required as itself can negotiate that
    - Hadoop now comes with HA so 2 NameNodes, one active and one standby.
    - JournalNodes comes to scene. They have to odd (3 by default) and they decide when 
    the NameNode is lost and teh backup one has to come alive.
    - Now different nameNodes keeps federated metadata for teh given dataNodes allows
    to grow horizontally by adding more NameNodes 
    - Topology awareness. Thanks to this, Hadoop will always try to run the computation
    in the taskTracker node with highest bandwidth access to teh data.
    - HDFS replication:
        - To first rack (A) > to a random node in different rack (B) > to a random different node in the same rack (C)
        - For acknowledge last node send OK packet (C) > (B) > (A)  
 
