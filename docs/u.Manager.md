
## Manager

The manager or core functionality allows you to list, create, and retrieve database 
references.

### Imports

```as3
import com.distriqt.extension.couchbase.Couchbase;
import com.distriqt.extension.couchbase.Database;
import com.distriqt.extension.couchbase.DatabaseOptions;
```


### List Databases

To list the currently available databases call the `getAllDatabaseNames()` method:

```as3
var databases:Array = Couchbase.service.getAllDatabaseNames();
```

This returns an array of `String`s, each representing the name of an exsiting database



### Get a Database

To get a reference to a database use the `getDatabase()` method and pass the name 
of the database you wish to retrieve.

```as3
var database:Database = Couchbase.service.getDatabase( "database-name" );
```

You can also specify some options to this call to specify retrieval / creation options 
such as whether the database will be created if it doesn't exist or if the database 
should be opened as read only. 

The defaults will create an unknown database and open for writing.

For example, to open a database as read only:

```as3
var options:DatabaseOptions = new DatabaseOptions();
options.readOnly = true;

var database:Database = Couchbase.service.getDatabase( "database-name", options );
```









