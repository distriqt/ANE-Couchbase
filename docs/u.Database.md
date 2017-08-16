
## Database

The `Database` object allows access to the documents contained within the database.

### Imports

```as3
import com.distriqt.extension.couchbase.Database;
import com.distriqt.extension.couchbase.DatabaseOptions;
import com.distriqt.extension.couchbase.Document;
import com.distriqt.extension.couchbase.events.CouchbaseDatabaseEvent;
```

## Documents

Couchbase Mobile stores data in documents rather than in table rows.
A document is a JSON object containing a number of key-value pairs.

The document ID is the primary identifier of a document in the database. It is unique in 
the system and does not change throughout the lifecycle of a document (CRUD operations).



### Create a Document

To create a new document use the `createDocument()` function.

```as3
var document:Document = database.createDocument();
```

If this call succeeds, a valid (non-null) document will be returned and you 
can use this document object to set properties into the database. 

The new document's ID can be accessed through the `documentID` property:

```as3
document.documentID;
```


### Retrieve a Document

If you know the document id use the `getExistingDocument()` function to retrieve the document reference.


```as3
var document:Document = database.getExistingDocument( "document-id" );
```


### Set Properties

Once you have a `Document` reference you can set properties on the document and save them 
into the database.


```as3
document.properties.testNum = 10;
document.properties.testBool = true;
```

In order to save these properties you need to call `commit()` on the document:

```as3
document.commit();
```


### Delete a Document

At some point if you require to delete a document you can call `deleteDocument()` on the 
database reference using the id of the document you wish to delete

```as3
var success:Boolean = database.deleteDocument( "document-id" );
```

The return value indicates if the deletion was successful. 



### Get All Documents

The `getAllDocuments()` method performs a query on the database to retrieve a list of all 
the available document IDs.


```as3
database.addEventListener( CouchbaseDatabaseEvent.GETALLDOCUMENTS_COMPLETE, getAllDocuments_completeHandler );
database.addEventListener( CouchbaseDatabaseEvent.GETALLDOCUMENTS_ERROR, getAllDocuments_errorHandler );
database.getAllDocuments();
		
    
function getAllDocuments_completeHandler( event:CouchbaseDatabaseEvent ):void
{
    for each (var documentId:String in event.documentIds)
    {
        trace( "Document ID = " + documentId );
    }
}
		
function getAllDocuments_errorHandler( event:CouchbaseDatabaseEvent ):void
{
    trace( "ERROR: " + event.error );
}
```

