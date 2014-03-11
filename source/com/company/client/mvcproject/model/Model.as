package com.company.client.mvcproject.model
{
	import com.company.client.mvcproject.enums.ApplicationState;
	import com.company.client.mvcproject.events.CustomEvent;
	
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 * The main Model Class in the MVC structure. Forms an Observer Pattern with the Views in the MVC.
	 * 
	 * <p>Implements the IModel Interface.</p>
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 */
	public class Model extends EventDispatcher implements IModel
	{		
		/**
		 * current width and height of the application swf stored as a Point
		 */
		private var _swfDimensions:Point;
		
		/**
		 * an XML object that contains the Models data
		 * 
		 * @see init()
		 */
		private var _modelXML:XML;

		/**
		 * An array that will hold a Page object for each page specified in the XML
		 */
		private var _arrPages:Array;
		
		/**
		 * function stores the index of the current Page in the _arrPages Array
		 */
		private var _currentPageIndex:Number = 0;
		
		/**
		 * the current state of the application. Different states will cause different views to be displayed 
		 */		
		private var _applicationState:ApplicationState = ApplicationState.STATEA;
		
	
		/**
		 * CONSTRUCTOR 
		 */		
		public function Model(swfWidth:Number, swfHeight:Number)
		{
			// store initial swf dimensions
			_swfDimensions = new Point(swfWidth, swfHeight);
		
			_arrPages = new Array();
		}
		
		/**
		 * Function called by doc class. Starts the game by dispatching event to tell views to build themselves 
		 * 
		 */		
		public function startApplication():void
		{
			notifyObservers(CustomEvent.START_APPLICATION);
		}
		
		
		/**
		 * Function stores current swf width and height
		 * @param wid
		 */		
		public function setSwfDimensions(swfWidth:Number, swfHeight:Number):void
		{
			_swfDimensions.x = swfWidth;
			_swfDimensions.y = swfHeight;
			
			notifyObservers(CustomEvent.STAGE_RESIZED);
		}
		
		/**
		 * function returns current swf width and height as a Point
		 * @return 
		 */		
		public function getSwfDimensions():Point
		{
			return _swfDimensions;
		}
		
		/**
		 * This method is called whenever the data contained in the Model changes and dispatches a 
		 * CustomEvent to any registered observers (ie. the root/composite view in the Views Composite Pattern).
		 * 	
		 * @param customEventType
		 * @param additionalParams	Aloows passing of additional parameters with event
		 */		
		protected function notifyObservers(customEventType:String, additionalParams:Object = null):void 
		{
			// broadcast message
			var modelChangedEvent:CustomEvent = new CustomEvent(customEventType, false, false, additionalParams);
			dispatchEvent(modelChangedEvent);			
		}
		
		
		
		
/***************************************************************************************************
* FUNCTIONS THAT CONCERN THE APPLICATIONS CURRENT STATE. IE. WHAT SECTION IS CURRENTLY ACTIVE
****************************************************************************************************/
		
		/**
		 * Function sets the current application state and calls <code>notifyObservers</code> to dispatch event to views.
		 * 
		 * @param state
		 * @param additionalParams	Allows passing of optional parameters
		 */		
		public function setApplicationState(state:ApplicationState, additionalParams:Object = null):void
		{
			_applicationState = state;
			notifyObservers(CustomEvent.STATE_CHANGED, additionalParams);
		}
		

		
		/**
		 * Function returns the current application state 
		 * @return 
		 * 
		 */		
		public function getApplicationState():ApplicationState
		{
			return _applicationState;
			
		}
		
		
		
		
		
		
		
		
/***************************************************************************************************
* FUNCTIONS THAT CONCERN THE APPLICATION PAGE DATA
****************************************************************************************************/
		
		/**
		 * Function initializes this Model by populating it with data contained in the recieved XML 
		 * @param modelXML
		 * 
		 */		
		public function init(modelXML:XML):void
		{
			_modelXML = modelXML;
			
			trace("Model:Data Created From XML");
			
			// TODO: PARSE XML
			var childNodes:XMLList = _modelXML.children();
			
			for each(var childXML:XML in childNodes)
			{
				switch(childXML.name().localName)
				{
					case "pages": // page data
						collectPageData(childXML);
						break;

					
					case "header":
						//_urlBecks = childXML.becks.@url;
						//_urlPlay = childXML.play.@url;
						break;
					
					case "footer":
						//_strCopyrightInfo = childXML.copyright;
						//_strOutsideLineLogo = childXML.outsideLine;
						
					default:
				}
				
			}
		}
		
		
		/**
		 * Function creates a Page object for each page specified in the XML
		 * @param pagesXML
		 */		
		private function collectPageData(pagesXML:XML):void
		{
			var childNodes:XMLList = pagesXML.children();
			
			for each(var childXML:XML in childNodes)
			{
				switch(childXML.name().localName)
				{
					case "page":
						var page:Page = new Page(childXML.@id, childXML.@name, childXML.heading, childXML.content);
						_arrPages.push(page);
						break;
					
					default:
				}
			}
		}
		
		
		/**
		 * function returns an array containing all the pages 
		 * @return 
		 * 
		 */
		public function getPages():Array
		{
			return _arrPages;
		}
		
		
		/**
		 * function sets the index of the currently selected Page in the arrPage Array 
		 * 
		 * @param index
		 */		
		public function setCurrentPageIndex(index:Number):void
		{
			_currentPageIndex = index;			
			notifyObservers(CustomEvent.PAGE_CHANGED);
		}
		
		/**
		 * function gets the index of the currently selected Page in the arrPage Array 
		 * 
		 * @return 
		 */		
		public function getCurrentPageIndex():Number
		{
			return _currentPageIndex;
		}
		
		

	}
}