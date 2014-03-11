package com.patricksteele.gui
{
	import flash.events.MouseEvent;
	
	/**
	 * This class defines a radio btn group. It does not display anything on stage
	 * but acts as a manager for a group of RadioBtn_PS objects 
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * @date 01.10.2010
	 * 
	 * @see RadioBtn_PS
	 * 
	 * @example Below is an example of how a RadioBtnGroup_PS would be used to manage and control
	 * a group of RadioBtn_PS objects
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
	public class RadioBtnGroup_PS
	{
		/**
		 * Array to hold reference to the RadioBtn_PS objects in this radio btn group 
		 */		
		private var _arrRadioBtns:Array;
		
		/**
		 * the index of the currently selected RadioBtn_PS in the array. Initially none are selected
		 */		
		private var _currentlySelectedIndex:Number = -1;
		
		/**
		 * if the radio btn group is currently active and can be interacted with 
		 */		
		private var _active:Boolean = true;
		
		/**
		 * the alpha of of the radio btns if the group is not active
		 */		
		private var _inactiveAlpha:Number = 0.7;
		
		/**
		 * constructor 
		 */		
		public function RadioBtnGroup_PS()
		{
			_arrRadioBtns = new Array();		
		}
		
		
		/**
		 * Function registers a RadioBtn_PS with this group
		 * 
		 * @param radioBtn The radion btn to be added to the group
		 * 
		 */		
		public function addRadioBtn(radioBtn:RadioBtn_PS, ifSelected:Boolean = false):void
		{
			_arrRadioBtns.push(radioBtn);
			
			// if this radio btn is to be initially selected select it and
			// make sure the rest are unselected
			if(ifSelected)
			{
				for(var i:Number = 0; i < _arrRadioBtns.length; i++)
				{
					_arrRadioBtns[i].setInitialRadioBtnState(false);
					
					if(i == _arrRadioBtns.length - 1)
					{
						_arrRadioBtns[i].setInitialRadioBtnState(true);
						_currentlySelectedIndex = i;
					}
				}
			}
			
			if(_active) // if the radio btn group is active activate the btn
			{
				radioBtn.addEventListener(MouseEvent.CLICK, radioBtn_clickHandler, false, 0, true);
				radioBtn.alpha = 1;
				radioBtn.buttonMode = true;
			}
			else
			{
				radioBtn.alpha = _inactiveAlpha;
				radioBtn.buttonMode = false;
			}
		}
		
		
		/**
		 * Function activates or deavtivates a radio btn group 
		 * @param activate
		 * 
		 */		
		public function activateGroup(activate:Boolean):void
		{
			if(_active != activate)
			{
				_active = activate
				
				if(_active)
				{
					for(var i:Number = 0; i < _arrRadioBtns.length; i++)
					{
						_arrRadioBtns[i].addEventListener(MouseEvent.CLICK, radioBtn_clickHandler, false, 0, true);
						_arrRadioBtns[i].alpha = 1;
						_arrRadioBtns[i].buttonMode = true;
					}
				}
				else
				{
					for(var j:Number = 0; j < _arrRadioBtns.length; j++)
					{
						_arrRadioBtns[j].removeEventListener(MouseEvent.CLICK, radioBtn_clickHandler);
						_arrRadioBtns[j].alpha = _inactiveAlpha;
						_arrRadioBtns[j].buttonMode = false;
					}
				}
			}
		}
		
		
		/**
		 * Function handles what happens when a user clicks a radio btn in the group
		 * @param event
		 * 
		 */		
		public function radioBtn_clickHandler(event:MouseEvent):void
		{
			for(var i:Number = 0; i < _arrRadioBtns.length; i++)
			{
				if(_arrRadioBtns[i].getValue() == RadioBtn_PS(event.target).getValue())
				{
					_arrRadioBtns[i].setRadioBtnState(true);
					_currentlySelectedIndex = i;
				}
				else
				{
					_arrRadioBtns[i].setRadioBtnState(false);
				}
			}

		}
		
		/**
		 * Function returns the currently selected radio btn value 
		 * 
		 * @return The currently selected radio btn. Or null if none currently selected
		 * 
		 */		
		public function getSelectedRadioBtn():RadioBtn_PS
		{
			if(_currentlySelectedIndex >= 0 && _currentlySelectedIndex < _arrRadioBtns.length)
			{
				return _arrRadioBtns[_currentlySelectedIndex];
			}
			else
			{
				return null
			}
		}
		
	}
}