package com.patricksteele.net	
{
	import com.greensock.TweenLite;
	import com.patricksteele.preloaders.CirclePreloader;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.SecurityDomain;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	
	/**
	 * Class defines a display object that loads and displays an external image file (jpeg, png, gif). 
	 * Can display an optional preloader (CirclePreloader) when loading the image if required
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * @date 09.03.2010 
	 * @edited 12.07.2011 (LoaderContext code added to loadImage function)
	 * 
	 * @example The following code sets up an ImageContainer and loads an image
	 * <listing version="3.0">
	 * 		var img:ImageContainer = new ImageContainer(true);
	 * 		addChild(img);
	 * 		img.loadImage("img/test.jpg", 346,432);			
	 * </listing>
	 * 
	 */	
	public class ImageLoader extends Sprite
	{
		/**
		 * Sprite to hold loaded image 
		 */		
		private var _imgContainer:Sprite;		
		/**
		 * a bitmap of the loaded image
		 */		
		private var _imgBitmap:Bitmap;			
		/**
		 * width to set the loaded image.
		 */		
		private var _imgWidth:Number;
		/**
		 * height to set the loaded image.
		 */
		private var _imgHeight:Number;
		/**
		 * Loader to load the image
		 */		
		private var _imageLoader:Loader;		
		/**
		 * URLRequest used when loading the image
		 */
		private var _urlRequest:URLRequest;
		
		
		
		/**
		 * sprite to act as a placeholder while image s loading 
		 */		
		private var _imagePlaceHolder:Sprite;		
		/**
		 * background/placeholder colour 
		 */		
		private var _placeHolderColor:uint = 0xCCCCCC;		
		/**
		 * If the should the placeholder Sprite should be visible 
		 */		
		private var _ifShowPlaceholder:Boolean = true;
		
		
		
		/**
		 * preloader to display while the image is loading 
		 */		
		private var _imgPreloader:CirclePreloader;		
		/**
		 * if a preloader should be displayed when the image is being loaded 
		 */		
		private var _ifShowPreloader:Boolean = false;
		
		
		/**
		 * a text field we can use to display an error if there was a problem loading an image file 
		 */		
		private var _tfLoadError:TextField;
		
		
		/**
		 * CONSTRUCTOR
		 * 
		 * @param showPreloader 	If a loading animation should be shown when an image file is being loaded using the CirclePreloader class. Default = false;
		 * @param showPlaceHolder 	If a placeholder should be shown when an image file is being loaded. Default = true;
		 * @param preloaderCol	 	Colour for the CirclePreloader's lines. Default is 0x666666.
		 * @param placeHolderCol 	Colour for the placeholder rectangle that is visible while the image is loading. Default is 0xCCCCCC
		 * 
		 */		 
		public function ImageLoader(showPreloader:Boolean = false, showPlaceHolder:Boolean = true,  preloaderCol:uint = 0x666666, placeHolderCol:uint = 0xCCCCCC)
		{
			_ifShowPreloader = showPreloader;
			_ifShowPlaceholder = showPlaceHolder;
			
			// set up and add image preloader if needed
			if(_ifShowPreloader)
			{
				_imgPreloader = new CirclePreloader(6,12,6,2,preloaderCol,45);
			}
			
			
			_placeHolderColor = placeHolderCol;		
			
			// create placeholder sprite to show until loaded image is placed over the top of it
			_imagePlaceHolder = new Sprite();
			_imagePlaceHolder.x = 0;
			_imagePlaceHolder.y = 0;
			addChild(_imagePlaceHolder);
			
			
			// setup the sprite that will hold the loaded image
			_imgContainer = new Sprite();
			_imgContainer.x = 0;
			_imgContainer.y = 0;
			addChild(_imgContainer);
			
			
			// set up error textfield in case we need it
			var errorFormat:TextFormat = new TextFormat();
			errorFormat.font = "Arial";
			errorFormat.size = 10;		
			errorFormat.align = TextFormatAlign.LEFT;
			_tfLoadError = new TextField();
			_tfLoadError.defaultTextFormat = errorFormat;
			//_tfLoadError.embedFonts = true;
			_tfLoadError.antiAliasType = AntiAliasType.NORMAL;
			_tfLoadError.autoSize = TextFieldAutoSize.LEFT;
			_tfLoadError.textColor = 0x000000;
			_tfLoadError.selectable = false;
			_tfLoadError.multiline = true;
			_tfLoadError.wordWrap = true;
		}
		
		
		/**
		 * Function recieves the path to an image to be loaded and loads it.
		 * 
		 * @param imgPath		Url to the image to be loaded
		 * @param imgWidth		Width to set the size of loaded image.
		 * @param imageHeight	Height to set the size of loaded image.
		 * 
		 */		 
		public function loadImage(imgPath:String, imgWidth:Number, imgHeight:Number):void
		{
			_imgWidth = imgWidth;
			_imgHeight = imgHeight;
			
			// clean up any previous image display
			while(_imgContainer.numChildren > 0) 
			{
				_imgContainer.removeChildAt(0);
			}
			
			_imgContainer.alpha = 0; // we will fade it in again once image has loaded
			
			// draw a placeholder/bg the same size as Image to be loaded
			_imagePlaceHolder.graphics.clear();
			_imagePlaceHolder.graphics.lineStyle();
			_imagePlaceHolder.graphics.beginFill(_placeHolderColor);
			_imagePlaceHolder.graphics.drawRect(0, 0, _imgWidth, _imgHeight);
			_imagePlaceHolder.graphics.endFill();
			
			// decide if we need to show the placeholder
			if(_ifShowPlaceholder)
			{
				_imagePlaceHolder.alpha = 1;
			}
			else
			{
				_imagePlaceHolder.alpha = 0;
			}
			
			// set the width and position of the error textfield in case we need it
			_tfLoadError.width = imgWidth;
			_tfLoadError.x = 0;
			
			// add preloader animation if required
			if(_ifShowPreloader) 
			{
				addChild(_imgPreloader);
				_imgPreloader.x = _imgWidth/2;
				_imgPreloader.y = _imgHeight/2;
			}
			
			// set up loader instance to load in the image
			_imageLoader = new Loader();
						
			// Sometimes we'll want to load images from another server. If so we need to check for a policy file, otherwise we can´t get the data
			// from the file, and we will get a sandbox violation error. In order to check for the policy file we just need to include a 
			// LoaderContext with our request and set checkPolicyFile to true.		
			var loaderContext:LoaderContext = new LoaderContext();
			loaderContext.checkPolicyFile = true;
			loaderContext.securityDomain = SecurityDomain.currentDomain;
			loaderContext.applicationDomain = ApplicationDomain.currentDomain;
			
			// add event listeners for image loading
			_imageLoader.contentLoaderInfo.addEventListener(Event.INIT, onImageInit, false, 0, true);
			_imageLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleLoadProgress, false, 0, true);
			_imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoadComplete, false, 0, true);			
			_imageLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleIOError, false, 0, true);			
			_imageLoader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError, false, 0, true);
			//_imageLoader.contentLoaderInfo.addEventListener(HTTPStatusEvent.HTTP_STATUS, handleHttpStatus, false, 0, true);
			
			
			// load in the external image file	
			_urlRequest = new URLRequest(imgPath);
			
			try
			{
				_imageLoader.load(_urlRequest);
				//_imageLoader.load(_urlRequest,loaderContext);	// use if LoaderContext needed
			}
			catch(error:Error)
			{
				//
			}
			
		}
		
		
		
		/**
		 * This function is responsible for tracking the download progress of the image file. 
		 * 
		 * @param event
		 * 
		 */		
		private function handleLoadProgress(event:ProgressEvent):void
		{
			//trace("Loading In Progress");
			//trace("Downloaded " + event.bytesLoaded + " out of " + event.bytesTotal + " bytes");
		}
		
		
		/**
		 * The function which is triggered when the image file has completed loading. 
		 * 
		 * @param event
		 * 
		 */		
		private function onImageLoadComplete(event:Event):void
		{
			if(_ifShowPreloader) // remove preloader animation  if present
			{
				removeChild(_imgPreloader);				
			}
			
			// clean up event listeners
			_imageLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, handleLoadProgress);
			_imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoadComplete);			
			_imageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);			
			_imageLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			//_imageLoader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, handleHttpStatus);
			
			// store and display loaded image
			_imgBitmap = Bitmap(_imageLoader.content);
			
			// scale loaded image to specified dimensions if required
			_imgBitmap.width = _imgWidth;
			_imgBitmap.height = _imgHeight;
			
			// add image to display
			_imgContainer.addChild(_imgBitmap);	
			
			// fade in image
			TweenLite.to(_imgContainer, 0.2, {alpha:1});
		}
		
		
		
		/**
		 * **TODO:**
		 * 
		 * Event.INIT is commonly used when attempting to retrieve the width and height of an image when it finishes loaded. 
		 * Such property is not available instantly when the file finishes loading, so attempting to retrieve these properties 
		 * using Event.COMPLETE fails, Event.INIT must be used instead.
		 * 
		 * @param event
		 * 
		 */		
		private function onImageInit(event:Event):void
		{
			_imageLoader.contentLoaderInfo.removeEventListener(Event.INIT, onImageInit);
			//trace("Object Initialized");
			//trace("height:" + _imageLoader.content.height);
		}
		
		
		
		
		
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		/////////////////////// FUNCTION BELOW HANDLE ANY ERRORS THAT OCCUR WHEN LOADING THE IMAGE ////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
		
		
		
		/**
		 * Generated when a fatal error that results in an aborted download occurs, such as not being able to find the asset 
		 * 
		 * @param event
		 * 
		 */		
		private function handleIOError(event:IOErrorEvent):void 
		{
			//trace(event.text);
			
			// remove preloader if present
			if(_ifShowPreloader)
			{
				removeChild(_imgPreloader);				
			}
			
			// display error
			_tfLoadError.text = "Image could not be loaded!";
			_tfLoadError.x = (_imgWidth - _tfLoadError.width)/2;
			_tfLoadError.y = (_imgHeight - _tfLoadError.height)/2;
			_imgContainer.addChild(_tfLoadError);
			
			
			// clean up event listeners
			_imageLoader.contentLoaderInfo.removeEventListener(Event.INIT, onImageInit);
			_imageLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, handleLoadProgress);
			_imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoadComplete);			
			_imageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);			
			_imageLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			//_imageLoader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, handleHttpStatus);
		}
		
		/**
		 * Generated when the flash player can detect the status code for a failed HTTP request when attempting to load data.
		 * 
		 * @param event
		 * 
		 */		
		private function handleHttpStatus(event:HTTPStatusEvent):void 
		{
			//trace(event.status);
			
			// remove preloader if present
			if(_ifShowPreloader)
			{
				removeChild(_imgPreloader);				
			}
			
			
			// display error
			_tfLoadError.text = "Image could not be loaded!";
			_tfLoadError.x = (_imgWidth - _tfLoadError.width)/2;
			_tfLoadError.y = (_imgHeight - _tfLoadError.height)/2;
			_imgContainer.addChild(_tfLoadError);
			
			
			// clean up event listeners
			_imageLoader.contentLoaderInfo.removeEventListener(Event.INIT, onImageInit);
			_imageLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, handleLoadProgress);
			_imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoadComplete);			
			_imageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);			
			_imageLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			//_imageLoader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, handleHttpStatus);
		}
		
		/**
		 * Generated when data is attempted to be loaded from a domain that resides outside of the security sandbox.
		 * 
		 * @param event
		 * 
		 */		
		private function handleSecurityError(event:SecurityErrorEvent):void 
		{
			//trace(event.text);
			
			// remove preloader if present
			if(_ifShowPreloader)
			{
				removeChild(_imgPreloader);				
			}
			
			// display error
			_tfLoadError.text = "Image could not be loaded!";
			_tfLoadError.x = (_imgWidth - _tfLoadError.width)/2;
			_tfLoadError.y = (_imgHeight - _tfLoadError.height)/2;
			_imgContainer.addChild(_tfLoadError);
			
			
			// clean up event listeners
			_imageLoader.contentLoaderInfo.removeEventListener(Event.INIT, onImageInit);
			_imageLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, handleLoadProgress);
			_imageLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onImageLoadComplete);			
			_imageLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);			
			_imageLoader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityError);
			//_imageLoader.contentLoaderInfo.removeEventListener(HTTPStatusEvent.HTTP_STATUS, handleHttpStatus);
		}
		
	}
}