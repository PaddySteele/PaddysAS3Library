package com.patricksteele.gui
{
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	
	/**
	 * This class defines a custom check box.
	 * 
	 * <p>Uses mcCheckBox_PS which is a linked MovieClip in the Fla Library.</p>
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * @date 30.09.2010
	 * 
	 * @example Below is an example of the check box would be used
	 * <listing version="3.0">
	 * 
	 * var chkBox:CheckBox_PS = new CheckBox_PS(true,true);
	 * addChild(chkBox);
	 * 
	 * </listing>
	 * 
	 */	
	public class CheckBox_PS extends MovieClip
	{
		/**
		 * The mcCheckBoxPS MovieClip that represents the check box.
		 * 
		 * <p>The mcCheckBox_PS MovieClip is a linked MovieClip in the Fla library.</p>
		 */		
		private var _mcCheckBox_PS:mcCheckBox_PS;
		
		/**
		 * if the check box is currently selected. ie ticked 
		 */		
		private var _selected:Boolean = false;
		
		/**
		 * if the tick should be faded in and out when check box is selected/deselected
		 */		
		private var _fadeTick:Boolean = true;
		
		/**
		 * the time it takes to fade in and out the tick if _fadeTick = true
		 */		
		private var _fadeSpeed:Number = 0.2;
		
		/**
		 * if the check box is currently active.
		 */		
		private var _active:Boolean = false;
		
		/**
		 * the alpha of _mcCheckBox_PS if the check box is not active
		 */		
		private var _inactiveAlpha:Number = 0.7;
		
		
		/**
		 * CONSTRUCTOR
		 * 
		 * @param ifActive If the check box should be initially activated
		 * 
		 * @param fadeTick If the tick should be faded in and out when check box is
		 * 	clicked or if it should just appear and disappear. Default = true
		 * 
		 */		
		public function CheckBox_PS(ifActive:Boolean, fadeTick:Boolean = true)
		{
			super();
			
			// set instance vars
			_active = ifActive;
			_fadeTick = fadeTick;
			
			// set up the initial check box
			init();
		}
		
		/**
		 * function sets up the initial check box 
		 */		
		private function init():void
		{
			// create MC that displays check box and tick			
			_mcCheckBox_PS = new mcCheckBox_PS();
			addChild(_mcCheckBox_PS);
			
			// set if check box is initially active
			activate(_active);
			
			// By default checkbox is intially unselected/unticked. This can be changed 
			// via initiallySelect() function.
			_selected = false;			
			_mcCheckBox_PS.mcTick.alpha = 0;
			
		}
		
		

		/**
		 * function activates or deactivates a check box by setting up mouse behaviour
		 * 
		 * @param ifActive If the check box should be activated
		 * 
		 */		
		public function activate(ifActive:Boolean):void
		{
			if(ifActive)
			{
				_mcCheckBox_PS.addEventListener(MouseEvent.CLICK, clickHandler, false, 0, true);
				_active = true;
				_mcCheckBox_PS.alpha = 1;
				_mcCheckBox_PS.buttonMode = true;
			}
			else
			{
				_mcCheckBox_PS.removeEventListener(MouseEvent.CLICK, clickHandler);
				_active = false;
				_mcCheckBox_PS.alpha = _inactiveAlpha;
				_mcCheckBox_PS.buttonMode = false;
			}
		}
		
		
		
		/**
		 * Function handles what happens when a user clicks the check box 
		 * @param event
		 * 
		 */		
		public function clickHandler(event:MouseEvent):void
		{
			// chamge check box state
			setCheckBoxState(!_selected);
			
			trace("CheckBox_PS._selected = " + _selected);
		}
		

		
		/**
		 * Function sets if the check box is selected or not. ie. if it is ticked
		 *  
		 * @param ifSelected If the check box should be selected/ticked
		 * 
		 */		
		public function setCheckBoxState(ifSelected:Boolean):void
		{
			if(_selected != ifSelected) // if new state is different
			{
				_selected = ifSelected;
				
				if(_selected) // show tick
				{
					if(_fadeTick)
					{
						TweenLite.to(_mcCheckBox_PS.mcTick, _fadeSpeed/2, {alpha:1, ease:Cubic.easeOut});
					}
					else
					{
						_mcCheckBox_PS.mcTick.alpha = 1;
					}					
				}
				else // hide tick
				{
					if(_fadeTick)
					{
						TweenLite.to(_mcCheckBox_PS.mcTick, _fadeSpeed, {alpha:0, ease:Cubic.easeOut});
					}
					else
					{
						_mcCheckBox_PS.mcTick.alpha = 0;
					}					
				}					
			}			
		}
		
		
		
		/**
		 * Function allows an the check box to be initially selected/ticked when it first appears.
		 * 
		 */		
		public function initiallySelect():void
		{
			_selected = true;			
			_mcCheckBox_PS.mcTick.alpha = 1;
		}
		
		
		
		
		/**
		 * function returns if the check box is currently selected or not
		 * @return 
		 * 
		 */		
		public function ifSelected():Boolean
		{
			return _selected;
		}
		
		
	}
}