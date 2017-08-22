/**
 *        __       __               __ 
 *   ____/ /_ ____/ /______ _ ___  / /_
 *  / __  / / ___/ __/ ___/ / __ `/ __/
 * / /_/ / (__  ) / / /  / / /_/ / / 
 * \__,_/_/____/_/ /_/  /_/\__, /_/ 
 *                           / / 
 *                           \/ 
 * http://distriqt.com
 *
 * @brief  		
 * @author 		"Michael Archbold (ma&#64;distriqt.com)"
 * @created		21/07/2017
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package com.distriqt.test.couchbase
{
	import com.distriqt.extension.couchbase.Authenticator;
	import com.distriqt.extension.couchbase.Couchbase;
	import com.distriqt.extension.couchbase.Database;
	import com.distriqt.extension.couchbase.DatabaseOptions;
	import com.distriqt.extension.couchbase.Document;
	import com.distriqt.extension.couchbase.events.CouchbaseDatabaseEvent;
	import com.distriqt.extension.couchbase.events.CouchbaseReplicationEvent;
	import com.distriqt.test.ILogger;
	
	import flash.display.Bitmap;
	import flash.events.ErrorEvent;
	import flash.filesystem.File;
	import flash.utils.getQualifiedClassName;
	
	
	public class CouchbaseTests
	{
		public static const TAG : String = "CouchbaseTests";
		
		

		////////////////////////////////////////////////////////
		//	VARIABLES
		//
		
		private var _l : ILogger;
		
		private function log( message:String ):void 
		{
			_l.log( TAG, message );
		}
		

		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		public function CouchbaseTests( logger:ILogger )
		{
			super();
			_l = logger;
			try
			{
				log( "Couchbase.isSupported: " + Couchbase.isSupported );
				if (Couchbase.isSupported)
				{
					log( "Couchbase.version:     " + Couchbase.service.version );
					
					Couchbase.service.enableLogging( "Sync" );
					Couchbase.service.enableLogging( "SyncVerbose" );
					Couchbase.service.enableLogging( "Query" );
					
					Couchbase.service.addEventListener( ErrorEvent.ERROR, couchbase_errorHandler );
					Couchbase.service.setup();
					
				}
			}
			catch (e:Error)
			{
				trace( e );
			}
		}
		
		
		private function couchbase_errorHandler( event:ErrorEvent ):void
		{
			log( "ERROR::"+event.text );
		}
		
		
		
		//
		//	CREATE / RETRIEVE DATABASE
		//
		
		private var _database	: Database = null;
		
		public function listDatabases():void
		{
			log( "============ getAllDatabaseNames() ==================" );
			var databases:Array = Couchbase.service.getAllDatabaseNames();
			for (var i:int = 0; i < databases.length; ++i)
			{
				log( "db: " + databases[i] );
			}
			log( "=====================================================" );
		}
		
		public function getDatabase():void
		{
			log( "getDatabase()" );
			if (_database == null)
			{
				var options:DatabaseOptions = new DatabaseOptions();
//				options.storageType = DatabaseOptions.STORAGE_SQLITE;
				
				_database = Couchbase.service.getDatabase( "testdb", options );
			}
			if (_database != null)
			{
				printDatabaseDetails( _database );
			}
			else
			{
				log( "GET DATABASE FAILED!!" );
			}
		}
		
		
		public function compact():void
		{
			log( "compact()" );
			if (_database == null)
			{
				_database = Couchbase.service.getDatabase( "testdb" );
			}
			if (_database != null)
			{
				_database.compact();
			}
		}
		
		
		
		private function printDatabaseDetails( database:Database ):void
		{
			log( "============ database ===============================" );
			log( "databaseName       = " + database.databaseName );
			log( "documentCount      = " + database.documentCount );
			log( "lastSequenceNumber = " + database.lastSequenceNumber );
			log( "=====================================================" );
		}
		
		
		
		//
		//  DOCUMENTS
		//
		
		private var _documentId	: String;
		
		
		public function getAllDocuments():void
		{
			log( "getAllDocuments" );
			if (_database != null)
			{
				_database.addEventListener( CouchbaseDatabaseEvent.GETALLDOCUMENTS_COMPLETE, getAllDocuments_completeHandler );
				_database.addEventListener( CouchbaseDatabaseEvent.GETALLDOCUMENTS_ERROR, getAllDocuments_errorHandler );
				_database.getAllDocuments();
			}
		}
		
		private function getAllDocuments_completeHandler( event:CouchbaseDatabaseEvent ):void
		{
			log( "getAllDocuments_completeHandler: " + event.documentIds.length );
			if (event.documentIds.length > 0)
			{
				for each (var documentId:String in event.documentIds)
				{
					log( "getAllDocuments_completeHandler: ID = " + documentId );
				}
				
				_documentId = event.documentIds[0];
			}
		}
		
		private function getAllDocuments_errorHandler( event:CouchbaseDatabaseEvent ):void
		{
			log( "getAllDocuments_errorHandler: " + event.error );
		}
		
		
		
		public function createDocument():void
		{
			log( "createDocument()" );
			var document:Document;
			if (_database != null)
			{
				document = _database.createDocument();
				if (document != null)
				{
					log( "DOCUMENT CREATED" );
					printDocumentDetails( document );
					
					_documentId = document.documentID;
					
					document.properties.testNum 	= Math.random();
					document.properties.testInt 	= int( Math.random()*100 );
					document.properties.testBool 	= true;
					document.commit();
				}
				else
				{
					log( "ERROR:: Could not create document" );
				}
			}
		}
		
		public function getExistingDocument():void
		{
			log( "getExistingDocument()" );
			var document:Document;
			if (_database != null)
			{
				document = _database.getExistingDocument( _documentId );
				log( "DOCUMENT RETRIEVED" );
				printDocumentDetails( document );
				printDatabaseDetails( _database );
			}
		}
		
		public function deleteDocument():void
		{
			if (_database != null)
			{
				var success:Boolean = _database.deleteDocument( _documentId );
				
				log( "DOCUMENT DELETE: " + success );
				
				printDatabaseDetails( _database );
			}
		}
		
		public function updateDocument():void
		{
			if (_database != null)
			{
				var document:Document = _database.getExistingDocument( _documentId );
				if (document != null)
				{
					document.properties.updateValue = Math.random() * 10000;
					document.properties.updateDate = new Date().toLocaleDateString();
					
					document.commit();
				}
			}
		}
		
		
		
		private function printDocumentDetails( document:Document ):void
		{
			if (document != null)
			{
				log( "document: " +document.documentID );
				if (document.properties != null)
				{
					for (var key:String in document.properties)
					{
						log( "\t " + key + " (" + getQualifiedClassName(document.properties[key]) +") = " + document.properties[key] );
					}
				}
			}
		}
		
		
		
		//
		//  SYNC
		//
		
		public function sync():void
		{
			if (_database != null)
			{
				_database.addEventListener( CouchbaseReplicationEvent.CHANGE, replicationChangeHandler );
				_database.sync(
						Config.couchbaseUrl,
						null
//						Authenticator.basicAuthenticator( "username", "password" )
				);
			}
		}
		
		
		private function replicationChangeHandler( event:CouchbaseReplicationEvent ):void
		{
			log( "replicationChange: " + event.replication.status );
		}
	}
}
