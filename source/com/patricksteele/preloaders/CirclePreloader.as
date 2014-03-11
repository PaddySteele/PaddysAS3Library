package com.patricksteele.preloaders
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;


	/**
	 * Class defines an Apple style circular preloader. Appears as a rotating circle made up of lines radiating from the centre
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 * @example For an apple style preloader made up of lines radiating from the centre
	 * <listing version="3.0">
	 * 		var preloader:CirclePreloader = new CirclePreloader(6,12,6,2,0x666666,65);
	 * </listing>
	 * 
	 * 
	 * @example For a youtube style preloader made up of a circle of smaller circles
	 * <listing version="3.0">
	 * 		var preloader:CirclePreloader = new CirclePreloader(10,10,6,6,0x666666,65);
	 * </listing>
	 * 
	 * ###########################################################################
	 */	
	public class CirclePreloader extends Sprite 
	{
	
		/**
		 * radius of circle inside
		 */		
		private var _innerRadius:int;
		
		/**
		 * number of radiating lines that make up the preloader circle 
		 */		
		private var _numOfRadialLines:int;
		
		/**
		 * the length of the radial lines that make up the circle preloader shape
		 */		
		private var _lineLength:int;
		
		/**
		 * the width of a radial line that makes up the circle preloader shape
		 */	
		private var _lineThickness:int;
		
		/**
		 * color of the circle lines 
		 */
		private var _lineColor:int;
		
		/**
		 * will contain the radiating lines that make up the circle 
		 */		
		private var _lineContainer:Sprite;
		
		/**
		 * Timer used for rotation of the preloader circle
		 */		
		private var _timer:Timer;
		
		/**
		 * how fast the preloader will rotate. The lower the value the faster the rotation
		 */		
		private var _rotationSpeed:int = 65;

		
		/**
		 * CONSTRUCTOR
		 * 
		 * @param innerRadius
		 * @param numOfLines
		 * @param lineLength
		 * @param lineThickness
		 * @param lineColor
		 * @param rotationSpeed
		 * 
		 */		
		public function CirclePreloader(innerRadius:int = 6, numOfLines:int = 12, lineLength:int = 6, lineThickness:int = 2, lineColor:int = 0x666666, rotationSpeed:int=65) 
		{
			super();
			
			_innerRadius = innerRadius;
			_numOfRadialLines = numOfLines;			
			_lineLength = lineLength;
			_lineThickness = lineThickness;
			_lineColor = lineColor;
			_rotationSpeed = rotationSpeed;
			
			// sprite to hold the radial lines that make up the preloaders circle shape
			_lineContainer = new Sprite();
			addChild(_lineContainer);
			
			drawPreloaderShape();			
			
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage_handler);
			
		}


		/**
		 * function draws the preloader shape 
		 * 
		 */		
		private function drawPreloaderShape():void 
		{
			var degrees:int = 360 / _numOfRadialLines;
			
			for(var i:Number = 0; i < _numOfRadialLines; i++)
			{
				var radialLine:Shape = getRadialLine();
				radialLine.alpha = Math.max(0.2, 1 - (0.1 * i));
				var radianAngle:Number = (degrees * i) * Math.PI / 180;
				radialLine.rotation = -degrees * i;
				radialLine.x = Math.sin(radianAngle) * _innerRadius;
				radialLine.y = Math.cos(radianAngle) * _innerRadius;
				_lineContainer.addChild(radialLine);
			}
		}



		/**
		 * function creates a single radial line shape which is used to make the circular preloader shape 
		 * @return 
		 * 
		 */		
		private function getRadialLine():Shape
		{
			var segment:Shape = new Shape();
			segment.graphics.beginFill(_lineColor);
			segment.graphics.drawRoundRect(-1, 0, _lineThickness, _lineLength, 12, 12);
			segment.graphics.endFill();
			return segment;
		}



		/**
		 * function handles what happens when a CircularPreloader obj is added to the stage - starts Timer that 
		 * controls the preloader rotation 
		 * @param event
		 * 
		 */		
		private function addedToStage_handler(event:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, addedToStage_handler);
			this.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStage_handler);
			
			// set up timer
			_timer = new Timer(_rotationSpeed);
			_timer.addEventListener(TimerEvent.TIMER, rotatePreloader_handler, false, 0, true);
			_timer.start();
		}



		/**
		 * function handles what happens when a CircularPreloader obj is removed from the stage - stops the rotation and
		 * kills Timer event
		 * @param event
		 * 
		 */		
		private function removedFromStage_handler(event:Event):void
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, removedFromStage_handler);
			this.addEventListener(Event.ADDED_TO_STAGE, addedToStage_handler);
			
			// destroy timer
			_timer.reset();
			_timer.removeEventListener(TimerEvent.TIMER, rotatePreloader_handler);
			_timer = null;
		}


		
		/**
		 * function handles the rotation of the preloader shape 
		 * @param event
		 * 
		 */		
		private function rotatePreloader_handler(event:TimerEvent):void
		{
			_lineContainer.rotation = (_lineContainer.rotation + (360 / _numOfRadialLines)) % 360;
		}
	}
}
