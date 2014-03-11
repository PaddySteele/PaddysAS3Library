package com.patricksteele.net
{
	import flash.events.*;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	
	/**
	 * Class loads an external XML file and handles any errors that occur
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 * @example Example usage is given below
	 * <listing version="3.0">
	 * 
	 * 	_xmlFileLoader = new XmlFileLoader();
	 * 
	 * 	_xmlFileLoader.addEventListener(XmlFileLoader.LOAD_SUCCESS, xmlLoadSuccess_handler)
	 * 	_xmlFileLoader.addEventListener(XmlFileLoader.LOAD_ERROR, xmlLoadError_handler);
	 * 	_xmlFileLoader.load(_configXMLLocation);
	 * 
	 * 	private function xmlLoadSuccess_handler(event:Event):void
	 * 	{
	 * 		var myXML:XML = _xmlFileLoader.getLoadedXML();
	 * 
	 * 		// parse myXML
	 * 	}
	 * 
	 * 	private function xmlLoadError_handler(event:Event):void
	 * 	{
	 * 		// handle error
	 * 		trace(_xmlFileLoader.getErrorMessage();)
	 * 	}
	 * 
	 * </listing>
	 */		
	public class XmlFileLoader extends EventDispatcher 
	{
		/**
		 * XML loader for loading the XML file 
		 */		
		private var _xmlLoader:URLLoader;
			
		/**
		 * the url of the XML file to be loaded 
		 */		
		private var _xmlFileLocation:String;
		
		/**
		 * url request object to specify the XML file to be loaded 
		 */		
		private var _urlRequest:URLRequest;
		
		/**
		 * XML object to hold the loaded XML 
		 */		
		private var _loadedXML:XML;
		
		/**
		 * Constants for dispatching Events 
		 */		
		public static const LOAD_SUCCESS:String = "loadsuccess";
		public static const LOAD_ERROR:String = "loaderror";
		
		
		/**
		 * String to hold any error messages that may be ecountered when loading XML file 
		 */		
		private var _errorMessage:String = "";
		
		
		
		/**
		 * constructor 
		 */		
		public function XmlFileLoader()
		{			
		}
		
		/**
		 * Function loads the external XML file 
		 * @param fileURL The URL of the XMl file to be loaded
		 * 
		 */		
		public function load(fileURL:String):void
		{
			_errorMessage = ""; // clear any previous error meesage from any previous loads
			
			_loadedXML = null;
			
			_xmlFileLocation = fileURL;
			
			_urlRequest = new URLRequest(_xmlFileLocation);
			
			// Use the 2 lines below will force the reloading of the file from the server. Can act as an alternative to appending a cache-buster parameter
			// to the file url. The main difference bwtween this and using a cache-buster is that a cache-buster will assume it is loading a different
			// file each time and will end up filling the cache with endless copies of the same file, the technique reloads the same file and doesn’t add
			// any additional copies to the cache.
			//_urlRequest.method = URLRequestMethod.POST; 
			//_urlRequest.data = true; // POST requests require non-null data 
			
			_xmlLoader = new URLLoader();
			_xmlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			
			// add event listeners for the XML file load
			_xmlLoader.addEventListener(Event.COMPLETE, xmlLoadComplete_handler, false, 0, true)
			_xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, ioError_handler, false, 0, true);
			_xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError_handler, false, 0, true);
			//_xmlLoader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus_handler, false, 0, true);
			
			_xmlLoader.load(_urlRequest);
		}
		
		
		/**
		 * Funciton handles what happens when the loading of the XML is complete
		 * 
		 * @param event
		 * 
		 */		
		private function xmlLoadComplete_handler(event:Event):void
		{
			// remove event listeners
			_xmlLoader.removeEventListener(Event.COMPLETE, xmlLoadComplete_handler)
			_xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioError_handler);
			_xmlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError_handler);
			//_xmlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus_handler);
			
			
			var xmlLoadOk:Boolean = true;
			
			try
			{
				_loadedXML = new XML(event.target.data); // convert downloaded text into XML instance
			}
			catch(e:TypeError) // if badly formatted xml
			{
				xmlLoadOk = false;
				trace(e.message)
			}
			
			if(xmlLoadOk) // if xml loaded and was parsed OK
			{				
				dispatchEvent(new Event(LOAD_SUCCESS));				
			}
			else
			{
				_errorMessage = "Error loading '" + _xmlFileLocation + "'<br/><br/>Details: Loaded XML badly formatted";
				dispatchEvent(new Event(LOAD_ERROR));				
			}
		}
		

		/**
		 * function returns the loaded XML 
		 * @return XML object
		 * 
		 */		
		public function getLoadedXML():XML
		{
			return _loadedXML;
		}
		
		
		

		/**
		 * Generated when the flash player encounters a fatal error that results
		 * in an aborted download, such as not being able to find the XML File.
		 * @param event 
		 */		
		private function ioError_handler(event:IOErrorEvent):void 
		{
			// remove event listeners
			_xmlLoader.removeEventListener(Event.COMPLETE, xmlLoadComplete_handler)
			_xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioError_handler);
			_xmlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError_handler);
			//_xmlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus_handler);
			
			//trace(event.text);
			_errorMessage = "Error loading '" + _xmlFileLocation + "'<br/><br/>Details: " + event.text;
			dispatchEvent(new Event(LOAD_ERROR));
		}
		
		
		/**
		 * Generated when the flash player can detect the status code for a
		 * failed  HTTP request when attempting to load data
		 * @param event
		 * 
		 */		
		private function httpStatus_handler(event:HTTPStatusEvent):void 
		{
			// remove event listeners
			_xmlLoader.removeEventListener(Event.COMPLETE, xmlLoadComplete_handler)
			_xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioError_handler);
			_xmlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError_handler);
			//_xmlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus_handler);
			
			//trace(event.status);
			_errorMessage = "Error loading '" + _xmlFileLocation + "'<br/><br/>Details: " + event.status;
			dispatchEvent(new Event(LOAD_ERROR));
		}
		
		
		/**
		 * Generated when data is attempted to be loaded from a domain that
		 * resides outside of the security sandbox.
		 * @param event
		 * 
		 */		
		private function securityError_handler(event:SecurityErrorEvent):void 
		{
			// remove event listeners
			_xmlLoader.removeEventListener(Event.COMPLETE, xmlLoadComplete_handler)
			_xmlLoader.removeEventListener(IOErrorEvent.IO_ERROR, ioError_handler);
			_xmlLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityError_handler);
			//_xmlLoader.removeEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatus_handler);
			
			//trace(event.text);
			_errorMessage = "Error loading '" + _xmlFileLocation + "'<br/><br/>Details: " + event.text;
			dispatchEvent(new Event(LOAD_ERROR));
		}

		
		/**
		 * Function allows an error message to be retrieved if there was a problem loading the XML file 
		 * @return 
		 * 
		 */		
		public function getErrorMessage():String
		{
			return _errorMessage;
		}
		
		
	}
}