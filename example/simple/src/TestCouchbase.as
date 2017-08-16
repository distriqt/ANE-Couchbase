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
 * This is a test application for the distriqt extension
 * 
 */
package
{
	import com.distriqt.extension.couchbase.Couchbase;
	import com.distriqt.extension.couchbase.Database;
	import com.distriqt.extension.couchbase.Document;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getQualifiedClassName;
	
	
	/**	
	 * Sample application for using the Couchbase Native Extension
	 */
	public class TestCouchbase extends Sprite
	{
		public static var APP_KEY : String = "APPLICATION_KEY";
		
		
		/**
		 * Class constructor 
		 */	
		public function TestCouchbase()
		{
			super();
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_text = new TextField();
			_text.defaultTextFormat = new TextFormat( "_typewriter", 18 );
			addChild( _text );
			
			stage.addEventListener( Event.RESIZE, stage_resizeHandler, false, 0, true );
			stage.addEventListener( MouseEvent.CLICK, mouseClickHandler, false, 0, true );
			
			init();
		}
		
		
		//
		//	VARIABLES
		//
		
		private var _text		: TextField;
		
		
		//
		//	INITIALISATION
		//	
		
		private function init( ):void
		{
			try
			{
				Couchbase.init( APP_KEY );
				message( "Couchbase Supported: " + Couchbase.isSupported );
				if (Couchbase.isSupported)
				{
					message( "Couchbase Version:   " + Couchbase.service.version );
					
					
					Couchbase.service.addEventListener( ErrorEvent.ERROR, couchbase_errorHandler );
					
					Couchbase.service.setup();
					
					message( "============ getAllDatabaseNames() ==================" );
					var databases:Array = Couchbase.service.getAllDatabaseNames();
					for (var i:int = 0; i < databases.length; ++i)
					{
						message( "db: " + databases[i] );
					}
					message( "=====================================================" );
				}
				
			}
			catch (e:Error)
			{
				message( "ERROR::" + e.message );
			}
		}
		
		
		//
		//	FUNCTIONALITY
		//
		
		private function message( str:String ):void
		{
			trace( str );
			_text.appendText(str+"\n");
		}
		
		
		private function printDocumentDetails( document:Document ):void
		{
			if (document != null)
			{
				message( "document: " +document.documentID );
				
				if (document.properties != null)
				{
					for (var key:String in document.properties)
					{
						message( "\t " + key + " (" + getQualifiedClassName(document.properties[key]) +") = " + document.properties[key] );
					}
				}
				
			}
		}
		
		
		private function printDatabaseDetails( database:Database ):void
		{
			message( "============ database ===============================" );
			message( "databaseName       = " + database.databaseName );
			message( "documentCount      = " + database.documentCount );
			message( "lastSequenceNumber = " + database.lastSequenceNumber );
			message( "=====================================================" );
		}
		
		
		//
		//	EVENT HANDLERS
		//
		
		private function stage_resizeHandler( event:Event ):void
		{
			_text.width  = stage.stageWidth;
			_text.height = stage.stageHeight - 100;
		}

		
		private var _stage		: int = 0;
		private var _database	: Database = null;
		private var _documentId	: String;
		
		
		private function mouseClickHandler( event:MouseEvent ):void
		{
			var document:Document;
			
			switch (_stage)
			{
				case 0:
				{
					//
					//	Create / Retrieve a database
					if (_database == null)
					{
						_database = Couchbase.service.getDatabase( "testdb" );
					}
					if (_database != null)
					{
						printDatabaseDetails( _database );
					}
					else
					{
						message( "GET DATABASE FAILED!!" );
					}
					break;
				}
					
					
				case 1:
				{
					//
					//	Create a document
					if (_database != null)
					{
						document = _database.createDocument();
						if (document != null)
						{
							message( "DOCUMENT CREATED" );
							printDocumentDetails( document );

							_documentId = document.documentID;

							document.properties.testNum 	= Math.random();
							document.properties.testInt 	= int( Math.random()*100 );
							document.properties.testBool 	= true;
							document.commit();
						}
						else
						{
							message( "ERROR:: Could not create document" );
						}
					}
						
					break;
				}
					
					
				case 2: 
				{
					//
					//	Retrieve a document
					if (_database != null)
					{
						document = _database.getExistingDocument( _documentId );
						message( "DOCUMENT RETRIEVED" );
						printDocumentDetails( document );
						
						printDatabaseDetails( _database );
					}
					
					break;
				}
					
					
				case 3:
				{
					//
					//	Delete a document
					if (_database != null)
					{
						var success:Boolean = _database.deleteDocument( _documentId );
						
						message( "DOCUMENT DELETE: " + success );
						
						printDatabaseDetails( _database );
					}
					
					break;
				}
					
			}
			_stage ++; if (_stage > 3) _stage = 0;
		}
		
		

		
		//
		//	EXTENSION HANDLERS
		//
		
		private function couchbase_errorHandler( event:ErrorEvent ):void
		{
			message( "ERROR::"+event.text );
		}
		

		
	}
}

