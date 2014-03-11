package com.patricksteele.gui
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * Class defines a button with just text, similar to a normal weblink. The button can have on off and selected text colours
	 * 
	 * <p>When ebabled the button responds to mouse over and off to change its text colour. The button
	 *  can also be disabled and can have a 3rd 'selected' colour set</p>
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 * @example See below for an example usage
	 * <listing version="3.0">
	 * 	package 
	 * 	{ 
	 * 		import flash.display.Sprite;	
	 * 		import flash.events.MouseEvent;
	 * 		import flash.text.TextFormat;
	 * 
	 * 		public class TextBtnExample extends Sprite 
	 * 		{ 
	 * 			private var _btnA:TextButton_PS;
	 * 			private var _btnB:TextButton_PS;
	 * 
	 * 			private var _arrBtns:Array;
	 * 
	 * 			public function TextBtnExample()
	 * 			{
	 * 				_arrBtns = new Array();			
	 * 	
	 * 				var myTF:TextFormat = new TextFormat("Arial", 12);
	 * 				
	 * 				_btnA = new TextButton_PS("News", 1, 0x000000, 0x0000FF, 0xCCCCCC, myTF, false, false);
	 * 				addChild(_btnA);
	 * 				_arrBtns.push(_btnA);
	 * 
	 * 				_btnB = new TextButton_PS("Contact", 1, 0x000000, 0x0000FF, 0xCCCCCC, myTF, false, false);
	 * 				addChild(_btnB);
	 * 				_arrBtns.push(_btnB);
	 * 
	 * 				for(var i:Number = 0; i < _arrBtns.length; i++)
	 * 				{
	 * 					_arrBtns[i].addEventListener(MouseEvent.CLICK, btn_clickHandler);
	 * 				}
	 * 			}
	 * 
	 *			private function btn_clickHandler(event:MouseEvent):void
	 * 			{
	 * 				for(var i:Number = 0; i < _arrBtns.length; i++)
	 * 				{
	 * 					if(_arrBtns[i] == event.target)
	 * 					{
	 * 						_arrBtns[i].enable(false);
	 * 					}
	 * 					else
	 * 					{
	 * 						_arrBtns[i].enable(true);
	 * 					}
	 * 				}
	 * 
	 * 				// do anything else required
	 * 			}
	 * 
	 * 		}
	 *	}
	 * </listing> 
	 * 
	 */	
	public class TextButton_PS extends Sprite
	{
		/**
		 * an id for the btn 
		 */		
		private var _btnId:Number;
		
		/**
		 * the Text to display on the button 
		 */		
		private var _strBtnLabel:String;
		
		/**
		 * the TextField to display the buttons text 
		 */		
		private var _tfBtnLabel:TextField;
		
		/**
		 * a Sprite to contain an optional underline for when the mouse is over the button 
		 */		
		private var _underline:Sprite;
		
		/**
		 * if the underline should be shown 
		 */		
		private var _showUnderline:Boolean = false;
		
		/**
		 * if button is currently enabled. Ie has mouse interactivity set up
		 */		
		private var _ifEnabled:Boolean = false;
		
		/**
		 * the colours of the button text for its different states 
		 */		
		private var _onCol:uint;
		private var _offCol:uint;
		private var _disabledCol:uint;

		
		/**
		 * Constructor
		 *  
		 * @param strLabel		Text to displa on btn
		 * @param id			ID for btn		 
		 * @param offCol		Color when mouse is not over btn
		 * @param onCol			Color when mouse is over btn
		 * @param disabledCol	Color when btn has been disabled due to selection
		 * @param btnTextFormat	TextFormat for btn text
		 * @param ifEmbedFonts	If font specified by btnTextFormat TextFormat should be embedded
		 * @param underline	If btn requres an underline when the mouse is over it
		 * 
		 */		
		public function TextButton_PS(strLabel:String, id:Number, offCol:uint, onCol:uint, disabledCol:uint, btnTextFormat:TextFormat, ifEmbedFonts:Boolean = true, underline:Boolean = false)
		{
			_strBtnLabel = strLabel;
			_btnId = id;
			
			_onCol = onCol;
			_offCol = offCol;
			_disabledCol = disabledCol;
			
			_showUnderline = underline;

			// set up btn textfield
			_tfBtnLabel = new TextField();
			_tfBtnLabel.defaultTextFormat = btnTextFormat;
			_tfBtnLabel.textColor = offCol;
			_tfBtnLabel.embedFonts = ifEmbedFonts;
			_tfBtnLabel.antiAliasType = AntiAliasType.ADVANCED;
			_tfBtnLabel.autoSize = TextFieldAutoSize.LEFT;
			_tfBtnLabel.selectable = false;
			_tfBtnLabel.multiline = false;
			_tfBtnLabel.wordWrap = false;
			_tfBtnLabel.htmlText = strLabel;
			addChild(_tfBtnLabel);
			
			// optional underline for mouse over state
			_underline = new Sprite();
			
			if(_showUnderline)
			{
				_underline.graphics.lineStyle(1,onCol);
				_underline.graphics.moveTo(0, 0);
				_underline.graphics.lineTo(_tfBtnLabel.textWidth, 0);
				_underline.visible = false;
				_underline.x = (_tfBtnLabel.width - _underline.width)/2;
				_underline.y = _tfBtnLabel.height;
				addChild(_underline);
			}
			
			
			// set mouse up behaviour and listeners
			this.mouseChildren = false;				
			enable(true);
		}
		
		/**
		 * Function enables or disables the btns mouse behaviours 
		 * 
		 * @param turnOn	If the button should be enabled
		 * 
		 */		
		public function enable(turnOn:Boolean):void
		{
			if(_ifEnabled != turnOn)
			{
				_ifEnabled = turnOn;
				
				if(_ifEnabled)
				{
					this.addEventListener(MouseEvent.MOUSE_OVER, rollOver_handler, false, 0, true);
					this.addEventListener(MouseEvent.MOUSE_OUT, rollOff_handler, false, 0, true);
					this.buttonMode = true;
					_tfBtnLabel.textColor = _offCol;
				}
				else
				{
					this.removeEventListener(MouseEvent.MOUSE_OVER, rollOver_handler);
					this.removeEventListener(MouseEvent.MOUSE_OUT, rollOff_handler);
					this.buttonMode = false;
					_tfBtnLabel.textColor = _disabledCol;
				}
			}
		}
		
		
		/**
		 * Function handles what happens when the mouse rolls over the btn 
		 * @param event
		 * 
		 */		
		private function rollOver_handler(event:MouseEvent):void
		{
			if(_ifEnabled)
			{
				_tfBtnLabel.textColor = _onCol;
				if(_showUnderline) _underline.visible = true;
			}
		}
		
		/**
		 * Function handles what happens when the mouse rolls off the btn 
		 * @param event
		 * 
		 */	
		private function rollOff_handler(event:MouseEvent):void
		{
			if(_ifEnabled)
			{
				_tfBtnLabel.textColor = _offCol;
				if(_showUnderline) _underline.visible = false;
			}
		}
		
		/**
		 * Function returns the id of btn. 
		 * @return 
		 * 
		 */		
		public function getId():Number
		{
			return _btnId;			
		}
		

		
		
		/**
		 * Function returns if the btn is currently enabled
		 *  
		 * @return 
		 * 
		 */		
		public function ifEnabled():Boolean
		{
			return _ifEnabled;
		}
		
		
	}
}