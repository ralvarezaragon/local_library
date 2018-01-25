invoke the shell
```bash
hdfs dfs <arg>
```
List the current directory
```bash
hdfs dfs -ls .
```
Copy from local to hdfs
```bash
hdfs dfs -cp file:///localdir/myfile.txt hdfs://myhadoop.com:8020/remotedir/myfile.txt
```
copyFromLocal / put -> Copy files from local to hdfs
copyToLocal / get -> COpy from hdfs to local
getMerge -> Gets all files in dir using search pattern
setRep -> Set replication factor for a file
Verifying cluster health
```bash
hdfs dfsadmin -report
```