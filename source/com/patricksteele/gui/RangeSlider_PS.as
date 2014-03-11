package com.patricksteele.gui
{
	import com.greensock.TweenLite;
	
	import flash.display.GradientType;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;

	
	/**
	 * Class defines a custom horizontal slider with 2 draggable thumbs to allow a user to set a value range with a min and max value.
	 * 
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com0
	 * 
	 * 
	 * @example The example below creates a range slider for money values between £100 and £2500. 
	 * As the accuracy is set to 100 the min and max values will increment in £100s as the thumbs are dragged. 
	 * The range slider will display a graduated scale with black graduation lines in intervals of every £500. 
	 * The track is 400px wide and 5px high and is styled to be red and the thumbs have 3 shades of grey specified as their mouse states.
	 * The textfileds are styled with a custom textformat
	 * <listing version="3.0">
	 * 
	 * var priceSlider:RangeSlider_PS = new RangeSlider_PS(100,2500,100,500,400, 5);
	 * priceSlider.showGraduatedScale(0x000000, 1);
	 * priceSlider.styleTrack(0xFF0000);
	 * priceSlider.styleThumbs(0xCCCCCC,0x999999,0x333333,true);
	 * priceSlider.showGraduatedScale(0xFFFFFF, 1);
	 * 
	 * // set up TextFormat
	 * var _font:Font = new EmbeddedFont(); // linked from fla library
	 * var _myTextFormat:TextFormat = new TextFormat();
	 * _myTextFormat.font = _font.fontName;
	 * _myTextFormat.size = 12;
	 * _myTextFormat.align = TextFormatAlign.LEFT;
	 * priceSlider.formatTextFields(0x000000, _myTextFormat, true);
	 *  
	 * addChild(priceSlider);
	 * 
	 * </listing>
	 * 
	 */	
	public class RangeSlider_PS extends Sprite
	{
		/**
		 * The range sliders track 
		 */		
		private var _track:Sprite;
		
		/**
		 * Left hand thumb which is dragged to set the value ranges min value 
		 */		
		private var _leftHandThumb:Sprite;
		
		/**
		 * right hand thumb which is dragged to set the value ranges max value 
		 */		
		private var _rightHandThumb:Sprite
		
		/**
		 * The minimum value allowed. This is the value if the left hand thumb is positioned at the left edge of the track
		 */		
		private var _minValueLimit:Number = 0;

		/**
		 * The maximum value allowed. This is the value if the right hand thumb is positioned at the right edge of the track
		 */
		private var _maxValueLimit:Number = 1000;
		
		/**
		 * The value ranges currently set min value as specified by the position of the left hand thumb
		 */		
		private var _minValue:Number = 0;
		
		/**
		 * The value ranges currently set max value as specified by the position of the right hand thumb
		 */	
		private var _maxValue:Number = 1000;
				
		/**
		 * This acts as a container into which graduation lines can be drawn to indicate a graduated scale on the track. This Sprite is
		 * placed directly over the sliders track. By default these lines are not drawn and the <code>showGraduatedScale()</code> function
		 * must be called to show them.
		 */		
		private var _graduationLines:Sprite;
		
		/**
		 * This is used to specify the size of the intervals in the sliders graduated scale. This is needed to calculate where to draw
		 * the graduation lines in the _graduationLines Sprite</p>
		 */		
		private var _graduationInterval:Number = 100;
		
		/**
		 * This is a measure of how accurate the values of _minValue and _maxValue will be. The smaller _accuracy is the more accurate the readings.
		 * 
		 * <p>Used to round the values of the _minValue and _maxValue variables specified by the positions of the left and right
		 * hand thumbs. For example if _accuracy = 20 the values of _minValue and _maxValue will be rounded to the nearest 20.</p> 
		 */		
		private var _accuracy:Number = 20;
		
		/**
		 * textfield to display the value ranges current min value as defined by the position of the left hand thumb
		 */		
		private var _tfMinValue:TextField;
		
		/**
		 * textfield to display the value ranges current max value as defined by the position of the right hand thumb
		 */
		private var _tfMaxValue:TextField;
		
		/**
		 * Default text format for the _tfMinValue and _tfMaxValue textfields
		 */		
		private var _defaultTextFormat:TextFormat;
		
		/**
		 * The dimensions of the sliders track 
		 */		
		private var _trackWidth:Number = 200;
		private var _trackHeight:Number = 10;
		
		/**
		 * The dimensions of the left and right hand thumbs. The thumbs are shaped as a rectangle with a tappered triangluar top
		 */		
		private var _thumbWidth:Number = 10;	
		private var _thumbTopHeight:Number = 5;		
		private var _thumbBaseHeight:Number = 10;
		
		/**
		 * olors for the different mouse states for the thumbs 
		 */		
		private var _colThumbDefault:uint = 0x666666;
		private var _colThumbOver:uint = 0x333333;
		private var _colThumbDown:uint = 0x000000;

		
		/**
		 * Timer used for when dragging the left and right thumbs. Allows us to update the values of _minValue and _maxValue and the text displayed
		 * in the _tfMinValue and _tfMaxValue textfields as the thumbs are dragged.
		 */		
		private var _thumbDragTimer:Timer;
		
		/**
		 * How often in msecs the _thumbDragTimer will fire when dragging thumbs
		 */		
		private var _timerDelay:Number = 50;
		
		/**
		 * If the interactivity for the range slider has been enabled 
		 */		
		private var _ifEnabled:Boolean = false;
		
		
		/**
		 * CONSTRUCTOR
		 * 
		 * @param minLimit
		 * @param maxLimit
		 * @param accuracy
		 * @param graduationInterval
		 * @param trackWidth
		 * @param trackHeight
		 * @param thumbWidth
		 * @param thumbBaseHeight
		 * @param thumbTopHeight
		 */		
		public function RangeSlider_PS(minLimit:Number, maxLimit:Number, accuracy:Number, graduationInterval:Number, trackWidth:Number, trackHeight:Number = 10, thumbWidth:Number = 10, thumbBaseHeight:Number = 10, thumbTopHeight:Number = 5)
		{
			// set instance vars
			_minValueLimit = minLimit;
			_maxValueLimit = maxLimit;
			_minValue = _minValueLimit;
			_maxValue = _maxValueLimit;				
			_accuracy = accuracy;
			_graduationInterval = graduationInterval;
			_trackWidth = trackWidth;
			_trackHeight = trackHeight;			
			_thumbWidth = thumbWidth;
			_thumbTopHeight = thumbTopHeight;
			_thumbBaseHeight = thumbBaseHeight;
			
			// build the range sliders display
			buildSlider();
		}
		
		
		/**
		 * Function builds the range sliders display 
		 */		
		private function buildSlider():void
		{
			// init the drag timer
			_thumbDragTimer = new Timer(_timerDelay);
						
			// set up the slider track. By default this will have a flat white colour. But this can be changed via the styleTrack() function
			_track = new Sprite();
			styleTrack(0xFFFFFF);
			addChild(_track);
			_track.x = 0;
			_track.y = 0;
			
			// set up Sprite into which vertical lines to mark graduated scale can be drawn. The <code>showGraduatedScale</code> function should be
			// called if graduation scale is to be displayed
			_graduationLines = new Sprite();
			addChild(_graduationLines)
			_graduationLines.x = _track.x;
			_graduationLines.y = _track.y;
			
			
			// set up the left hand thumb
			_leftHandThumb = new Sprite();
			addChild(_leftHandThumb);
			_leftHandThumb.y = (_trackHeight - _thumbTopHeight - _thumbBaseHeight)/2;
			_leftHandThumb.x = _track.x
				
			// set up the right hand thumb
			_rightHandThumb = new Sprite();
			addChild(_rightHandThumb);
			_rightHandThumb.y = (_trackHeight - _thumbTopHeight - _thumbBaseHeight)/2;
			_rightHandThumb.x = _track.x + _trackWidth;
			
			// style the appearance of the thumbs
			styleThumbs(0x666666,0x333333,0x000000, true);

			
			// set up a default textformat for textfields
			_defaultTextFormat = new TextFormat();
			_defaultTextFormat.font = "Arial";
			_defaultTextFormat.size = 10;		
			_defaultTextFormat.align = TextFormatAlign.LEFT;
			
			// set up ranges min value textfield
			_tfMinValue = new TextField();
			_tfMinValue.mouseEnabled = false;
			_tfMinValue.selectable = false;
			_tfMinValue.multiline = false;
			_tfMinValue.wordWrap = false;
			addChild(_tfMinValue);
			
			// set up ranges max value textfield
			_tfMaxValue = new TextField();
			_tfMaxValue.mouseEnabled = false;
			_tfMaxValue.selectable = false;
			_tfMaxValue.multiline = false;
			_tfMaxValue.wordWrap = false;
			addChild(_tfMaxValue);
			
			// format the textfields - by default text is Black
			formatTextFields(0x000000, _defaultTextFormat);
			
			// refresh the textfields display
			refreshTextFields();
			
			// activate the range slider
			enable();
		}
		
		
		/**
		 * Function styles the appearance of the sliders track
		 *  
		 * @param fillColor
		 */		
		public function styleTrack(fillColor:uint):void
		{
			_track.graphics.clear();
			_track.graphics.lineStyle();
			_track.graphics.beginFill(fillColor, 1);
			_track.graphics.drawRect(0, 0, _trackWidth, _trackHeight);
			_track.graphics.endFill();			
		}
		
		
		/**
		 * Function draws the vertical graduation lines used to display a graduation scale for the sliders value range 
		 * 
		 * @param lineCol
		 * @param lineWeight
		 */		
		public function showGraduatedScale(lineCol:uint, lineWeight:Number = 1):void
		{
			_graduationLines.graphics.clear();
			
			// number of divisions to be created by the graduated scale lines
			//var numOfDivisions:Number = Math.ceil((_maxValueLimit - _minValueLimit) / _graduationInterval);
			var numOfDivisions:Number = (_maxValueLimit - _minValueLimit) / _graduationInterval;
			
			// the width in pixels of each division on the graduated scale
			var divisionWidth:Number = _trackWidth / numOfDivisions;
			
			// set styling for graduation lines
			_graduationLines.graphics.lineStyle(lineWeight, lineCol);

			var currentXpos:Number = divisionWidth;			
			
			// draw vertical lines that make up graduated scale display
			while(currentXpos < _trackWidth)
			{
				_graduationLines.graphics.moveTo(currentXpos,0);
				_graduationLines.graphics.lineTo(currentXpos,_trackHeight);
				currentXpos = currentXpos + divisionWidth;
			}
		}
		

		/**
		 * Function styles the appearance of the left and right hand thumbs.
		 * 
		 * @param defaultCol
		 * @param overCol
		 * @param downCol
		 * @param showDropShadow
		 */		
		public function styleThumbs(defaultCol:uint, overCol:uint, downCol:uint, showDropShadow:Boolean = false):void
		{
			// store cols for thumbs different mouse states
			_colThumbDefault = defaultCol;
			_colThumbOver = overCol;
			_colThumbDown = downCol;
		
			// draw left hand thumb
			_leftHandThumb.graphics.clear();
			_leftHandThumb.graphics.lineStyle();
			_leftHandThumb.graphics.beginFill(_colThumbDefault);
			_leftHandThumb.graphics.moveTo(0,0);
			_leftHandThumb.graphics.lineTo(_thumbWidth/2,_thumbTopHeight);
			_leftHandThumb.graphics.lineTo(_thumbWidth/2,_thumbBaseHeight+_thumbTopHeight);
			_leftHandThumb.graphics.lineTo(-_thumbWidth/2,_thumbBaseHeight+_thumbTopHeight);
			_leftHandThumb.graphics.lineTo(-_thumbWidth/2, _thumbTopHeight);
			_leftHandThumb.graphics.lineTo(0,0);
			_leftHandThumb.graphics.endFill();
			
			// draw right hand thumb
			_rightHandThumb.graphics.clear();
			_rightHandThumb.graphics.lineStyle();
			_rightHandThumb.graphics.beginFill(_colThumbDefault);
			_rightHandThumb.graphics.moveTo(0,0);
			_rightHandThumb.graphics.lineTo(_thumbWidth/2,_thumbTopHeight);
			_rightHandThumb.graphics.lineTo(_thumbWidth/2,_thumbBaseHeight+_thumbTopHeight);
			_rightHandThumb.graphics.lineTo(-_thumbWidth/2,_thumbBaseHeight+_thumbTopHeight);
			_rightHandThumb.graphics.lineTo(-_thumbWidth/2, _thumbTopHeight);
			_rightHandThumb.graphics.lineTo(0,0);
			_rightHandThumb.graphics.endFill();
			
			// add drop shadows to thumbs if wanted
			if(showDropShadow)
			{
				var dropShadow:DropShadowFilter = new DropShadowFilter(); 
				dropShadow.distance = 2;
				dropShadow.angle = 65;
				dropShadow.color = 0x333333;
				dropShadow.alpha = 0.5;
				dropShadow.blurX = 2;
				dropShadow.blurY = 2;			
				
				var arrFilters:Array = new Array();
				arrFilters.push(dropShadow);
				_leftHandThumb.filters = arrFilters;	
				_rightHandThumb.filters = arrFilters;
			}
		}
		
		
		/**
		 * Function sets the formatting for the textfields used to display the current min and max values for the range
		 *  
		 * @param txtCol
		 * @param txtFormat
		 * @param ifEmbedFonts
		 */		
		public function formatTextFields(txtCol:uint, txtFormat:TextFormat, ifEmbedFonts:Boolean = false):void
		{
			_tfMinValue.defaultTextFormat = txtFormat; 
			_tfMinValue.antiAliasType = AntiAliasType.ADVANCED;
			_tfMinValue.embedFonts = ifEmbedFonts; 
			_tfMinValue.textColor = txtCol;
			
			_tfMaxValue.defaultTextFormat = txtFormat; 
			_tfMaxValue.antiAliasType = AntiAliasType.ADVANCED;
			_tfMaxValue.embedFonts = ifEmbedFonts; 
			_tfMaxValue.textColor = txtCol;
			
			refreshTextFields();
		}
		
		
		/**
		 * Function refreshes the textfields with current min and max values 
		 */		
		private function refreshTextFields():void
		{
			_tfMinValue.text = _minValue.toString();
			_tfMinValue.autoSize = TextFieldAutoSize.LEFT;
			_tfMinValue.x = _track.x;
			_tfMinValue.y = _leftHandThumb.y + _leftHandThumb.height;
			
			_tfMaxValue.text = _maxValue.toString();
			_tfMaxValue.autoSize = TextFieldAutoSize.LEFT;
			_tfMaxValue.x = _track.x + _trackWidth - _tfMaxValue.width;
			_tfMaxValue.y = _rightHandThumb.y + _rightHandThumb.height;
		}
		
		
		/**
		 * Function returns the currently set min value for the value ranges
		 * 
		 * @return 
		 */		
		public function getMinValue():Number
		{
			return _minValue;
		}
		
		/**
		 * Function returns the currently set max value for the value ranges
		 * 
		 * @return 
		 */		
		public function getMaxValue():Number
		{
			return _maxValue;
		}
		
		
		public function setCurrentValues(minValue:Number, maxValue:Number):void
		{
			
			
		}
		
		
		/**
		 * Funciton enables or disables the interactivity for the range slider 
		 * 
		 * @param enable
		 */		
		public function enable(enable:Boolean = true):void
		{
			if(enable)
			{
				if(!_ifEnabled)
				{
					// enable left hand thumb
					_leftHandThumb.addEventListener(MouseEvent.MOUSE_OVER, thumb_rollOverHandler, false, 0, true);
					_leftHandThumb.addEventListener(MouseEvent.MOUSE_OUT, thumb_rollOffHandler, false, 0, true);
					_leftHandThumb.addEventListener(MouseEvent.MOUSE_DOWN, _leftHandThumb_mouseDownHandler, false, 0, true);
					_leftHandThumb.buttonMode = true;
					
					// enable right hand thumb
					_rightHandThumb.addEventListener(MouseEvent.MOUSE_OVER, thumb_rollOverHandler, false, 0, true);
					_rightHandThumb.addEventListener(MouseEvent.MOUSE_OUT, thumb_rollOffHandler, false, 0, true);
					_rightHandThumb.addEventListener(MouseEvent.MOUSE_DOWN, _rightHandThumb_mouseDownHandler, false, 0, true);
					_rightHandThumb.buttonMode = true;
					
					// add listener to timer
					_thumbDragTimer.addEventListener(TimerEvent.TIMER, _thumbDragTimer_handler, false, 0, true);
				}
			}
			else
			{
				if(_ifEnabled)
				{
					// disable left hand thumb
					_leftHandThumb.removeEventListener(MouseEvent.MOUSE_OVER, thumb_rollOverHandler);
					_leftHandThumb.removeEventListener(MouseEvent.MOUSE_OUT, thumb_rollOffHandler);
					_leftHandThumb.removeEventListener(MouseEvent.MOUSE_DOWN, _leftHandThumb_mouseDownHandler);
					_leftHandThumb.buttonMode = false;
					
					// disable right hand thumb
					_rightHandThumb.removeEventListener(MouseEvent.MOUSE_OVER, thumb_rollOverHandler);
					_rightHandThumb.removeEventListener(MouseEvent.MOUSE_OUT, thumb_rollOffHandler);
					_rightHandThumb.removeEventListener(MouseEvent.MOUSE_DOWN, _rightHandThumb_mouseDownHandler);
					_rightHandThumb.buttonMode = false;
					
					// add listener to timer
					_thumbDragTimer.removeEventListener(TimerEvent.TIMER, _thumbDragTimer_handler);
				}
			}
		}
		
		
		
		
		
		
		/**
		 * Function handles what happens when the user rolls over a thumb. 
		 * 
		 * @param event
		 */		
		private function thumb_rollOverHandler(event:MouseEvent):void
		{
			var colorTransform:ColorTransform;
			
			switch(event.target)
			{
				case _leftHandThumb:
					colorTransform = _leftHandThumb.transform.colorTransform;
					colorTransform.color = _colThumbOver;
					_leftHandThumb.transform.colorTransform = colorTransform;
					break;
				
				case _rightHandThumb:
					colorTransform = _rightHandThumb.transform.colorTransform;
					colorTransform.color = _colThumbOver;
					_rightHandThumb.transform.colorTransform = colorTransform;
					break;
				
				default:
			}
		}
		
		/**
		 * Function habdles what happens when the user rolls off a thumb. 
		 * 
		 * @param event
		 */
		private function thumb_rollOffHandler(event:MouseEvent):void
		{
			var colorTransform:ColorTransform;
			
			switch(event.target)
			{
				case _leftHandThumb:
					colorTransform = _leftHandThumb.transform.colorTransform;
					colorTransform.color = _colThumbDefault;
					_leftHandThumb.transform.colorTransform = colorTransform;
					break;
				
				case _rightHandThumb:
					colorTransform = _rightHandThumb.transform.colorTransform;
					colorTransform.color = _colThumbDefault;
					_rightHandThumb.transform.colorTransform = colorTransform;
					break;
				
				default:
			}
		}
		
		
		
		/**
		 * Function handles what to do when the user clicks on the left hand thumb and starts to drag it
		 * 
		 * @param event
		 */		
		private function _leftHandThumb_mouseDownHandler(event:MouseEvent):void
		{
			// set thumb state
			var colorTransform:ColorTransform = _leftHandThumb.transform.colorTransform;
			colorTransform.color = _colThumbDown;
			_leftHandThumb.transform.colorTransform = colorTransform;
			
			// set drag boundaries and start dragging. Making sure the left and right thumbs can't overlap
			var dragBoundaryXpos:Number = _track.x;
			var dragBoundaryWidth:Number = (_rightHandThumb.x - _thumbWidth) - _track.x;
			_leftHandThumb.startDrag(false, new Rectangle(dragBoundaryXpos, _leftHandThumb.y, dragBoundaryWidth, 0));
			
			// add listeners to stop dragging if mouse released
			_leftHandThumb.addEventListener(MouseEvent.MOUSE_UP, stopThumbDrag_handler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopThumbDrag_handler, false, 0, true);
			
			// start the timer
			_thumbDragTimer.start();
		}
		
		
		/**
		 * Function handles what to do when the user clicks on the right hand thumb and starts to drag it
		 * 
		 * @param event
		 */		
		private function _rightHandThumb_mouseDownHandler(event:MouseEvent):void
		{
			// set thumb state
			var colorTransform:ColorTransform = _rightHandThumb.transform.colorTransform;
			colorTransform.color = _colThumbDown;
			_rightHandThumb.transform.colorTransform = colorTransform;
			
			// set drag boundaries and start dragging. Making sure the left and right thumbs can't overlap
			var dragBoundaryXpos:Number = _leftHandThumb.x + _thumbWidth;
			var dragBoundaryWidth:Number = _trackWidth - (dragBoundaryXpos - _track.x);
			_rightHandThumb.startDrag(false, new Rectangle(dragBoundaryXpos, _rightHandThumb.y, dragBoundaryWidth, 0));
			
			// add listeners to stop dragging if mouse released
			_rightHandThumb.addEventListener(MouseEvent.MOUSE_UP, stopThumbDrag_handler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopThumbDrag_handler, false, 0, true);
			
			// start the timer
			_thumbDragTimer.start();
		}
		
		
		
		
		/**
		 * Function called on timer event by the _thumbDragTimer Timer obj when the user holds down the mouse while dragging 
		 * one of the thumbs.
		 * 
		 * @param event
		 */		
		private function _thumbDragTimer_handler(event:TimerEvent = null):void
		{
			// number of units in the sliders value range if we take _accuracy as a step
			var numOfSteps:Number = Math.ceil((_maxValueLimit - _minValueLimit) / _accuracy) + 1;
			
			// the width in pixels of each step
			var stepWidth:Number = _trackWidth / numOfSteps;
			
			// the amount of pixels of a single unit in the sliders range
			var unitWidth:Number = (_maxValueLimit - _minValueLimit)/_trackWidth;
			
			
			// distance along the track the left hand thumb has moved
			var leftThumbDistance:Number = _leftHandThumb.x - _track.x; 

			// the exact min value as specified by left hand thumbs current position
			var _currentMinValueExact:Number = _minValueLimit + (leftThumbDistance * unitWidth); 
			
			// the min value rounded to the nearest _accuracy
			_minValue = _minValueLimit + ((Math.floor(leftThumbDistance/stepWidth)) * _accuracy);
			
			
			// distance along the track the right hand thumb has moved
			var rightThumbDistance:Number = _rightHandThumb.x - _track.x; 
			
			// the exact max value as pecified by the right hand thumbs current position
			var _currentMaxValueExact:Number = _minValueLimit + (rightThumbDistance * unitWidth); 
			
			// the max value rounded to the nearest _accuracy
			_maxValue = _minValueLimit + ((Math.floor(rightThumbDistance/stepWidth)) * _accuracy);
			
			// make sure limits are adhered to
			if(_minValue < _minValueLimit) _minValue = _minValueLimit;
			if(_maxValue > _maxValueLimit) _maxValue = _maxValueLimit;
			
			
			//trace(_currentMinValueExact+":"+_currentMaxValueExact);
			//trace(_minValue+":"+_maxValue);

			
			// refresh the values displayed in the textfields
			refreshTextFields();
		}
		
		
		/**
		 * Function stops the dragging of a thumb when the user releases the mouse button while dragging it
		 * 
		 * @param event
		 */	
		private function stopThumbDrag_handler(event:MouseEvent):void
		{
			// set thumb state
			var colorTransform:ColorTransform;
			switch(event.target)
			{
				case _leftHandThumb:
					colorTransform = _leftHandThumb.transform.colorTransform;
					colorTransform.color = _colThumbDefault;
					_leftHandThumb.transform.colorTransform = colorTransform;
					break;
				
				case _rightHandThumb:
					colorTransform = _rightHandThumb.transform.colorTransform;
					colorTransform.color = _colThumbDefault;
					_rightHandThumb.transform.colorTransform = colorTransform;
					break;
				
				default:
			}
			
			// call this function one time to make sure values are perfect before we stop the timer and draggind
			_thumbDragTimer_handler();
			
			// stop the dragging
			_leftHandThumb.stopDrag();
			_rightHandThumb.stopDrag();
			
			// remove listeners
			event.target.removeEventListener(MouseEvent.MOUSE_UP, stopThumbDrag_handler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopThumbDrag_handler);
			
			// stop the timer
			_thumbDragTimer.stop();
			
		}
		
	}
}