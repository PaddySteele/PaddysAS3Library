package com.patricksteele.gui
{
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * This class defines a button.
	 * 
	 * <p>TODO: positioning of text is not perfect for some reason. seems too low.</p>
	 * 
	 * <p>Uses Button_PS which is a linked MovieClip in the Fla Library.</p>
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * @date 04.10.2010
	 * 
	 * @example Below is an example of how a button would be created
	 * <listing version="3.0">
	 * 
	 * // set up TextFormat
	 * 	var font:Font = new EmbeddedFont(); // linked from fla library
	 *	var myTextFormat:TextFormat = new TextFormat();
	 * 	myTextFormat.font = font.fontName;
	 * 	myTextFormat.size = 12;
	 * 	myTextFormat.align = TextFormatAlign.LEFT;
	 * 
	 * var myBtn:Button_PS = new Button_PS("click me", myTextFormat, 0x000000, 0xFFFFFF, 0xFFFFFF);
	 * addChild(myBtn);
	 * 
	 * </listing>
	 * 
	 */	
	public class Button_PS extends MovieClip
	{
		/**
		 * The mcButton_PS MovieClip that represents the custom btn.
		 * 
		 * <p>The mcButton_PS MovieClip is a linked MovieClip in the Fla library.</p>
		 */		
		private var _mcButton_PS:mcButton_PS;
		
		/**
		 * the btns current state.
		 * 0 = mouse off, 1 = mouse over, 2 = mouse down
		 */		
		private var _state:Number = 0;
		
		/**
		 * string label for btn
		 */		
		private var _strLabel:String;
		
		/**
		 * an id for the btn 
		 */		
		private var _id:Number;
		
		/**
		 * an array containing the colours for the off, over and down states of the btn 
		 */		
		private var _arrLabelCols:Array;
		
		/**
		 * TextField for displaying the button label 
		 */		
		private var _lblTextField:TextField;
		
		/**
		 * text Format for formatting the _lblTextField TextField 
		 */		
		private var _lblFormat:TextFormat;
		
		/**
		 * the padding between the label TextFild and the bg edges 
		 */		
		private var _lblPadding:Number = 10;
		
		/**
		 * if the button is currently active.
		 */		
		private var _active:Boolean = false;
		
		/**
		 * the alpha of _mcButton_PS if the button is not active
		 */		
		private var _inactiveAlpha:Number = 0.7;
		

		/**
		 * CONSTRUCTOR
		 * 
		 * @param strLabel		The text label fot the button
		 * @param id			An ID for the btn
		 * @param lblFormat		TextFormat for ddisplaying the button label
		 * @param lblOffColour	Colour of label text when mouse is off button
		 * @param lblOverColour	Colour of label text when mouse is over button
		 * @param lblClickColour	Colour of label text when mouse is pusiing down on button
		 * 
		 */		
		public function Button_PS(strLabel:String, id:Number, lblFormat:TextFormat, lblOffColour:uint = 0xFFFFFF, lblOverColour:uint = 0xFFFFFF, lblClickColour:uint = 0xFFFFFF)
		{
			super();
			
			// set instance vars
			_arrLabelCols = [lblOffColour, lblOverColour, lblClickColour];			
			_strLabel = strLabel;
			_lblFormat = lblFormat;
			_id = id;
			
			this.mouseChildren = false;
			
			// set up the initial btn
			init();
		}
		 
		/**
		 * function sets up the initial btn 
		 */		
		private function init():void
		{
			// create label textField
			_lblTextField = new TextField();			
			_lblTextField.defaultTextFormat = _lblFormat;
			_lblTextField.embedFonts = true;			
			_lblTextField.antiAliasType = AntiAliasType.ADVANCED; //AntiAliasType.NORMAL;
			_lblTextField.autoSize = TextFieldAutoSize.LEFT;
			_lblTextField.textColor = _arrLabelCols[_state];			
			_lblTextField.selectable = false;			
			_lblTextField.multiline = false;
			_lblTextField.wordWrap = false;
			_lblTextField.border = true;
			_lblTextField.htmlText = _strLabel;
			_lblTextField.autoSize = TextFieldAutoSize.LEFT;
			
			// create the MC that displays btn bg's		
			_mcButton_PS = new mcButton_PS();
			_mcButton_PS.mouseEnabled = false;
			_mcButton_PS.mouseChildren = false;
			
			// scale the btn to match the label tf
			_mcButton_PS.width = _lblPadding*2 + _lblTextField.width;
			_mcButton_PS.height = _lblPadding*2 + _lblTextField.height;
			addChild(_mcButton_PS);
			
			// add label tf
			_lblTextField.x = _lblPadding;
			_lblTextField.y = _lblPadding;
			addChild(_lblTextField);
			_lblTextField.mouseEnabled = false;
			
			
			// By default the btn is intially in mouse off state. 
			_state = 0;			
			_mcButton_PS.btnOffState.alpha = 1;
			_mcButton_PS.btnOnState.alpha = 0;
			_mcButton_PS.btnDownState.alpha = 0;
			
			activate(true);
		}
		
		
		/**
		 * Function returns the ID of the btn 
		 * @return 
		 * 
		 */		
		public function getID():Number
		{
			return _id;
		}
		
		
		
		/**
		 * function activates or deactivates a button setting up mouse behaviour
		 * 
		 * @param ifActive If the button should be activated
		 * 
		 */		
		public function activate(ifActive:Boolean):void
		{
			
			if(ifActive)
			{
				this.addEventListener(MouseEvent.MOUSE_OVER, _mcButton_PS_mouseOverHandler);
				this.addEventListener(MouseEvent.MOUSE_OUT, _mcButton_PS_mouseOutHandler);
				this.addEventListener(MouseEvent.MOUSE_DOWN, _mcButton_PS_mouseDownHandler);
				this.addEventListener(MouseEvent.MOUSE_UP, _mcButton_PS_mouseUpHandler);
				_active = true;
				_mcButton_PS.alpha = 1;
				this.mouseEnabled = true;
				this.buttonMode = true;
			}
			else
			{
				this.removeEventListener(MouseEvent.MOUSE_OVER, _mcButton_PS_mouseOverHandler);
				this.removeEventListener(MouseEvent.MOUSE_OUT, _mcButton_PS_mouseOutHandler);
				this.removeEventListener(MouseEvent.CLICK, _mcButton_PS_mouseDownHandler);
				this.removeEventListener(MouseEvent.MOUSE_UP, _mcButton_PS_mouseUpHandler);
				_mcButton_PS.btnOffState.alpha = 1;
				_mcButton_PS.btnOnState.alpha = 0;
				_mcButton_PS.btnDownState.alpha = 0;
				_state = 0;
				_lblTextField.textColor = _arrLabelCols[_state];				
				_active = false;
				_mcButton_PS.alpha = _inactiveAlpha;
				this.mouseEnabled = false;
				this.buttonMode = false;
			}
		}
		
		
		
		/**
		 * function handles what happens when mouse moves over _mcButton_PS 
		 * @param event
		 * 
		 */		
		private function _mcButton_PS_mouseOverHandler(event:MouseEvent):void
		{
			_state = 1; 
			_lblTextField.textColor = _arrLabelCols[_state];	
			
			_mcButton_PS.btnOffState.alpha = 0;
			_mcButton_PS.btnOnState.alpha = 1;
			_mcButton_PS.btnDownState.alpha = 0;
		}
		
		/**
		 * function handles what happens when mouse moves off _mcButton_PS 
		 * @param event
		 * 
		 */		
		private function _mcButton_PS_mouseOutHandler(event:MouseEvent):void
		{
			_state = 0; 
			
			_lblTextField.textColor = _arrLabelCols[_state];	
			
			_mcButton_PS.btnOffState.alpha = 1;
			_mcButton_PS.btnOnState.alpha = 0;
			_mcButton_PS.btnDownState.alpha = 0;
		}
		
		/**
		 * function handles what happens when mouse is pressed on _mcButton_PS 
		 * @param event
		 * 
		 */		
		private function _mcButton_PS_mouseDownHandler(event:MouseEvent):void
		{
			_state = 2; 
			
			_lblTextField.textColor = _arrLabelCols[_state];	
			
			_mcButton_PS.btnOffState.alpha = 0;
			_mcButton_PS.btnOnState.alpha = 0;
			_mcButton_PS.btnDownState.alpha = 1;
		}

		
		/**
		 * function handles what happens when mouse is released on _mcButton_PS 
		 * @param event
		 * 
		 */		
		private function _mcButton_PS_mouseUpHandler(event:MouseEvent):void
		{
			_state = 1; 
			
			_lblTextField.textColor = _arrLabelCols[_state];	
			
			_mcButton_PS.btnOffState.alpha = 0;
			_mcButton_PS.btnOnState.alpha = 1;
			_mcButton_PS.btnDownState.alpha = 0;
		}
		
	}
}