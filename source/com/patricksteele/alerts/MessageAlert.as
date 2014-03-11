package com.patricksteele.alerts
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;


	/**
	 * Singleton class defines an Alert popup to present a user with a message. Handy for showing feedback or error messages.
	 * 
	 * <p>Consists of a text message placed on a rectangular panel in the middle of the screen. The MessageAlert display object will also include
	 * a background of a large semi transparent blocker Sprite the size of the stage in order to block/deactivate the rest of the swf when the 
	 * MessageAlert display object is visible (this is useful as we usually will want to prevent the user doing anything else until the
	 * MessageAlert is dismissed. MessageAlert also has an optional close btn. If its displaying feedback we'll prob want the user to be
	 * able to close it after they have read the message. Whereas if it is a fatal error that we are displaying we probably dont want a
	 * close btn as we'll want to prevent the user from contining.</p>
	 *  
	 * <p>Before <code>MessageAlert.getInstance().showAlert()</code> funcion is called <code>MessageAlert.getInstance().setOwner(_stage)</code> 
	 * should be called once, preferrably in the Documnet class so it has ref to the stage. Otherwise the MessageAlert will not be displayed.</p>
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 * @example The following example uses the Singleton MessageAlert to display a message to the user
	 * <listing version="3.0">
	 * 	
	 * // at start of your app pref early in the doc class
	 * 	MessageAlert.getInstance().setOwner(_stage);	
	 * 
	 * // when you want to show the message alert. For example to display feedback or an error message
	 * MessageAlert.getInstance().showAlert("Error Message!", "center", 0xFFFFFF, 0x000000, 0.5, 10, 300, true);    
	 * 
	 * </listing> 
	 * 
	 */	
	public class MessageAlert extends Sprite
	{
		/**
		 * set as static so it is accessible to getInstance() function below. Holds an instance of this Singleton class
		 */		
		private static var _instance:MessageAlert;
		
		/**
		 * TextField to display the message 
		 */		
		private var _tfMessage:TextField;
		
		/**
		 * padding of _tfMessage from _alertPanel edges
		 */		
		private var _horzPadding:Number = 20;
		private var _vertPadding:Number = 20;
		
		/**
		 * Sprite into which alert panel shape will be drawn
		 */		
		private var _alertPanel:Sprite
		
		/**
		 * Sprite used to fade out screen when alert is shown 
		 */		
		private var _screenBlocker:Sprite;
		
		/**
		 * this holds reference to main swf stage. Must be set before Alert can be displayed
		 * @see setOwner()
		 */		
		private var _container:DisplayObjectContainer;
		
		/**
		 * for adding a dropshadow to the _alertPanel
		 */		
		private var _dropShadow:DropShadowFilter; 
		
		/**
		 * an optional close btn 
		 */		
		private var _closeBtn:Sprite;
		
		/**
		 * If it is allowed for the Alert to be closed 
		 */		
		private var _allowClosing:Boolean = false;

		
		/**
		 * constructor
		 */
		public function MessageAlert(enforcer:SingletonEnforcer)
		{
			super();
			
			if (enforcer == null)
			{
				throw Error("Singleton Enforcer Not Valid. Multiple Instances Not Allowed.");
			}
			else
			{
				initAlert(); // call function to create the display objects that make up the MessageAlert
			}
		}
		
		
		
		/**
		 * This is the Singleton instatiation method. If MessageAlert._instance already exists it is returned
		 * otherwise a new one is created
		 * 
		 * <p>This function is static therefore it can be invoked before an instance of the class exists</p>
		 * 
		 * @return an Instance of MessageAlert Singleton
		 * 
		 */		
		public static function getInstance():MessageAlert
		{
			if(_instance == null)
			{
				_instance = new MessageAlert(new SingletonEnforcer());
			}
			
			return _instance;
		}

		
		/**
		 * Function called when instance of MessageAlert is created. Creates the GUI elements used by the Alert.
		 * 
		 */		
		public function initAlert():void
		{
			_screenBlocker = new Sprite();
			_alertPanel = new Sprite();
			_dropShadow = new DropShadowFilter(1, 45, 0x000000, .7, 2, 2, 1, 3);
			_closeBtn = new Sprite();
			
			// set up TextField to display alert message
			_tfMessage = new TextField();
			var alertTF:TextFormat = new TextFormat();// create TextFormat for the Alert message
			alertTF.font = "Arial";
			alertTF.size = 12;
			alertTF.align = TextFormatAlign.CENTER;
			_tfMessage.mouseEnabled = false;
			_tfMessage.selectable = false; 
			_tfMessage.defaultTextFormat = alertTF; 
			//_tfMessage.embedFonts = true; 
			_tfMessage.multiline = true;
			_tfMessage.wordWrap = true;
				
		}
		
		
		/**
		 * Function sets reference to stage or ay DisplayObject so MessageAlert is added to
		 * the the specified object no matter where it is called from.
		 * 
		 * <p>This must be set before <code>showAert()</code> function is called</p>
		 *
		 * @param theStage The main swf Stage
		 * 
		 */		
		public function setOwner(alertOwner:DisplayObjectContainer):void
		{
			_container = alertOwner;
		}
		

		/**
		 * Function displays an Alert with message on the main swf stage
		 * 
		 * @param txtMessage 	Text message for the alert
		 * @param txtAlign		Alignment for the message text
		 * @param txtColour		Text colour
		 * @param alertColour 	Colour of alert panel
		 * @param alertAlpha	Alpha of alert alert panel. Default = 1
		 * @param alertCorner	If the corners of the alert panel should be rounded. Default = 0 ie square corners
		 * @param alertWidth	The width of the alert panel. Default = 300px
		 * @param showCloseBtn	If a close btn should be shown to allow alert to be closes. Default = false
		 * 
		 */		
		public function showAlert(txtMessage:String, txtAlign:String = TextFormatAlign.CENTER, txtColour:uint = 0xFFFFFF, alertColour:uint = 0x000000, alertAlpha:Number = 1, alertCorner:Number = 0, alertWidth:Number = 300, showCloseBtn:Boolean = false):void
		{
			if(_container != null)
			{
				// add MessageAlert instance to the stage if not already displayed
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
				

				// set TextField to display alert message
				_tfMessage.width = alertWidth - _horzPadding*2; 
				_tfMessage.autoSize = TextFieldAutoSize.LEFT;
				_tfMessage.textColor = txtColour; 
				_tfMessage.htmlText = txtMessage;
						
				
				// create a background panel for the alert message TextField
				var alertHeight:Number = _tfMessage.height + _vertPadding*2; // calculate alert height
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
				
				// position alert panel
				_alertPanel.x = (_container.stage.stageWidth - _alertPanel.width)/2;
				_alertPanel.y = (_container.stage.stageHeight - _alertPanel.height)/2;		
				_alertPanel.alpha = alertAlpha;
				
				// add and position alert message TextField
				if(! this.contains(_tfMessage))
				{
					this.addChild(_tfMessage);
				}
				_tfMessage.x = _alertPanel.x + _horzPadding;
				_tfMessage.y = _alertPanel.y + _vertPadding;			
				
				
				// add close btn if needed
				if(showCloseBtn)
				{
					addCloseBtn(txtColour, alertColour, alertAlpha, _alertPanel.x + _alertPanel.width, _alertPanel.y);
				}
				else
				{
					// remove close btn if present from previous alert
					if(this.contains(_closeBtn))
					{
						_closeBtn.removeEventListener(MouseEvent.CLICK, removeAlert);
						this.removeChild(_closeBtn);
						_allowClosing = false;
					}
				}
				
			}
		}
		
		
		/**
		 * Function adds a close btn to the alert to allow it to be removed from the swf's display (stage)
		 *  
		 * @param btnCol	Colour for the btn bg
		 * @param xCol		Colour for the X
		 * @param xAlpha	Alpha for the X
		 * @param xpos		X Position of btns top right corner
		 * @param yPos		Y Position of btns top right corner
		 * 
		 */		
		private function addCloseBtn(btnCol:uint, xCol:uint, xAlpha:Number, xpos:Number, yPos:Number):void
		{
			_allowClosing = true;
			
			// draw square
			_closeBtn.graphics.clear();
			_closeBtn.graphics.lineStyle();
			_closeBtn.graphics.beginFill(btnCol);
			_closeBtn.graphics.drawRoundRect(0, 0, 14, 14, 6);
			_closeBtn.graphics.endFill();
			
			// draw x
			_closeBtn.graphics.lineStyle(2,xCol,xAlpha,true);
			_closeBtn.graphics.moveTo(4,4);
			_closeBtn.graphics.lineTo(10,10);
			_closeBtn.graphics.moveTo(10,4);
			_closeBtn.graphics.lineTo(4,10);
			
			_closeBtn.x = xpos - _closeBtn.width - 5;
			_closeBtn.y = yPos + 5;
			
			_closeBtn.mouseChildren = false;
			_closeBtn.buttonMode = true;
			_closeBtn.addEventListener(MouseEvent.CLICK, removeAlert, false, 0, true);
			
			// add close btn
			if(! this.contains(_closeBtn))
			{
				this.addChild(_closeBtn);
			}
			
		}
		
		
		
		/**
		 * Function removes the MessageAlert from the display
		 * 
		 */		
		private function removeAlert(event:MouseEvent):void 
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
			
			// remove message textfield wheel
			if(this.contains(_tfMessage))
			{
				this.removeChild(_tfMessage);
			}
			
			// remove close btn if present
			_closeBtn.removeEventListener(MouseEvent.CLICK, removeAlert);
			if(this.contains(_closeBtn))
			{
				this.removeChild(_closeBtn);
				_allowClosing = false;
			}
			
			
			// removes the MessageAlert instance from swf's stage
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
		// trace("MessageAlert:SingletonEnforcer called");
	}
}