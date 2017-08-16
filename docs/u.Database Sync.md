
## Database Synchronisation



### Imports

```as3
import com.distriqt.extension.couchbase.Database;
import com.distriqt.extension.couchbase.events.CouchbaseReplicationEvent;
```



### Start Sync

To synchronise the database simply call `sync` on the database and pass in the url
of the remote couchbase sync gateway. 

This will start continuous pull and push replication processes to the specified remote server
and you will receive events when the replication state changes.

```as3
database.addEventListener( CouchbaseReplicationEvent.CHANGE, replicationChangeHandler );
database.sync( remoteUrl );
		
function replicationChangeHandler( event:CouchbaseReplicationEvent ):void
{
    trace( "replicationChange: " + event.replication.status );
}
```




