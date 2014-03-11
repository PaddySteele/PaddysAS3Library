package 
{
	import com.company.client.mvcproject.controllers.ILeafController;
	import com.company.client.mvcproject.controllers.INavigationController;
	import com.company.client.mvcproject.controllers.LeafController;
	import com.company.client.mvcproject.controllers.NavigationController;
	import com.company.client.mvcproject.events.CustomEvent;
	import com.company.client.mvcproject.model.IModel;
	import com.company.client.mvcproject.model.Model;
	import com.company.client.mvcproject.utils.ApplicationSettings;
	import com.company.client.mvcproject.views.BackgroundView;
	import com.company.client.mvcproject.views.ComponentView;
	import com.company.client.mvcproject.views.CompositeView;
	import com.company.client.mvcproject.views.FooterView;
	import com.company.client.mvcproject.views.HeaderView;
	import com.company.client.mvcproject.views.LeafView;
	import com.company.client.mvcproject.views.NavigationView;
	import com.company.client.mvcproject.views.RootCompositeView;
	import com.patricksteele.alerts.LoadingAlert;
	import com.patricksteele.alerts.MessageAlert;
	import com.patricksteele.net.XmlFileLoader;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Security;

	
	// When creating pure AS3 projects a metadata is required to define how the swf functions.
	// This metadata needs to be inserted after import statements and before the main class definiton.
	[SWF(width="900", height="600", backgroundColor="#FFFFFF", frameRate="31")]

	
	/**
	 * The Document/Main class for the Application. Handles swf initilazition, config XML load and 
	 * building of the MVC structure
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 */	
	public class PaddysAS3Example extends Sprite
	{
		/**
		 * location of external config xml file to be loaded
		 */		
		private var _configXMLLocation:String = "xml/config.xml";
		
		/**
		 * Used to load the config XML file 
		 */		
		private var _xmlFileLoader:XmlFileLoader;
		
		/**
		 * will hold the XML loaded from the config XML file 
		 */		
		private var _configXML:XML;

		/**
		 * The Model for the application
		 */		
		private var _model:IModel;
		
		/**
		 * The main/root composite view instance which other views will be added to re the Composite Pattern 
		 */		
		private var _rootCompositeView:CompositeView;
		
		
		/**
		 * Component views in the Composite Pattern
		 */	
		private var _backgroundView:ComponentView;
		private var _headerView:ComponentView;
		private var _navigationView:ComponentView;
		private var _footerView:ComponentView;
		private var _leafView:ComponentView; 
		
		/**
		 * Controllers
		 */
		private var _navigationController:INavigationController;
		private var _leafController:ILeafController;
		
		
		/**
		 * var to hold reference to the preloader SWF if this SWF uses a preloader 
		 */		
		private var _preloaderParentSwf:Object;
		
		
		
		/**
		 * CONSTRUCTOR 
		 */		
		public function PaddysAS3Example():void
		{
			// If using the preloader SWF this is just for testing and should be commented out before
			// deployment as the preloader swf will call the <code>init()</code> function in
			// its <code>loadingComplete_handler</code> function.
			// If not using the preloader SWF then this line must be present!
			//init();
		}
		
		
		/**
		 * Function starts the application SWF.
		 *  
		 * <p>Makes sure it has been added to the stage. This ensures the SWF has acccess to the stage and that the
		 * stage property is not undefined so that no errors will be thrown when the stage is referenced.</p>
		 * 
		 * <p>This is of particular importance when a SWF is loaded into another SWF ie. a parent SWF loading a child SWF
		 * as the child SWF's class constructor will be called to create the object before it is even added to it’s
		 * parent (the Loader object in the parent swf).</p>
		 */		
		public function init(parent:Object = null):void
		{
			trace("Start Application!");
			
			if(parent != null) // check for parent preloader SWF
			{
				_preloaderParentSwf = parent;
			}
			
			// The flash security sandbox prevents cross domain swfs from accessing each others properties unless explicitly allowed through the code.
			// Should this SWF load in any child SWF's this will allow the child SWF access to the parents properties (including the stage)
			// Regarding how flash distinguishes between the stage of a container swf and a loaded swf, they reference the same object. All stage
			// properties references the single base-container Stage instance that all SWFs, including your main SWF and nested loaded SWF's are contained
			// in. The 'stage' property will be 'owned' by your main swf so you need to explicitly allow access to it like any other property of the swf
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
		 * stageWidth and stageHeight have been correctly set.
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
			stage.frameRate = 31; // set optimum frame rate
			
			// stop the stage from rescaling itself automatically when window is resized. 
			// We do this as we will be setting up our own fluid layout by using the
			// listening to the stage for the Event.RESIZE event
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			stage.align = StageAlign.TOP_LEFT; // set the alignment of the stage to the top left
			
			// ***NOTE: for some reason setting this to false may add an extra 20 pix to stage height when run in flash player 10 debug
			stage.showDefaultContextMenu = false; // don't show the right click menu
			
			// initilize MessageAlert object that we can use to display user message such as errors. Need to give it a ref to the stage for it to work
			MessageAlert.getInstance().setOwner(stage);
			
			// initilize LoadingAlert object that we can use to display loading animation when needed. Need to give it a ref to the stage for it to work
			LoadingAlert.getInstance().setOwner(stage);
			
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
		 * <p>Function loads the application SWF and then when load is complete calls <code>checkForFlashVars()</code> function to
		 * to check for any required FlashVars before we begin loading of the config XML file.</p>
		 * 
		 * @param event
		 */
		private function onStageResize(event:Event):void
		{
			if(stage.stageWidth > 0 && stage.stageHeight > 0) // double check to make sure stageWidth and stageHeight aren't still zero
			{
				// remove resize listener
				stage.removeEventListener(Event.RESIZE, onStageResize);
				
				trace("LOADING: loading main application swf");
				
				// check for FlashVars once swf has loaded
				if (this.loaderInfo.bytesLoaded == this.loaderInfo.bytesTotal)
				{
					checkForFlashVars(null);
				}
				else
				{
					this.loaderInfo.addEventListener(Event.COMPLETE, checkForFlashVars, false, 0, true);
				}
			}
		}
		
		/**
		 * Funcion allows us to check for any Flash Vars we may need to load. 
		 * Once we have these we can proceed with loading the config XML file.
		 * 
		 * @param event
		 */		
		private function checkForFlashVars(event:Event):void
		{
			var swfRoot:Object;
			
			if(_preloaderParentSwf != null) // if using parent preloader SWF
			{
				swfRoot = _preloaderParentSwf.root;
			}
			else // if not using parent preloader SWF
			{
				swfRoot = root;
			}
			
			// check for flash vars here
			if(swfRoot.loaderInfo.parameters["configXML"] != null)
			{
				_configXMLLocation = swfRoot.loaderInfo.parameters["configXML"];
			}

			// load config XML file
			loadConfigXML();
		}
		
		
		/**
		 * Function loads in XML configuration file
		 * 
		 */		
		private function loadConfigXML():void
		{
			trace("LOADING: loading config XML");
			
			_xmlFileLoader = new XmlFileLoader();
			
			// show loading alert while we wait for XML to load
			LoadingAlert.getInstance().showAlert(0x333333, 0xFFFFFF, 0.8, 10);

			// add event listeners for the XML file load
			_xmlFileLoader.addEventListener(XmlFileLoader.LOAD_SUCCESS, xmlLoadSuccessHandler, false, 0, true);
			_xmlFileLoader.addEventListener(XmlFileLoader.LOAD_ERROR, xmlLoadErrorHandler, false, 0, true);
			
			// use a cache buster to force XML reload. This prevents caching errors on refresh. 
			// One example error that can occur is when this swf is loaded by the preloader - it will load fine the first time but if refreshed
			// the xml may not reload properly and the data will be null.
			var cacheBuster:String = new Date().getTime().toString();
			_xmlFileLoader.load(_configXMLLocation + "?rand=" + cacheBuster);
			
		}
		
		
		
		/**
		 * Function handles what happens when XmlFileLoader object has successfully
		 * loaded the config XML file
		 * 
		 * @param event
		 * 
		 */		
		private function xmlLoadSuccessHandler(event:Event):void
		{
			// remove event listeners
			_xmlFileLoader.removeEventListener(XmlFileLoader.LOAD_SUCCESS, xmlLoadSuccessHandler);
			_xmlFileLoader.removeEventListener(XmlFileLoader.LOAD_ERROR, xmlLoadErrorHandler);
			
			// make sure loading alert is removed if it was present now that the XML has loaded
			LoadingAlert.getInstance().removeAlert();
			
			_configXML = _xmlFileLoader.getLoadedXML();
			
			trace("Document Class:XML Loaded Successfully");
			
			storeGlobalApplicationVars(_configXML.settings); // extract any global settings for the application
			storeGlobalApplicationVars(_configXML.colors); // extract any global styles for the application
			storeGlobalApplicationVars(_configXML.text); // extract any global text variables for the application - useful for localizaion
			
			buildMVCStructure();// function builds the MVC framework			
		}
		

		
		/**
		 * Function handles what happens if XmlFileLoader object had a problem
		 * loading the config XML file
		 * @param event
		 * 
		 */		
		private function xmlLoadErrorHandler(event:Event):void
		{
			// remove event listeners
			_xmlFileLoader.removeEventListener(XmlFileLoader.LOAD_SUCCESS, xmlLoadSuccessHandler)
			_xmlFileLoader.removeEventListener(XmlFileLoader.LOAD_ERROR, xmlLoadErrorHandler);

			// make sure loading alert is removed if it was present
			LoadingAlert.getInstance().removeAlert();
			
			//TODO: handle error - maybe using an AlertSingleton class
			trace("Document Class:Error Loading XML");
			
			var strAlertMessage:String = _xmlFileLoader.getErrorMessage();
			
			MessageAlert.getInstance().showAlert(strAlertMessage, "center", 0xFFFFFF, 0x000000, 0.5, 10, 300, false);  
		}
		
		
		/**
		 * function stores any application variables specified in the config XML file. The variables are stored in
		 * an ApplicationSettings object to allow Global access to them.
		 * 
		 * @see ApplicationSettings
		 * 
		 * @param settingsXMLList
		 */		
		private function storeGlobalApplicationVars(varsXMLList:XMLList):void
		{
			var propertyNodes:XMLList = varsXMLList.children();
			
			for each(var childXML:XML in propertyNodes)
			{
				switch(childXML.name().localName)
				{
					case "property":
						ApplicationSettings.getInstance().setProperty(childXML.@id, childXML.@value);
						break;
					
					default:
				}
			}
		}
		

			
		/**
		 * Function sets up the Model, Controllers and Views that make up the applications MVC framework 
		 * 
		 * <p> MVC framework uses a Composite Design Pattern to structure its Views.</p>
		 * <p> MVC framework uses a Strategy Design Pattern between Views and Controllers.</p>
		 * <p> MVC framework uses a Observer Design Pattern between Model and Views.</p>
		 */		
		private function buildMVCStructure():void
		{
			trace("Document Class:Build MVC Structure");
			
			_model = new Model(this.stage.stageWidth, this.stage.stageHeight);
			
			// add root composite view that will act as parent/root for all other views
			_rootCompositeView = new RootCompositeView(_model);
			addChild(_rootCompositeView);

			// set up background view - doesn't need a controller
			_backgroundView = new BackgroundView(_model, null);
			_rootCompositeView.add(_backgroundView);
			
			// set up header view - doesn't need a controller
			_headerView = new HeaderView(_model, null);
			_rootCompositeView.add(_headerView);
			
			// set up footer view - doesn't need a controller
			_footerView = new FooterView(_model, null);
			_rootCompositeView.add(_footerView);
			
			// set up navigation view and controller
			_navigationController = new NavigationController(_model);
			_navigationView = new NavigationView(_model, _navigationController);
			_rootCompositeView.add(_navigationView);
			
			// set up leaf view and controller
			_leafController = new LeafController(_model);
			_leafView = new LeafView(_model, _leafController);
			_rootCompositeView.add(_leafView);
	
			
			// register the root view in the Composite Pattern (ie. _rootCompositeView) to recieve notifications from
			// the Model when it changes. Only the root view has to be registered in the Composite Pattern
			// as the event will cascade down to each of its child nodes
			_model.addEventListener(CustomEvent.START_APPLICATION, _rootCompositeView.updateView, false, 0, true);
			_model.addEventListener(CustomEvent.STAGE_RESIZED, _rootCompositeView.updateView, false, 0, true);
			_model.addEventListener(CustomEvent.PAGE_CHANGED, _rootCompositeView.updateView, false, 0, true);
			_model.addEventListener(CustomEvent.STATE_CHANGED, _rootCompositeView.updateView, false, 0, true);

			
			// initialize model with data from loaded XML
			_model.init(_configXML);
			
			
			// IF WE WANT A FLUID LAYOUT//////////////////////////////////////////////////////////////////
			// register stage to recieve notification on stage resize. Calls stageResizeHandler() 
			// to reposition views and their GUI elements when stage is resized. Allows for a fluid layout.
			stage.addEventListener(Event.RESIZE, stageResizeHandler, false, 0, true);

			// Start the Application
			startApplication();			
		}
		
		
		/**
		 * Funciton tells the model to start the SWF application 
		 *
		 */		
		private function startApplication():void
		{
			_model.startApplication();
		}
		
		
		
		/**
		 * Function is called when the stage is resized. Updates the model with the new stage dimensions.
		 * 
		 * <p>Model will then tell Views to update themselves accordingly</p>
		 * 
		 * @param event
		 * 
		 */		
		private function stageResizeHandler(event:Event = null):void 
		{   
			_model.setSwfDimensions(stage.stageWidth, stage.stageHeight);
		} 

		
		
	}
}
