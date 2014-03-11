package com.patricksteele.alerts
{
	import com.patricksteele.preloaders.CirclePreloader;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	
	
	/**
	 * Singleton class defines an please wait loading animation to display when waiting on the swf to do something such as loading data.
	 * 
	 * <p>Consists of a small loading wheel placed on a small rectangular panel in the middle of the screen. The LoadingAlert display object
	 * will also include a background of a large semi transparent blocker Sprite the size of the stage in order to block/deactivate the rest
	 * of the swf when the LoadingAlert display object is visible (this is useful as we usually will want to prevent the user doing anything
	 * else while we wait for data to load).</p>
	 * 
	 * <p>Before <code>LoadingAlert.getInstance().showAlert()</code> function is called <code>LoadingAlert.getInstance().setOwner(_stage)</code> 
	 * should be called once, preferrably in the Document class so it has ref to the stage. Otherwise the LoadingAlert will not be displayed.</p>
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 * @example The following example uses the Singleton LoadingAlert to graphically let the user know they should wait for the swf to do something 
	 * <listing version="3.0">
	 * 	
	 * // at start of your app pref early in the doc class
	 * 	LoadingAlert.getInstance().setOwner(_stage);	
	 * 
	 * // when you want to show the loading alert ie. at the start of loading something	
	 * LoadingAlert.getInstance().showAlert(0x333333, 0xFFFFFF, 1, 10); 
	 * 
	 * // when your load has completed you can then remove the loading alert
	 * 	LoadingAlert.getInstance().removeAlert(); 
	 * 
	 * </listing>  
	 * 
	 */	
	public class LoadingAlert extends Sprite
	{
		/**
		 * set as static so it is accessible to getInstance() function below. Holds an instance of this Singleton class
		 */		
		private static var _instance:LoadingAlert;
		
		/**
		 * loading wheel to display 
		 */		
		private var _loadingWheel:CirclePreloader;
		
		/**
		 * padding of _loadingWheel from _alertPanel edges
		 */		
		private var _horzPadding:Number = 20;
		private var _vertPadding:Number = 20;
		
		/**
		 * Sprite into which a rectangle will be drawn and on top of which the _loadingWheel will be placed
		 */		
		private var _alertPanel:Sprite
		
		/**
		 * Sprite used to fade out screen when alert is shown 
		 */		
		private var _screenBlocker:Sprite;
		
		/**
		 * this holds reference to main swf stage. Must be set before LoadingAlert can be displayed
		 * @see setOwner()
		 */		
		private var _container:DisplayObjectContainer;
		
		/**
		 * for adding a dropshadow to the _alertPanel
		 */		
		private var _dropShadow:DropShadowFilter; 
		
		
		/**
		 * constructor
		 */
		public function LoadingAlert(enforcer:SingletonEnforcer)
		{
			super();
			
			if(enforcer == null)
			{
				throw Error("Singleton Enforcer Not Valid. Multiple Instances Not Allowed.");
			}
			else
			{
				initAlert(); // call function to create the display objects that make up the LoadingAlert
			}
		}
		
		
		
		/**
		 * This is the Singleton instatiation method. If LoadingAlert._instance already exists it is returned
		 * otherwise a new one is created
		 * 
		 * <p>This function is static therefore it can be invoked before an instance of the class exists</p>
		 * 
		 * @return an Instance of LoadingAlert Singleton
		 * 
		 */		
		public static function getInstance():LoadingAlert
		{
			if(_instance == null)
			{
				_instance = new LoadingAlert(new SingletonEnforcer());
			}
			
			return _instance;
		}
		
		
		/**
		 * Function called when instance of LoadingAlert is created. Creates the GUI elements used by the Alert.
		 * 
		 */		
		public function initAlert():void
		{
			_screenBlocker = new Sprite();
			_alertPanel = new Sprite();
			_loadingWheel = new CirclePreloader(6,12,6,2,0x666666,65);
			_dropShadow = new DropShadowFilter(1, 45, 0x000000, .7, 2, 2, 1, 3);
		}
		
		
		
		/**
		 * Function sets reference to stage or any DisplayObject so LoadingAlert is added to
		 * the the specified object no matter where it is called from.
		 * 
		 * <p>This must be set before <code>showAlert()</code> function is called</p>
		 *
		 * @param theStage The main swf Stage
		 * 
		 */		
		public function setOwner(alertOwner:DisplayObjectContainer):void
		{
			_container = alertOwner;
		}
		
		
		/**
		 * Function displays an LoadingAlert with loading wheel on the main swf stage
		 * 
		 * @param loadWheelColour	Colour of the lines for the loading wheel
		 * @param alertColour 		Colour of alert panel
		 * @param alertAlpha		Alpha of alert alert panel. Default = 1
		 * @param alertCorner		If the corners of the alert panel should be rounded. Default = 0 ie square corners
		 * 
		 */		
		public function showAlert(loadWheelColour:uint = 0x333333, alertColour:uint = 0xFFFFFF, alertAlpha:Number = 1, alertCorner:Number = 0):void
		{
			if(_container != null)
			{
				// add LoadingAlert instance to the stage if not already displayed
				if(! _container.contains(this))
				{
					_container.addChild(this);
				}
				
				// set up and add blocker Sprite to fade out and deactivate rest of swf stage display when LoadingAlert is displayed
				_screenBlocker.graphics.clear();
				_screenBlocker.graphics.lineStyle();
				_screenBlocker.graphics.beginFill(0xFFFFFF);
				_screenBlocker.graphics.drawRect(0, 0, _container.stage.stageWidth, _container.stage.stageHeight);
				_screenBlocker.graphics.endFill();
				_screenBlocker.alpha = 0.2;
				_screenBlocker.mouseEnabled = false;
				if(! this.contains(_screenBlocker))
				{
					this.addChild(_screenBlocker);
				}
				
				
				// create a background panel for the wheel loading animation
				var alertWidth:Number = _loadingWheel.width + _horzPadding*2; // calculate alert width
				var alertHeight:Number = _loadingWheel.height + _vertPadding*2; // calculate alert height
				
				_alertPanel.graphics.clear();
				_alertPanel.graphics.lineStyle();
				_alertPanel.graphics.beginFill(alertColour);			
				
				if(alertCorner > 0) // decide of corners should be curved
				{
					_alertPanel.graphics.drawRoundRect(0, 0, alertWidth, alertHeight, alertCorner);
				}
				else
				{
					_alertPanel.graphics.drawRect(0, 0, alertWidth, alertHeight);
				}					
				_alertPanel.graphics.endFill();
				_alertPanel.filters = [_dropShadow];  // add dropshadow to the alert panel
				
				// add alert panel
				if(! this.contains(_alertPanel))
				{
					this.addChild(_alertPanel);
				}
				
				// set load wheel colour
				tintLoadWheel(loadWheelColour);
				
				// position alert panel
				_alertPanel.x = (_container.stage.stageWidth - _alertPanel.width)/2;
				_alertPanel.y = (_container.stage.stageHeight - _alertPanel.height)/2;		
				_alertPanel.alpha = alertAlpha;
				
				
				
				// add loading wheel
				if(! this.contains(_loadingWheel))
				{
					this.addChild(_loadingWheel);
				}
				
				// position loading wheel
				_loadingWheel.x = _alertPanel.x + _alertPanel.width/2;
				_loadingWheel.y = _alertPanel.y + _alertPanel.height/2;	
				
			}
		}
		
		
		/**
		 * Function tints the loading wheel colour 
		 * @param newColor
		 * 
		 */		
		private function tintLoadWheel(newColor:uint):void
		{
			var colorTransform:ColorTransform = _loadingWheel.transform.colorTransform;
			colorTransform.color = newColor;
			_loadingWheel.transform.colorTransform = colorTransform;
		}
		
		
		
		/**
		 * Function removes the LoadingAlert from display
		 * 
		 */		
		public function removeAlert():void 
		{ 			
			// remove blocker sprite
			_screenBlocker.graphics.clear();
			if(this.contains(_screenBlocker))
			{
				this.removeChild(_screenBlocker);
			}
			
			// removes alert panel
			_alertPanel.graphics.clear();
			if(this.contains(_alertPanel))
			{
				this.removeChild(_alertPanel);
			}
			
			// remove loading wheel
			if(this.contains(_loadingWheel))
			{
				this.removeChild(_loadingWheel);
			}
			
			// removes the LoadingAlert instance from swf's stage
			if(_container != null)
			{
				if(_container.contains(this))
				{
					_container.removeChild(this);
				}
			}
		}   
		
		
	}
	
}

/**
 * Singleton enforcer class 
 * 
 */
class SingletonEnforcer
{
	public function SingletonEnforcer()
	{
		// trace("LoadingAlert:SingletonEnforcer called");
	}
}