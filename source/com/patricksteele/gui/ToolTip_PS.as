package com.patricksteele.gui
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * A singleton Tool Tip class
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 * @example The following example creates a square btn Sprite and uses the Singleton ToolTipPS to display a ToolTip
	 * on mouse over 
	 * <listing version="3.0">
	 * 	package 
	 * 	{ 
	 * 		import com.patricksteele.utils.ToolTip_PS;
	 * 		import flash.display.Sprite;	
	 * 		import flash.events.MouseEvent;
	 * 		import flash.text.Font;
	 * 		import flash.text.TextFormat;
	 * 		import flash.text.TextFormatAlign; 
	 * 
	 * 		public class ToolTipExample extends Sprite 
	 * 		{ 
	 * 			private var _myBtn:Sprite;
	 * 			private var _myTextFormat:TextFormat;
	 * 
	 * 			public function ToolTipExample()
	 * 			{
	 * 				_myBtn = new Sprite(); 
	 *				_myBtn.graphics.beginFill(0xFF0000); 
	 *				_myBtn.graphics.drawRect(0, 0, 50, 50); 
	 *				_myBtn.graphics.endFill(); 
	 * 				addChild(_myBtn);
	 * 
	 * 				// set up TextFormat
	 * 				var _font:Font = new EmbeddedFont(); // linked from fla library
	 *				var _myTextFormat:TextFormat = new TextFormat();
	 * 				_myTextFormat.font = _font.fontName;
	 * 				_myTextFormat.size = 12;
	 * 				_myTextFormat.align = TextFormatAlign.LEFT;
	 * 
	 * 
	 *  			_myBtn.addEventListener(MouseEvent.ROLL_OVER, _showToolTip_handler);
	 * 				_myBtn.addEventListener(MouseEvent.ROLL_OUT, _removeToolTip_handler);
	 * 			}
	 * 
	 *			private function _showToolTip_handler(event:MouseEvent):void
	 * 			{
	 * 				 ToolTip_PS.getInstance().showToolTip(this, "My Button", _myTextFormat, 0x000000, 0xFFFFFF, 0.9, 10, 16);    
	 * 			}
	 * 
	 * 			private function _removeToolTip_handler(event:MouseEvent):void
	 * 			{
	 * 				ToolTip_PS.getInstance().removeToolTip();
	 * 			} 
	 * 
	 * 		}
	 *	}
	 * </listing>  
	 * 
	 */	
	public class ToolTip_PS extends Sprite
	{
		/**
		 * set as static so it is accessible to getInstance() function below. Holds an instance of this Singleton class
		 */		
		private static var _instance:ToolTip_PS;
		
		/**
		 * TextField to display the Tool Tips text 
		 */		
		private var _tfLabel:TextField;
		
		/**
		 * padding of _background edges from _background edges
		 */		
		private var _horzPadding:Number = 5;
		private var _vertPadding:Number = 2;
		
		/**
		 * Sprite into which tooltip background shape will be drawn
		 */		
		private var _background:Sprite
		
		/**
		 * this holds reference to the display object container that contains the display
		 * object that a ToolTipPS is associated with
		 */		
		private var _toolTipOwner:DisplayObjectContainer;
		
		
		/**
		 * for adding a dropshadow to the tooltip
		 */		
		private var _dropShadow:DropShadowFilter; 
		
		
		/**
		 * constructor
		 */
		public function ToolTip_PS(enforcer:SingletonEnforcer)
		{
			super();
			
			if (enforcer == null)
			{
				throw Error("Singleton Enforcer Not Valid. Multiple Instances Not Allowed.");
			}
			else
			{
				initToolTip(); // call function to create the display objects that make up the tooltip
			}
		}
		
		
		
		/**
		 * This is the Singleton instatiation method. If ToolTipPS._instance already exists it is returned
		 * otherwise a new one is created
		 * 
		 * <p>This function is static therefore it can be invoked before an instance of the class exists</p>
		 * 
		 * @return an Instance of ToolTipPS Singleton
		 * 
		 */		
		public static function getInstance():ToolTip_PS
		{
			if(_instance == null)
			{
				_instance = new ToolTip_PS(new SingletonEnforcer());
			}
			
			return _instance;
		}
		
		
		/**
		 * Function called when instance of ToolTip_PS is created. Creates the GUI elements used by the ToolTip.
		 * 
		 */		
		public function initToolTip():void
		{
			// create a background for the tooltip
			_background = new Sprite();
			
			// create dropshadow for the background
			_dropShadow = new DropShadowFilter(3, 45, 0x000000, .7, 2, 2, 1, 3);
			
			// create label textfield
			_tfLabel = new TextField();
			
			// important that mouse over is disabled on the Tooltip
			this.mouseEnabled = false;
			this.mouseChildren = false;
			
		}
		
		
		/**
		 * Function dislays a Tooltip
		 * 
		 * @param ttOwner 	The displayObjectContainer that contains the DisplayObject that the tool tip is highlighting
		 * @param txtLabel	Text label for the tool tip
		 * @param txtFormat	TextFormat for the text
		 * @param txtColour	Text colour
		 * @param bgColour 	Colour of tool tip background
		 * @param bgAlpha	Alpha of tool tip background. Default = 1
		 * @param bgCorner	If the corners of the background shule be rounded. Default = 0 ie square corners
		 * @param showTail	If a tail shuold be drawn on the tool tip. Default = 0 ie. no tail
		 * 
		 */		
		public function showToolTip(ttOwner:DisplayObjectContainer, txtLabel:String, txtFormat:TextFormat, txtColour:uint = 0xFFFFFF, bgColour:uint = 0x000000, bgAlpha:Number = 1, bgCorner:Number = 0, showTail:Number = 0):void
		{
			if(ttOwner != null)
			{
				// set refernece to owner of the DisplayObject the tool tip is associated with
				_toolTipOwner = ttOwner;
				
				// add tooltip instance to the display if not already added
				if(! _toolTipOwner.contains(this))
				{
					_toolTipOwner.addChild(this);
				}
				
				
				// set up label TextField
				_tfLabel.mouseEnabled = false;
				_tfLabel.selectable = false; 
				_tfLabel.defaultTextFormat = txtFormat; 
				_tfLabel.width = 1; 
				_tfLabel.height = 1; 
				_tfLabel.autoSize = TextFieldAutoSize.LEFT; 
				_tfLabel.embedFonts = true; 
				_tfLabel.multiline = false
				_tfLabel.textColor = txtColour; 
				_tfLabel.text = txtLabel;
				
				
				// set up background for the tooltip
				var bgWidth:Number = _tfLabel.width + _horzPadding*2;
				var bgHeight:Number = _tfLabel.height + _vertPadding*2;
				_background.graphics.clear();
				_background.graphics.lineStyle();
				_background.graphics.beginFill(bgColour);
				
				if(bgCorner > 0) // decide of corners should be curved
				{
					_background.graphics.drawRoundRect(0, 0, bgWidth, bgHeight, bgCorner);
				}
				else
				{
					_background.graphics.drawRect(0, 0, bgWidth, bgHeight);
				}					
				_background.graphics.endFill();
				
				// draw arrow if needed
				if(showTail > 0)
				{
					_background.graphics.lineStyle();
					_background.graphics.beginFill(bgColour);
					_background.graphics.moveTo((bgWidth - showTail)/2, bgHeight);
					_background.graphics.lineTo((bgWidth - showTail)/2 + showTail, bgHeight);
					_background.graphics.lineTo(bgWidth/2, bgHeight+showTail/2);
					_background.graphics.lineTo((bgWidth - showTail)/2, bgHeight);
					_background.graphics.endFill();
				}
				
				_background.filters = [_dropShadow]; // add dropshadow to the background
				
				// position background
				_background.x = 0;
				_background.y = 0;			
				_background.alpha = bgAlpha;
				
				// add tool tip bg
				if(! this.contains(_background))
				{
					this.addChild(_background);
				}
				
				// position and add label TextField
				_tfLabel.x = _horzPadding;
				_tfLabel.y = _vertPadding;
				
				// add tool tip label
				if(! this.contains(_tfLabel))
				{
					this.addChild(_tfLabel);
				}
				
				// position tooltip
				positionTooltip(_toolTipOwner.mouseX, _toolTipOwner.mouseY)
				
				// add listener so tooltip follows mouse
				stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove_handler, false, 0, true);
			}
		}
		
		
		/**
		 * Function moves the toolTip with the mouse if still hovering over the owner DisplayObject
		 * 
		 * @see positionTooltip()
		 *  
		 * @param event
		 */		
		private function onMouseMove_handler(event:MouseEvent):void
		{
			positionTooltip(event.stageX, event.stageY);
		}
		
		/**
		 * Function positions the tooltip at the current mouse position with respect to its owner 
		 * 
		 * @param mouseXpos
		 * @param mouseYPos
		 */		
		private function positionTooltip(mouseXpos:Number, mouseYPos:Number):void
		{
			this.x = Math.round(mouseXpos) - this.width/2; 
			this.y = Math.round(mouseYPos) - this.height;
			
			if(this.x < 0)
			{
				this.x = 0;
			}
			
			if(this.x + this.width >= stage.stageWidth)
			{
				this.x = stage.stageWidth - this.width;
			}
			
			if(this.y < 0)
			{
				this.y = 0;
			}
			
			if(this.y  + this.height >= stage.stageHeight)
			{
				this.y = stage.stageHeight - this.height;
			}
		}
		
		
		
		/**
		 * Function removes the Tool Tip from the display
		 * 
		 */		
		public function removeToolTip():void 
		{ 
			if(_toolTipOwner != null)
			{
				// removes stage listener
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove_handler);
				
				// removes label TextField
				if(this.contains(_tfLabel))
				{
					this.removeChild(_tfLabel);
				}
				
				// removes background
				_background.graphics.clear();
				if(this.contains(_background))
				{
					this.removeChild(_background);
				}
				
				// removes this object from owner display obj
				if(_toolTipOwner.contains(this))
				{
					_toolTipOwner.removeChild(this);
				}
				
				
				_toolTipOwner = null;
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
		trace("ToolTip_PS:SingletonEnforcer called");
	}
}