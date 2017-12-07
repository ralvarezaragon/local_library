from couchbase.bucket import Bucket

bucket = Bucket('couchbase://10.0.2.149/test01')
print "connected"
Bucket._close()
