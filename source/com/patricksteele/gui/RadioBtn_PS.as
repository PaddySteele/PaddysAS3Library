package com.patricksteele.gui
{
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * This class defines a custom radio btn. A group of RadioBtn_PS objects are managed and
	 * controlled by a RadioBtnGroup_PS object.
	 * 
	 * <p> for a RadioBtn_PS or a group of RadioBtn_PS's to work properly they must be associated
	 * with a RadioBtnGroup_PS object.</p>
	 * 
	 * <p>Uses mcRadioBtn_PS which is a linked MovieClip in the Fla Library.</p>
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * @date 01.10.2010
	 * 
	 * @see RadioBtnGroup_PS
	 * 
	 * @example Below is an example of how a group of the radio btn's would be used
	 * <listing version="3.0">
	 * 
	 * var radioBtnA:RadioBtn_PS = new RadioBtn_PS("Liverpool FC",true);
	 * addChild(radioBtnA);
	 * radioBtnA.x = 100;
	 * 
	 * var radioBtnB:RadioBtn_PS = new RadioBtn_PS("Manchester United FC",true);
	 * addChild(radioBtnB);
	 * radioBtnB.x = 200;
	 * 
	 * var radioBtnC:RadioBtn_PS = new RadioBtn_PS("Chelsea FC",true);
	 * addChild(radioBtnC);
	 * radioBtnC.x = 300;
	 * 
	 * var radioBtnManager:RadioBtnGroup_PS = new RadioBtnGroup_PS();
	 * radioBtnManager.addRadioBtn(radioBtnA, true);
	 * radioBtnManager.addRadioBtn(radioBtnB);
	 * radioBtnManager.addRadioBtn(radioBtnC);
	 * 
	 * </listing>
	 * 
	 */	
	public class RadioBtn_PS extends MovieClip
	{
		/**
		 * The mcRadioBtn_PS MovieClip that represents the radio btn.
		 * 
		 * <p>The mcRadioBtn_PS MovieClip is a linked MovieClip in the Fla library.</p>
		 */		
		private var _mcRadioBtn_PS:mcRadioBtn_PS;
		
		/**
		 * if the radio btn is currently selected.
		 */		
		private var _selected:Boolean = false;
		
		/**
		 * allows a value to be assigned to a radio btn 
		 */		
		private var _value:String;
		
		/**
		 * if the radio btn dot should be faded in and out when radio btn is selected/deselected
		 */		
		private var _fadeDot:Boolean = true;
		
		/**
		 * the time it takes to fade in and out the dot if _fadeDot = true
		 */		
		private var _fadeSpeed:Number = 0.2;
		
		
			
		/**
		 * CONSTRUCTOR
		 * 
		 * @param value		The value assigned to a radio btn
		 * 
		 * @param fadeDot	If the dot should be faded in and out when radio btn is
		 * 	clicked or if it should just appear and disappear. Default = true
		 * 
		 */		
		public function RadioBtn_PS(value:String, fadeDot:Boolean = true)
		{
			super();
						
			// set instance vars
			_value = value;
			_fadeDot = fadeDot;
			
			// set up the initial radio btn
			init();
		}
		
		/**
		 * function sets up the initial radio btn 
		 */		
		private function init():void
		{
			// create the MC that displays radio btn and dot			
			_mcRadioBtn_PS = new mcRadioBtn_PS();
			_mcRadioBtn_PS.mouseEnabled = false;
			_mcRadioBtn_PS.mouseChildren = false;
			addChild(_mcRadioBtn_PS);
			

			// By default the radio btn is intially unselected. 
			// This can be changed via setInitialRadioBtnState() function.
			_selected = false;			
			_mcRadioBtn_PS.mcDot.alpha = 0;
			
		}
		

		
		
		/**
		 * Function sets if the radio btn is selected or not.
		 *  
		 * @param ifSelected If the radio btn should be selected
		 * 
		 */		
		public function setRadioBtnState(ifSelected:Boolean):void
		{
			if(_selected != ifSelected) // if new state is different
			{
				_selected = ifSelected;
				
				if(_selected) // show dot
				{
					if(_fadeDot)
					{
						TweenLite.to(_mcRadioBtn_PS.mcDot, _fadeSpeed/2, {alpha:1, ease:Cubic.easeOut});
					}
					else
					{
						_mcRadioBtn_PS.mcDot.alpha = 1;
					}
					
					trace("Selected RadioBtn_PS value:" + getValue());
					
				}
				else // hide dot
				{
					if(_fadeDot)
					{
						TweenLite.to(_mcRadioBtn_PS.mcDot, _fadeSpeed, {alpha:0, ease:Cubic.easeOut});
					}
					else
					{
						_mcRadioBtn_PS.mcDot.alpha = 0;
					}					
				}					
			}			
		}
		
		
		

		/**
		 * Function sets if a radio btn is initally selected.
		 * 
		 * <p>This function is provided as an alternative to <code>setRadioBtnState()</code> as
		 * it allows dot to be displayed without fading even if _fadeDot = true
		 *  
		 * @param ifSelected If the radio btn should be selected
		 * 
		 */	
		public function setInitialRadioBtnState(ifSelected:Boolean):void
		{
			if(ifSelected)
			{
				_selected = true;			
				_mcRadioBtn_PS.mcDot.alpha = 1;
			}
			else
			{
				_selected = false;			
				_mcRadioBtn_PS.mcDot.alpha = 0;
			}
		}
		
		
		
		
		/**
		 * function returns if the radio btn is currently selected or not
		 * @return 
		 * 
		 */		
		public function ifSelected():Boolean
		{
			return _selected;
		}
		
		
		/**
		 * Function returns a radio btn's assigned value 
		 * @return 
		 * 
		 */		
		public function getValue():String
		{
			return _value;
		}
		
	}
}