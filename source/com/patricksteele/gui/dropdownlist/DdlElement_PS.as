package com.patricksteele.gui.dropdownlist
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	/**
	 * Class defines an element for the drop down list object defined in the DropDownList_PS class. Each element in a ddl represents one
	 * of the available options.
	 * 
	 * <p>Uses mcDdlElement_PS which is a linked MovieClip in the Fla Library. The ddl element can be skinned by editing this linked mc</p>
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com) 
	 */	
	public class DdlElement_PS extends Sprite
	{
		/**
		 * The elements label 
		 */		
		private var _label:String;
		
		/**
		 * The elements value. Typed to Object to allow it to be either a String or a Number
		 */		
		private var _value:Object;
		
		/**
		 * If this element is currently the selected element in its parent ddl 
		 */		
		private var _ifSelected:Boolean = false;
		
		/**
		 * The background for the ddl element. mcDdlElement_PS is a linked mc from the Fla library and has
		 * mouse over, off and down states
		 */		
		private var _mcDdlElementBg:mcDdlElement_PS;
		
		/**
		 * Textfield to display the elements label 
		 */		
		private var _tfLabel:TextField;
		
		/**
		 * Padding between text edges and _mcDdlElementBg edges
		 */		
		private var _txtPaddingTop:Number = 2;
		private var _txtPaddingBottom:Number = 2;
		private var _txtPaddingLeft:Number = 4;
		private var _txtPaddingRight:Number = 4;
		
		/**
		 * Text colours for different states 
		 */		
		private var _txtColOff:uint = 0x000000;
		private var _txtColOver:uint = 0x000000;
		private var _txtColDown:uint = 0x000000;		
		private var _txtSelected:uint = 0x000000;		
		
		/**
		 * ddl element width 
		 */		
		private var _elementWidth:Number;
		

		/**
		 * If the ddl element is currently active 
		 */		
		private var _active:Boolean = false;
		
		
		/**
		 * Constructor
		 *  
		 * @param label			Label to be displayed for the ddl element
		 * @param value			Value for the ddl element
		 * @param txtFormat		TextFormat for the text used in the elements label TextField
		 * @param _ifEmbedFont	If the font from the above TextFormat should be embedded
		 * @param txtColOff		Colour for label text when mouse is not over the element
		 * @param txtColOver	Colour for label text when mouse is over the element
		 * @param txtColDown	Colour for label text when mouse is down on the element
		 * @param txtSelected	Colour for label text when the element is in selected state
		 * 
		 */		
		public function DdlElement_PS(label:String, value:Number, txtFormat:TextFormat, _ifEmbedFont:Boolean, txtColOff:uint = 0x000000, txtColOver:uint = 0x000000, txtColDown:uint = 0x000000, txtSelected:uint = 0x000000)
		{
			_label = label;
			_value = value;
			
			// text cols
			_txtColOff = txtColOff;
			_txtColOver = txtColOver;
			_txtColDown = txtColDown;		
			_txtSelected = txtSelected;
			
			
			// add element bg
			_mcDdlElementBg = new mcDdlElement_PS();
			addChild(_mcDdlElementBg);
			
			// create label TextField
			_tfLabel = new TextField();
			_tfLabel.selectable = false;			
			_tfLabel.multiline = false;
			_tfLabel.wordWrap = false;
			_tfLabel.border = false;
			_tfLabel.embedFonts = _ifEmbedFont;			
			_tfLabel.autoSize = TextFieldAutoSize.LEFT;
			_tfLabel.antiAliasType = AntiAliasType.ADVANCED;
			_tfLabel.defaultTextFormat = txtFormat;
			_tfLabel.text = _label;
			_tfLabel.textColor = _txtColOff;
			addChild(_tfLabel);
			
			// sizing
			_elementWidth = _tfLabel.width + _txtPaddingLeft + _txtPaddingRight;
			_mcDdlElementBg.width = _elementWidth;
			_mcDdlElementBg.height = _tfLabel.height + _txtPaddingTop + _txtPaddingBottom;
			
			// positioning
			_tfLabel.x = _txtPaddingLeft;
			_tfLabel.y = _txtPaddingTop;
			
			this.mouseChildren = false;
		}
		
		/**
		 * Function adjusts the width of the elemnt to the specified size. Allows us to make sure all elements in a drop down
		 * list(DropDownList_PS) are the same width 
		 * 
		 * @param newWidth
		 */		
		public function adjustWidth(newWidth:Number):void
		{
			if(newWidth > _elementWidth)
			{
				_elementWidth = newWidth;
				_mcDdlElementBg.width = _elementWidth;				
			}
		}
		
		
		
		/**
		 * Function activates the mouse over, off and down interactivity for the ddl element
		 * 
		 * @param active
		 */		
		public function activate(active:Boolean):void
		{
			if(active)
			{
				if(!_active)
				{
					this.addEventListener(MouseEvent.MOUSE_OVER, mouseOver_handler, false, 0, true);
					this.addEventListener(MouseEvent.MOUSE_OUT, mouseOut_handler, false, 0, true);
					this.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown_handler, false, 0, true);
				}
			}
			else
			{
				if(_active)
				{
					this.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver_handler);
					this.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut_handler);
					this.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown_handler);
				}
			}
			
			_active = active;			
		}
		
		/**
		 * Function handles what happens when mouse moves over the ddls header element or button
		 * 
		 * @param event
		 */		
		private function mouseOver_handler(event:MouseEvent):void
		{
			_mcDdlElementBg.gotoAndStop("over");
			_tfLabel.textColor = _txtColOver;
		}
		
		/**
		 * Function handles what happens when mouse moves off the ddls header element or button
		 * 
		 * @param event
		 */	
		private function mouseOut_handler(event:MouseEvent):void
		{
			if(!_ifSelected)
			{
				_mcDdlElementBg.gotoAndStop("off");
				_tfLabel.textColor = _txtColOff;
			}
			else
			{
				_mcDdlElementBg.gotoAndStop("selected");
				_tfLabel.textColor = _txtSelected;
			}
		}
		
		/**
		 * Function handles what happens when mouse presses down on the ddls header element or button
		 * 
		 * @param event
		 */	
		private function mouseDown_handler(event:MouseEvent):void
		{
			_mcDdlElementBg.gotoAndStop("down");
			_tfLabel.textColor = _txtColDown;
		}
		
		/**
		 * Function sets this element as its parent ddls currently selected element 
		 * @param select
		 * 
		 */		
		public function setSelected(select:Boolean):void
		{
			_ifSelected = select;
			
			if(!_ifSelected)
			{
				_mcDdlElementBg.gotoAndStop("off");
				_tfLabel.textColor = _txtColOff;
			}
			else
			{
				_mcDdlElementBg.gotoAndStop("selected");
				_tfLabel.textColor = _txtSelected;
			}
		}
		
		/**
		 * Function returns the label for this ddl element 
		 * @return 
		 * 
		 */		
		public function getLabel():String
		{
			return _label;
		}
		
		/**
		 * Function returns the value for this ddl element 
		 * @return 
		 * 
		 */	
		public function getValue():Object
		{
			return _value;
		}
		
	}
}