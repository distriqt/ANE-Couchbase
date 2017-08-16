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
 * @file   		Main.as
 * @brief  		
 * @author 		"Michael Archbold (ma&#64;distriqt.com)"
 * @created		08/01/2016
 * @copyright	http://distriqt.com/copyright/license.txt
 */
package com.distriqt.test.couchbase
{
	import com.distriqt.test.ILogger;
	
	import feathers.controls.Button;
	import feathers.controls.LayoutGroup;
	import feathers.controls.ScrollContainer;
	import feathers.layout.VerticalLayout;
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	/**	
	 * 
	 */
	public class Main extends Sprite implements ILogger
	{
		////////////////////////////////////////////////////////
		//	CONSTANTS
		//
		
		
		////////////////////////////////////////////////////////
		//	VARIABLES
		//
		
		private var _tests				: CouchbaseTests;

		
		//	UI
		private var _text				: TextField;
		
		private var _group				: LayoutGroup;
		
		
		
		////////////////////////////////////////////////////////
		//	FUNCTIONALITY
		//
		
		
		/**
		 *  Constructor
		 */
		public function Main()
		{
			super();
			addEventListener( Event.ADDED_TO_STAGE, addedToStageHandler );
		}
		
		
		////////////////////////////////////////////////////////
		//	ILogger
		//
		
		public function log( tag:String, message:String ):void
		{
			trace( tag+"::"+message );
			if (_text)
				_text.text = tag+"::"+message + "\n" + _text.text ;
		}
		

		private function createUI():void 
		{
			_text = new TextField( Math.min( 1024, stage.stageWidth), Math.min( 1024, stage.stageHeight ), "", "_typewriter", 18, Color.WHITE );
			_text.hAlign = HAlign.LEFT; 
			_text.vAlign = VAlign.TOP;
			_text.y = 40;
			_text.touchable = false;
			
			var layout:VerticalLayout = new VerticalLayout();
			layout.horizontalAlign = VerticalLayout.HORIZONTAL_ALIGN_RIGHT;
			layout.verticalAlign = VerticalLayout.VERTICAL_ALIGN_BOTTOM;
			layout.gap = 5;
			var container:ScrollContainer = new ScrollContainer();
			container.layout = layout;
			container.width = stage.stageWidth;
			container.height = stage.stageHeight-50;
			
			_tests = new CouchbaseTests( this );
			
			addAction( "List :Database", _tests.listDatabases, container );
			addAction( "Get :Database", _tests.getDatabase, container );
			addAction( "Sync :Database", _tests.sync, container );
			
			addAction( "Get All :Document", _tests.getAllDocuments, container );
			addAction( "Create :Document", _tests.createDocument, container );
			addAction( "Delete :Document", _tests.deleteDocument, container );
			addAction( "Get Existing :Document", _tests.getExistingDocument, container );
			addAction( "Update :Document", _tests.updateDocument, container );
			
			addChild( container );
			addChild( _text );
		}
		
		
		
		private function addAction( label:String, listener:Function, group:Sprite=null ):Button
		{
			var b:Button = new Button();
			b.label = label;
			b.addEventListener( starling.events.Event.TRIGGERED, listener );
			if (group != null) group.addChild( b );
			return b;
		}


		
		
		////////////////////////////////////////////////////////
		//	EVENT HANDLERS
		//
		
		protected function addedToStageHandler(event:Event):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStageHandler );
			new MetalWorksMobileTheme();
			createUI();
		}

		
	}
}
