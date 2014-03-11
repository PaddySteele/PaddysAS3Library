package com.patricksteele.video
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	/**
	 * Class defines a rewind btn for use in a video or audio player 
	 * 
	 * @author Patrick Steele
	 * @date 11.03.2010
	 * 
	 */	
	public class RewindBtn extends Sprite
	{
		/**
		 * background for the btn 
		 */		
		private var _bg:Sprite;
		
		/**
		 * rewind symbol will be drawn into this Sprite
		 */		
		private var _rewindSymbol:Sprite;
		
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
		public function RewindBtn(btnWidth:Number, btnHeight:Number):void
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
			var symbolW:Number = _btnWidth/2;
			var symbolH:Number = _btnHeight/2;			
			var paddingX:Number = (_btnWidth - symbolW)/2;
			var paddingY:Number = (_btnHeight - symbolH)/2;
			
			
			// draw play symbol
			_rewindSymbol = new Sprite();
			_rewindSymbol.graphics.beginFill(VideoPlayerStyling.vpBtnOffCol);
			
			// vertical line
			_rewindSymbol.graphics.moveTo(0, 0);
			_rewindSymbol.graphics.lineTo(1, 0);
			_rewindSymbol.graphics.lineTo(1, symbolH);
			_rewindSymbol.graphics.lineTo(0, symbolH);
			_rewindSymbol.graphics.lineTo(0, 0);
			
			// first arrow
			_rewindSymbol.graphics.moveTo(symbolW/2,0);
			_rewindSymbol.graphics.lineTo(symbolW/2, symbolH);
			_rewindSymbol.graphics.lineTo(1, symbolH/2);
			_rewindSymbol.graphics.lineTo(symbolW/2,0);
			
			// second arrow
			_rewindSymbol.graphics.moveTo(symbolW,0);
			_rewindSymbol.graphics.lineTo(symbolW, symbolH);
			_rewindSymbol.graphics.lineTo(symbolW/2, symbolH/2);
			_rewindSymbol.graphics.lineTo(symbolW,0);
			
			_rewindSymbol.x = (_btnWidth - _rewindSymbol.width)/2;
			_rewindSymbol.y = (_btnHeight - _rewindSymbol.height)/2;
			addChild(_rewindSymbol); 
			
			
			// add event listeners for roll-on and roll-off events
			this.addEventListener(MouseEvent.MOUSE_OVER, rollOver_handler);
			this.addEventListener(MouseEvent.MOUSE_OUT, rollOff_handler);
			
			this.mouseChildren = false;
			this.buttonMode = true;
		}
		
		
		/**
		 * function handles what happens when the mouse rolls over this btn 
		 * @param event
		 * 
		 */		
		private function rollOver_handler(event:MouseEvent):void
		{
			var colorTransform:ColorTransform = _rewindSymbol.transform.colorTransform;
			colorTransform.color = VideoPlayerStyling.vpBtnOnCol;
			_rewindSymbol.transform.colorTransform = colorTransform;
		}
		
		
		/**
		 * function handles what happens when the mouse rolls off this btn 
		 * @param event
		 * 
		 */		
		private function rollOff_handler(event:MouseEvent):void
		{
			var colorTransform:ColorTransform = _rewindSymbol.transform.colorTransform;
			colorTransform.color = VideoPlayerStyling.vpBtnOffCol;
			_rewindSymbol.transform.colorTransform = colorTransform;
			

		}
		
	}
}