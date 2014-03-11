package 
{
	import com.patricksteele.effects.confetti.Confetti;
	
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.MovieClip;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.Security;
	
	// When creating pure AS3 projects a metadata is required to define how the swf functions.
	// This metadata needs to be inserted after import statements and before the main class definiton.
	[SWF(width="900", height="600", backgroundColor="#FFFFFF", frameRate="31")]
	
	/**
	 * The Document class for the Preloader SWF. Loads in the main application SWF.
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 */	
	public class PaddysAS3ExamplePreloader extends MovieClip
	{
		/**
		 * Loader to load the main application SWF
		 */		
		private var _mainSwfLoader:Loader;
		
		/**
		 * The url of the main SWF that needs to be preloaded 
		 */		
		private var _mainSwfURL:String = "PaddysAS3Example.swf";
		
		/**
		 * loading guage/progress bar to show how much of the main swf has loaded 
		 */		
		private var _loadingGuage:mcLoadingGuage;
		
		/**
		 * var to store the max width of the loading guages progress bar 
		 */		
		private var _maxLoadingGuageBarWidth:Number;
		
		/**
		 * An MC linked from the preloader FLA library. This will contain the main display for the preloader that will
		 * be shown during loading. May contain logos, simple animations, eye candy etc.
		 */		
		private var _mcPreloaderDisplay:mcPreloaderDisplay;
		
		
		/**
		 * CONSTRUCTOR 
		 */		
		public function PaddysAS3ExamplePreloader():void
		{
			init();	
		}
		
		/**
		 * Function starts the preloader SWF.
		 *  
		 * <p>Makes sure it has been added to the stage. This ensures the SWF has acccess to the stage and that the
		 * stage property is not undefined so that no errors will be thrown when the stage is referenced.</p>
		 * 
		 * <p>This is of particular importance when a SWF is loaded into another SWF ie. a parent SWF loading a child SWF
		 * as the child SWF's class constructor will be called to create the object before it is even added to it’s
		 * parent (the Loader object in the parent swf).</p>
		 */		
		public function init():void
		{
			trace("Start Preloader!");
			
			// The flash security sandbox prevents cross domain SWF's from accessing each others properties unless explicitly allowed through the code. 
			// Regarding how flash distinguishes between the stage of a container swf and a loaded swf, they reference the same object. All stage
			// properties references the single base-container Stage instance that all SWFs, including your main SWF and nested loaded SWF's are contained
			// in. The 'stage' property will be 'owned' by your main SWF so you need to explicitly allow access to it like any other property of the swf
			// using the below line of code. 
			Security.allowDomain("*");
			
				
			// make sure the SWF has been added to the stage and hence has access to it so we don't get any errors when 
			// making any calls to the stage. 
			if(stage)
			{
				onAddedToStage();
			} 
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true);
			}
		}
		
		/**
		 * Function called when the SWF has been added to the stage and sets it stage properties. Takes particular care to ensure
		 * stageWidth and stageHeight have been correctly set. Note some of the stage properties are commented out here as they can
		 * just be set from the main application SWF that this preloader SWF will load
		 * 
		 * <p>Due to a strange bug in SWFs embedded in IE using SWFObject even after the ADDED_TO_STAGE event has fired, both
		 * the stageWidth and stageHeight are initialised to zero and only updated to their correct values after a short delay. 
		 * This can cause problems in your app, particularly if you’re relying on these two values when laying out your GUI assets.</p>
		 * 
		 * <p>In order to handle the bug this function checks if stageWidth and stageHeight have been initialized to zero. If they
		 * have we need to wait for the stage RESIZE event to be fired when the SWF will be updated with it's correct stageHeight
		 * and stageHeight values (milliseconds after it's initialised).</p>
		 * 
		 * @param event
		 */		
		private function onAddedToStage(event:Event = null):void
		{
			//stage.frameRate = 31; // set optimum frame rate
			
			// stop the stage from rescaling itself automatically when window is resized. 
			// We do this as we will be setting up our own fluid layout by using the
			// listening to the stage for the Event.RESIZE event
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			
			//stage.align = StageAlign.TOP_LEFT; // set the alignment of the stage to the top left
			
			//stage.showDefaultContextMenu = false; // don't show the right click menu
			
			
			if(stage.stageWidth == 0 && stage.stageHeight == 0)
			{
				stage.addEventListener(Event.RESIZE, onStageResize);
			}
			else
			{
				// In Firefox and other browsers, the RESIZE event probably won't be called, and the stageWidth and stageHeight will already
				// be correctly set. In this case we will want to call onStageResize(null) straightaway.
				onStageResize(null);
				
				// alternativly we could force the event
				// stage.dispatchEvent(new Event(Event.RESIZE)); // force stage resize event for normal cases
			}
		}
		
		/**
		 * Function is called when the correct values for stageWidth and stageHeight have been set.
		 * 
		 * <p>Function loads the preloader SWF and then when load is complete calls <code>loadMainSWF()</code> function to
		 * begin loading of the main application SWF.</p>
		 * 
		 * @param event
		 */
		private function onStageResize(event:Event):void
		{
			if(stage.stageWidth > 0 && stage.stageHeight > 0) // double check to make sure stageWidth and stageHeight aren't still zero
			{
				// remove resize listener
				stage.removeEventListener(Event.RESIZE, onStageResize);
				
				trace("LOADING: loading preloader swf");
				
				// Wait for this preloader swf to load and then load the main application swf
				if (this.loaderInfo.bytesLoaded == this.loaderInfo.bytesTotal)
				{
					loadMainSWF(null); // load main application swf
				}
				else
				{
					this.loaderInfo.addEventListener(Event.COMPLETE, loadMainSWF, false, 0, true);
				}
			}
		}
		
		/**
		 * Function loads the main application SWF
		 * 
		 * @param event
		 */		
		private function loadMainSWF(event:Event):void
		{
			buildPreloaderDisplay(); // build preloader display to show while the child SWF is loading
			
			trace("LOADING: preloading main swf");
			
			// set up loader to load main swf
			_mainSwfLoader = new Loader();
			
			// use a cache buster to force the child swf to reload every time. Important if the child swf content is to change
			// alot and we want to ensure the latest version is always loaded.
			var cacheBuster:String = new Date().getTime().toString();			
			var swfRequest:URLRequest = new URLRequest(_mainSwfURL + "?rand=" + cacheBuster);
						
			// add listeners to monitor the loading
			_mainSwfLoader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, showLoadingProgress_handler, false, 0, true);
			_mainSwfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, loadingComplete_handler, false, 0, true);
						
			// begin the loading
			_mainSwfLoader.load(swfRequest);
		}
		
		/**
		 * Function creates the preloader display that is shown when the main SWF is loading.
		 */		
		private function buildPreloaderDisplay():void
		{
			// add main preloader display MC
			_mcPreloaderDisplay = new mcPreloaderDisplay();
			addChild(_mcPreloaderDisplay);
			_mcPreloaderDisplay.x = (stage.stageWidth - _mcPreloaderDisplay.width)/2;
			_mcPreloaderDisplay.y = 20;
			
			
			// add loading guage to show load progress			
			_loadingGuage = new mcLoadingGuage();
			addChild(_loadingGuage);
			_maxLoadingGuageBarWidth = _loadingGuage.loadProgressBar.width;
			_loadingGuage.loadProgressBar.width = 1;			
			_loadingGuage.x = (stage.stageWidth - _loadingGuage.width)/2;
			_loadingGuage.y = (stage.stageHeight - _loadingGuage.height)/2;
		}
		
		/**
		 * Function displays the current progress/status of the loading via the Loading Guage
		 *  
		 * @param event
		 */		
		private function showLoadingProgress_handler(event:ProgressEvent):void 
		{		
			// get amount loaded
			var loadFactor:Number = event.bytesLoaded/event.bytesTotal;
			
			// set new progres sbar width
			_loadingGuage.loadProgressBar.width = _maxLoadingGuageBarWidth * loadFactor;
		}
		
		/**
		 * Function handles what to do when the main application SWF has completed loading 
		 * 
		 * @param event
		 */		
		private function loadingComplete_handler(event:Event):void 
		{
			// if we want to remove preloader content here we can. Or if we want to leave it on screen while the loaded child SWF does stuff
			// (eg. retrieve data from database) then we can call it from the loaded child SWF
			cleanUpPreloaderDisplay();
			
			// remove listeners
			_mainSwfLoader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, showLoadingProgress_handler);
			_mainSwfLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, loadingComplete_handler);
			
			this.addChild(_mainSwfLoader.content);			
			var swf:Object = _mainSwfLoader.content;
			
			// If using this preloader SWF make sure the init() function call in the constructor of the child application's
			// document class is commented out. And make sure that the <code>swf.init(this)</code> call below is not commented out.
			swf.init(this);
		}
		
		/**
		 * Function allows us to update the status text field in the loading guage to indicate what is currently happening.
		 * 
		 * <p>This can be called from the doc class of the main application SWF when it has been loaded. By allowing the main
		 * application SWF (child SWF) to call it we can leave the preloader display on screen while the main application SWF performs
		 * set up actions such as loading XML and retrieving data from a database. This function will allow the current process in
		 * the main application SWF to be displayed in the status text field of the loading guage in this preloader SWF.</p>
		 * 
		 * @example Below is an example of how to call this function from the main application SWF
		 * 
		 * <listing version="3.0">
		 * 
		 * 		// if using a preloader SWF to load this SWF we can update the load guage status text
		 * 		if(_preloaderParentSwf != null)
		 * 		{
		 * 			_preloaderParentSwf.updateLoadStatus("Loading Config XML");
		 * 		}
		 * </listing>
		 * 
		 * @param strStatus
		 * 
		 */		
		public function updateLoadStatus(strStatus:String):void
		{
			_loadingGuage.txtLoadStatus.text = strStatus;
		}

		
		/**
		 * Function cleans up the preloader display once the main application swf has completed loading and is ready to start.
		 * 
		 * <p>There are 2 options on where to call this function from. We could call it from <code>loadingComplete_handler</code>
		 * function in this class once the child SWF has finished loading. OR we can wait and call it from the document class of 
		 * the loaded chld SWF (the main application SWF).</p>
		 * 
		 * <p>The second option allows us to leave the preloader display on screen while the main application SWF performs
		 * set up actions such as loading XML and retrieving data from a database and then remove it when these processes
		 * are complete</p>
		 * 
		 * @example Below is an example of how to call this function from the main application SWF
		 * 
		 * <listing version="3.0">
		 * 		// if using a preloader SWF to load this SWF remove it now
		 * 		if(_preloaderParentSwf != null)
		 * 		{
		 * 			_preloaderParentSwf.cleanUpPreloaderDisplay();
		 * 		}
		 * </listing>
		 */		
		public function cleanUpPreloaderDisplay():void
		{
			// remove preloader display from the display list
			this.removeChild(_mcPreloaderDisplay);
			
			// remove loading guage	from the display list
			removeChild(_loadingGuage);
		}
		
	}
}
