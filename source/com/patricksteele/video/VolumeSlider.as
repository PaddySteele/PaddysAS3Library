package com.patricksteele.video
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * Class defines a volume slider
	 * 
	 * @author Patrick Steele
	 * @date 11.03.2010
	 * 
	 */	
	public class VolumeSlider extends Sprite
	{
		/**
		 * background for the slider 
		 */		
		private var _bg:Sprite;
		
		
		
		/**
		 * The faded bg slope that shows the max the vol slider can go up to
		 */		
		private var _guideSlope:Sprite;
		
		/**
		 * the vol slope that is used to show the current vol 
		 */		
		private var _volSlope:Sprite;
		
		/**
		 * the mask for the _volSlope
		 */				
		private var _mask:Sprite;

		
		
		/**
		 * Timer used 
		 */		
		private var _volSliderTimer:Timer;
		
		
		
		/**
		 * btn dimensions 
		 */		
		private var _btnHeight:Number;
		private var _btnWidth:Number;
		
			
		/**
		 * CONSTRUCTOR 
		 * 
		 * @param btnWidth
		 * @param btnHeight
		 * 
		 */		
		public function VolumeSlider(btnWidth:Number, btnHeight:Number):void
		{
			_btnWidth = btnWidth;
			_btnHeight = btnHeight;
			
			// draw btn background
			_bg = new Sprite();
			_bg.graphics.lineStyle();
			_bg.graphics.beginFill(VideoPlayerStyling.vpBtnBgCol);
			_bg.graphics.drawRect(0, 0, _btnWidth, _btnHeight);
			_bg.graphics.endFill();
			addChild(_bg);
			
			// calc vars for sizing the play/pause symbols
			var symbolW:Number = _btnWidth - 10;
			var symbolH:Number = _btnHeight/2;			
			var paddingX:Number = (_btnWidth - symbolW)/2;
			var paddingY:Number = (_btnHeight - symbolH)/2;
			
			// draw the guide vol slope
			_guideSlope = new Sprite();
			_guideSlope.graphics.beginFill(VideoPlayerStyling.vpBtnOffCol);
			_guideSlope.graphics.moveTo(0,symbolH);
			_guideSlope.graphics.lineTo(symbolW, symbolH);
			_guideSlope.graphics.lineTo(symbolW, 0);
			_guideSlope.graphics.lineTo(0,symbolH);
			_guideSlope.graphics.endFill();
			_guideSlope.x = (_btnWidth - _guideSlope.width)/2;
			_guideSlope.y = (_btnHeight - _guideSlope.height)/2;
			addChild(_guideSlope);
			
			// draw the volume slope		
			_volSlope = new Sprite();
			_volSlope.graphics.beginFill(VideoPlayerStyling.vpBtnOnCol);
			_volSlope.graphics.moveTo(0,symbolH);
			_volSlope.graphics.lineTo(symbolW, symbolH);
			_volSlope.graphics.lineTo(symbolW, 0);
			_volSlope.graphics.lineTo(0,symbolH);
			_volSlope.graphics.endFill();
			_volSlope.x = (_btnWidth - _volSlope.width)/2;
			_volSlope.y = (_btnHeight - _volSlope.height)/2;
			addChild(_volSlope);
			
			
			_mask = new Sprite();
			// draw a placeholder/bg the same size as Image to be loaded
			_mask.graphics.clear();
			_mask.graphics.lineStyle();
			_mask.graphics.beginFill(0x000000);
			_mask.graphics.drawRect(0, 0, btnWidth, btnHeight);
			_mask.graphics.endFill();
			addChild(_mask);
			
			_volSlope.mask = _mask;
			
			
			_volSlope.mouseEnabled = false;
			//_guideSlope.buttonMode = true;
			
			
			// create the Timers needed for the vol slider
			_volSliderTimer = new Timer(100);
			
			_guideSlope.addEventListener(MouseEvent.MOUSE_DOWN, startVolDrag_handler);
			
			// set up Timer used to display the progressive load progress for a flv file
			_volSliderTimer.addEventListener(TimerEvent.TIMER, volSliderTimer_handler);
			
		}
		
		
		/**
		 * function starts the dragging of the volume slider 
		 * @param event
		 * 
		 */		
		private function startVolDrag_handler(event:MouseEvent):void
		{
			this.addEventListener(MouseEvent.MOUSE_UP, stopVolDrag_handler);
			_guideSlope.addEventListener(MouseEvent.MOUSE_UP, stopVolDrag_handler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopVolDrag_handler);
			

			_volSliderTimer.start();
		}
		
		
		
		/**
		 * function stops the dragging of the volume slider 
		 * @param event
		 * 
		 */		
		private function stopVolDrag_handler(event:MouseEvent):void
		{
			this.removeEventListener(MouseEvent.MOUSE_UP, stopVolDrag_handler);
			_guideSlope.removeEventListener(MouseEvent.MOUSE_UP, stopVolDrag_handler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopVolDrag_handler);
			
			_volSliderTimer.stop();
		}
		
		
		/**
		 * This function updates the _loadProgressBar to display the load progress of the video file 
		 * loaded in the _parent VideoPlayer
		 * @param event
		 * 
		 */
		private function volSliderTimer_handler(event:TimerEvent):void
		{
			var xPos:Number = _guideSlope.mouseX;

			if(xPos > _guideSlope.width)
			{
				//xPos = _guideSlope.width;
			}
			
			if(xPos < 0)
			{
				xPos = 0;
			}
			
			// update _playProgressBar width
			var newVolWidth:Number = xPos;
			_mask.width = newVolWidth;
			/* 
			// set new position of playhead in _parent VideoPlayer
			var progressRatio:Number = xPos/_progressBarWidth;			
			var newPlayHeadPosition:Number = progressRatio * _parent.getVideoDuration();
			_parent.seekToPosition(newPlayHeadPosition);
			 */
		
		}
		
	
		
	}
}