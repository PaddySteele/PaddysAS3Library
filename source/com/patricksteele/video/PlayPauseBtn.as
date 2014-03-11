package com.patricksteele.video
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	
	/**
	 * Class defines a play/pause btn for use in a video or audio player 
	 * 
	 * @author Patrick Steele
	 * @date 11.03.2010
	 * 
	 */	
	public class PlayPauseBtn extends Sprite
	{
		/**
		 * background for the btn 
		 */		
		private var _bg:Sprite;
		
		/**
		 * play symbol will be drawn into this Sprite
		 */		
		private var _playSymbol:Sprite;
		
		/**
		 * pause symbol will be drawn into this Sprite
		 */		
		private var _pauseSymbol:Sprite;
		
		/**
		 * btn dimensions 
		 */		
		private var _btnHeight:Number;
		private var _btnWidth:Number;
		
		/**
		 * if the the play symbol is currently visible. If false the puse symbol is visible 
		 */		
		private var _ifPlay:Boolean = false;
		
		
		/**
		 * CONSTRUCTOR 
		 * 
		 * @param btnWidth
		 * @param btnHeight 
		 */		
		public function PlayPauseBtn(btnWidth:Number, btnHeight:Number):void
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
			
			// draw play symbol
			_playSymbol = new Sprite();
			_playSymbol.graphics.beginFill(VideoPlayerStyling.vpBtnOffCol);
			_playSymbol.graphics.moveTo(0, 0);
			_playSymbol.graphics.lineTo(symbolW, symbolH/2);
			_playSymbol.graphics.lineTo(0, symbolH);
			_playSymbol.graphics.lineTo(0, 0);
			_playSymbol.graphics.endFill();
			addChild(_playSymbol);
			_playSymbol.x = (_btnWidth - _playSymbol.width)/2;
			_playSymbol.y = (_btnHeight - _playSymbol.height)/2;
			
			
			// draw pause symbol
			var lineSpacing:Number = 2;
			var lineWidth:Number = (symbolW - lineSpacing)/2;			
			_pauseSymbol = new Sprite();
			_pauseSymbol.graphics.beginFill(VideoPlayerStyling.vpBtnOffCol);
			_pauseSymbol.graphics.moveTo(0, 0);
			_pauseSymbol.graphics.lineTo(lineWidth, 0);
			_pauseSymbol.graphics.lineTo(lineWidth, symbolH);
			_pauseSymbol.graphics.lineTo(0, symbolH);
			_pauseSymbol.graphics.lineTo(0, 0);
			
			_pauseSymbol.graphics.moveTo(lineWidth+lineSpacing, 0);
			_pauseSymbol.graphics.lineTo(lineWidth+lineSpacing+lineWidth, 0);			
			_pauseSymbol.graphics.lineTo(lineWidth+lineSpacing+lineWidth, symbolH);			
			_pauseSymbol.graphics.lineTo(lineWidth+lineSpacing, symbolH);
			_pauseSymbol.graphics.lineTo(lineWidth+lineSpacing, 0);
			_pauseSymbol.graphics.endFill();
			addChild(_pauseSymbol);
			_pauseSymbol.x = (_btnWidth - _pauseSymbol.width)/2;
			_pauseSymbol.y = (_btnHeight - _pauseSymbol.height)/2;
			
			
			// add event listeners for roll-on and roll-off events
			this.addEventListener(MouseEvent.MOUSE_OVER, rollOver_handler);
			this.addEventListener(MouseEvent.MOUSE_OUT, rollOff_handler);
			
			this.mouseChildren = false;
			this.buttonMode = true;
			
			showCorrectSymbol();			
		}
		
		
		/**
		 * function handles what happens when the mouse rolls over this btn 
		 * @param event
		 * 
		 */		
		private function rollOver_handler(event:MouseEvent):void
		{
			var colorTransformA:ColorTransform = _playSymbol.transform.colorTransform;
			colorTransformA.color = VideoPlayerStyling.vpBtnOnCol;
			_playSymbol.transform.colorTransform = colorTransformA;
			
			var colorTransformB:ColorTransform = _pauseSymbol.transform.colorTransform;
			colorTransformB.color = VideoPlayerStyling.vpBtnOnCol;
			_pauseSymbol.transform.colorTransform = colorTransformB;
		}
		
		
		/**
		 * function handles what happens when the mouse rolls off this btn 
		 * @param event
		 * 
		 */		
		private function rollOff_handler(event:MouseEvent):void
		{
			var colorTransformA:ColorTransform = _playSymbol.transform.colorTransform;
			colorTransformA.color = VideoPlayerStyling.vpBtnOffCol;
			_playSymbol.transform.colorTransform = colorTransformA;
			
			var colorTransformB:ColorTransform = _pauseSymbol.transform.colorTransform;
			colorTransformB.color = VideoPlayerStyling.vpBtnOffCol;
			_pauseSymbol.transform.colorTransform = colorTransformB;
		}
		
		

		/**
		 * shows this btn in the play state 
		 * 
		 */		
		public function showPlaySymbol():void
		{
			_ifPlay = true;
			showCorrectSymbol();
		}
		
		
		/**
		 * shows this btn in the pause state 
		 * 
		 */		
		public function showPauseSymbol():void
		{
			_ifPlay = false;			
			showCorrectSymbol();
		}
		
		
		/**
		 * fuction decide whether to display the play or pause symbol 
		 * 
		 */		
		private function showCorrectSymbol():void
		{
			if(_ifPlay)
			{
				_playSymbol.visible = false;
				_pauseSymbol.visible = true;
			}
			else
			{
				_playSymbol.visible = true;
				_pauseSymbol.visible = false;				
			}			
		}
		
		

	}
}