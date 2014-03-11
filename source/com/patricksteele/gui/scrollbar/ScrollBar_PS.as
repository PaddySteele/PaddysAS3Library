package com.patricksteele.gui.scrollbar
{
	import com.greensock.TweenLite;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.utils.Timer;

	/**
	 * Class defines a customizable Scroll Bar. The scroll bar is made of the following standard scroll bar elements:
	 * 
	 * <p>The Scroll Bar consists of a draggable 'thumb' that can be dragged along a 'track' to move the scrollable content.
	 * The Scroll Bar can also contain 2 optional 'arrow' buttons at either end that cause the scrollable content to be shifted
	 * incrementally in one direction at a time.</p>
	 * 
	 * <p>The _scrollMovement, _scrollDelay and _easeTime (if using easing) instance var value should be adjusted to get the
	 * desired feel for your scroll bar.</p>
	 * 
	 * <p>If we need to disable the interactivity of any of the elements in the Scroll Bar this can be done by
	 * commenting out the revelant listeners in the <code>enable</code> function. For example we could easily
	 * remove the mouse wheel behaviour or prehaps remove the click on track functionality.</p>
	 * 
	 * @example The example below creates a classic scroll bar with up+down arrow btns
	 * <listing version="3.0">
	 * 
	 * var scrollBar:ScrollBar_PS = new ScrollBar_PS(myContent, myMask, true, 20, 20, true, 20);
	 * addChild(scrollBar);
	 * scrollBar.styleTrack(0xCCCCCC);
	 * scrollBar.styleArrowBtnsOffState({color:0x999999},{color:0xFFFFFF, thickness:1}, 0, 0xFF0000);
	 * scrollBar.styleArrowBtnsOverState({color:0x666666},{color:0xFFFFFF, thickness:1}, 0, 0xFF0000);
	 * scrollBar.styleArrowBtnsDownState({color:0x333333},{color:0xFFFFFF, thickness:1}, 0, 0xFFFFFF);
	 * scrollBar.styleThumbOffState({color:0x999999},{color:0xFFFFFF, thickness:1});
	 * scrollBar.styleThumbOverState({color:0x666666},{color:0xFFFFFF, thickness:1});
	 * scrollBar.styleThumbDownState({color:0x333333},{color:0xFFFFFF, thickness:1});
	 * 
	 * </listing>
	 * 
	 * 
	 * @example The example below creates a basic scroll bar with no arrow btns and just a rectangular thumb and track
	 * <listing version="3.0">
	 * 
	 * var scrollBar:ScrollBar_PS = new ScrollBar_PS(myContent, myMask, true, 14, 14, false);
	 * addChild(scrollBar);
	 * scrollBar.styleTrack(0xCCCCCC);
	 * scrollBar.styleThumbOffState({color:0x999999});
	 * scrollBar.styleThumbOverState({color:0x999999});
	 * scrollBar.styleThumbDownState({color:0x999999});
	 * 
	 * </listing>
	 * 
	 * 
	 * @example The example below creates a basic scroll bar with no arrow btns. It will have a narrow line as the track and a rounded
	 * rectangle as the thumb
	 * <listing version="3.0">
	 * 
	 * var scrollBar:ScrollBar_PS = new ScrollBar_PS(myContent, myMask, true, 2, 16, false);
	 * addChild(scrollBar);
	 * scrollBar.styleTrack(0xCCCCCC);
	 * scrollBar.styleThumbOffState({color:0x999999}, null, 15);
	 * scrollBar.styleThumbOverState({color:0x999999}, null, 15);
	 * scrollBar.styleThumbDownState({color:0x999999}, null, 15);
	 * 
	 * </listing>
	 * 
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 */	
	public class ScrollBar_PS extends Sprite
	{
		/**
		 * Holds ref to the display object we want to scroll. Can be a TextField, MovieClip, Sprite or any other DisplayObject 
		 */		
		private var _scrollableContent:DisplayObject;
		
		/**
		 * Holds ref to the mask Sprite used to specify the current viewing area for the _scrollableContent object
		 */		
		private var _contentMask:Sprite;
		
		/**
		 * The 4 main display/control elements of a scroll bar. scroll track, scroll thumb and optional up and down arrow btns 
		 */		
		private var _track:Sprite;		
		private var _thumb:ScrollBarThumb_PS;		
		private var _arrowBtnUp:ScrollBarArrowBtn_PS;	
		private var _arrowBtnDown:ScrollBarArrowBtn_PS;
		
		
		/**
		 * The dimensions of the scroll bar and its elements
		 */		
		private var _scrollBarHeight:Number;
		private var _trackWidth:Number;
		private var _thumbWidth:Number;
		private var _arrowBtnWidth:Number; // note the arrow btns will be square so their height will be same as their width
		private var _arrowBtnHeight:Number;
		
		
		/**
		 * If the scroll bar should use the optional up and down arrow btns 
		 */		
		private var _ifUsingArrowBtns:Boolean;
		
		/**
		 * Timer used for when scrolling the scrollable item via the optional up and down arrow btns 
		 */		
		private var _arrowTimer:Timer;
		
		/**
		 * Timer used for when scrolling the scrollable item by dragging/scrubbing the Scroll Bar thumb 
		 */		
		private var _thumbTimer:Timer;
		
		/**
		 * If currently scrolling by draggng the thumb 
		 */		
		private var _ifThumbing:Boolean = false;
		
		/**
		 * The time in msecs between scroll updates 
		 */		
		private var _scrollDelay:Number = 50;
		
		/**
		 * The amount to scroll on each update
		 */		
		private var _scrollMovement:Number = 50;
		
		/**
		 * If the scollbar should use Tween.Lit to ease the scrolling 
		 */		
		private var _useEasing:Boolean = true;
		
		/**
		 * The time of the easing if _useEasing = true
		 */		
		private var _easeTime:Number = 0.2;
		
		/**
		 * the current direction the scrollable content is moving in 
		 */		
		private var _scrollDirection:Number;

		/**
		 * Constants to indicate the possible directions for scrolling 
		 */
		private const SCROLL_NONE:Number = 0;		
		private const SCROLL_UP:Number = 1;		
		private const SCROLL_DOWN:Number = 2;
		
		/**
		 * if the scroll bar's mouse behaviours are currently enabled 
		 */		
		private var _ifEnabled:Boolean = false;
		
		/**
		 * Default colour for the Scroll Bar track 
		 */		
		private var _colTrack:uint = 0xCCCCCC;
		

		
		
		/**
		 * CONSTRUCTOR
		 *  
		 * @param scrollableContent	The display item the scoll bar is to control
		 * @param contentMask		The display item to act as the mask which defines the viewable area of the scollable content
		 * @param useEasing			If the scrolling should use TweenLite to ease the movement. Default = true.
		 * @param trackWidth		Width of the scroll bar's track
		 * @param thumbWidth		Width of the scroll bar's thumb
		 * @param useArrowBtns		If the scroll bar is to have the optional up and down scroll btns
		 * @param arrowBtnWidth		Width of the optional up and down arrow btns if present
		 * 
		 */		
		public function ScrollBar_PS(scrollableContent:DisplayObject, contentMask:Sprite, useEasing:Boolean = true, trackWidth:Number = 20, thumbWidth:Number = 20, useArrowBtns:Boolean = false, arrowBtnWidth:Number = 20)
		{
			// set instance vars
			_scrollableContent = scrollableContent;
			_contentMask = contentMask;
			_trackWidth = trackWidth;
			_thumbWidth = thumbWidth;
			_arrowBtnWidth = _arrowBtnHeight = arrowBtnWidth;			
			_scrollBarHeight = _contentMask.height;			
			_ifUsingArrowBtns = useArrowBtns;
			_useEasing = useEasing;
			
			// set up the masking for the scrollable item
			_scrollableContent.mask = _contentMask;
			
		
			// call function to build the Scrolll Bar
			buildScrollBar();
			
			// init timers used by Scroll Bar
			_arrowTimer = new Timer(_scrollDelay);
			_thumbTimer = new Timer(_scrollDelay);
			
			
			// call the refresh function to make sure the thumb is the correct size
			this.addEventListener(Event.ADDED_TO_STAGE, refresh);
		}
		
		
		
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
///////////// FUNCTIONS CONCERED WITH THE BUILDING OF THE THE SCROLL BAR  ////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
		
		/**
		 * Function builds the Scroll Bar elements and add them for display.
		 */		
		private function buildScrollBar():void
		{
			// create the optional up and down arrow btns if they are needed
			if(_ifUsingArrowBtns)
			{
				_arrowBtnUp = new ScrollBarArrowBtn_PS(_arrowBtnWidth, _arrowBtnHeight, "up");
				_arrowBtnDown = new ScrollBarArrowBtn_PS(_arrowBtnWidth, _arrowBtnHeight, "down");
			}
			
			// create the scrollbar track, setting its default appearance and add it. 
			// Appearance can be updated again later via the <code>styleTrack</code> function
			_track = new Sprite();
			var trackHeight:Number = _scrollBarHeight;
			if(_ifUsingArrowBtns)
			{
				trackHeight = _scrollBarHeight - _arrowBtnHeight*2;
			}
			
			_track.graphics.lineStyle();
			_track.graphics.beginFill(_colTrack);
			_track.graphics.drawRect(0, 0, _trackWidth, trackHeight);
			_track.graphics.endFill();
			
			// create and the scroll bar thumb
			var originalThumbH:Number = (_contentMask.height / _scrollableContent.height) * trackHeight;
			_thumb = new ScrollBarThumb_PS(_thumbWidth, originalThumbH);
			
			
			// add scroll bar track
			addChild(_track);
			
			// if being used add the up and down arrow btns after the thumb. This ensures the thumb is on the level below
			// these btns and hence the bottom edge of _arrowBtnUp will not be obscured the thumb is at its uppermost y pos
			// AND the top edge of _arrowBtnDown will not be obscured the thumb is at its lowermost y pos
			if(_ifUsingArrowBtns)
			{
				addChild(_arrowBtnUp);		
				addChild(_arrowBtnDown);				
			}
			
			// add scroll thumb position
			addChild(_thumb);
			
			// call function to set positioning of scroll bar elements
			positionScrollBarElements();
		}
		
		
		
		/**
		 * Function positions the various Scroll Bar elements ie. the track, thumb and up/down arrow btns depending on their current size 
		 * 
		 */		
		private function positionScrollBarElements():void
		{
			// determine the widest scroll bar element. Useful when setting the x positions of the scroll bar elements
			var totalWidth:Number = _trackWidth;
			if(_thumbWidth > totalWidth) totalWidth  = _thumbWidth;
			if(_arrowBtnHeight > totalWidth) totalWidth  = _arrowBtnHeight;
			
			var yPos:Number = 0;	
			
			// set positioning for up arrow btn if present
			if(_ifUsingArrowBtns)
			{
				_arrowBtnUp.x = (totalWidth - _arrowBtnUp.width)/2;
				_arrowBtnUp.y = yPos;
				yPos = yPos + _arrowBtnHeight;
			}
			
			// set positioning for scroll bar track
			_track.x = (totalWidth - _trackWidth)/2;
			_track.y = yPos;			
			yPos = yPos + _track.height;
			
			
			// set positioning for down arrow btn if present
			if(_ifUsingArrowBtns)
			{
				_arrowBtnDown.y = yPos;
				_arrowBtnDown.x = (totalWidth - _arrowBtnWidth)/2;
			}
			
			// set scroll thumb position
			_thumb.x = (totalWidth - _thumbWidth)/2;
			setThumbPosition();
		}
		
		
		
		/**
		 * Function can be called to refresh the scroll bar and importantly set the size of the 
		 * thumb element. Also decides if the scroll bar needs to be enabled - depends on the
		 * size of the _scrollableContent.
		 * 
		 * <p>Called when the scrollbael is first added to the stage and can be called at any time
		 * if the content and hence the height of the scrollable area has been changed.</p>
		 * 
		 * @param event
		 */		
		public function refresh(event:Event = null):void
		{
			if(_scrollableContent.height > _contentMask.height) // check if we need a scrollbar
			{
				var updatedHeight:Number = (_contentMask.height / _scrollableContent.height) * _track.height;
				_thumb.resizeThumb(updatedHeight);
				_thumb.visible = true; // show thumb

				setThumbPosition(); // call function to set the thumbs current position
				
				enable(true); // enable scroll bar btns, track and thumb
			}
			else
			{
				_thumb.resizeThumb(_track.height);
				_thumb.y = _track.y;				
				_thumb.visible = false; // hide thumb
				
				enable(false); // disable scroll bar btns, track and thumb
			}		
		}
		
		
		
		
		
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
///////////// FUNCTIONS CONCERED WITH THE STYLING OF THE SCROLL BAR ELEMENTS - ARROW BUTTONS, TRACK AND THUMB ////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
		/**
		 * Function sets the appearance for the Scroll Bar's track
		 *  
		 * @param fill		An object containing fill properties. Default null gives no fill.
		 * @param stroke	An object containing stroke properties for the btns border. Default null gives no stroke.
		 * @param ellipse	The amount of curve for rounding the btn corners. Default is 0 ie. square corners.
		 * @param arrowCol 	The color of the arrow in the up/down btn
		 */	
		public function styleTrack(fillCol:uint = 0xCCCCCC, borderCol:uint = 0X000000, borderWidth:int = 0, ellipse:Number = 0):void
		{
			// track height depands on presence of the optional up and down arrow btns
			var trackHeight:Number
			if(_ifUsingArrowBtns)
			{
				trackHeight = _scrollBarHeight - _arrowBtnHeight*2;
			}
			else
			{
				trackHeight = _scrollBarHeight;
			}
			
			// clear any prev graphics
			_track.graphics.clear();
			
			// if we need a border
			if(borderWidth > 0) 
			{
				_track.graphics.lineStyle(borderWidth, borderCol);
			}
			else // no border
			{
				_track.graphics.lineStyle();
			}
			
			_track.graphics.beginFill(fillCol);

			// make sure any border does not increase the width and height of the btnState Sprite and that the width
			// and height stay the same no matter the stroke weight
			var rectWidth:Number = _trackWidth;
			var rectHeight:Number = trackHeight;
			if(borderWidth >= 1)
			{
				rectWidth = rectWidth - borderWidth;
				rectHeight = rectHeight - borderWidth;
			}
		
			// determine if rounded corners
			if(ellipse > 0) // rounded corners
			{
				_track.graphics.drawRoundRect(borderWidth/2, borderWidth/2, rectWidth, rectHeight, ellipse);
			}
			else // square corners
			{
				_track.graphics.drawRect(borderWidth/2, borderWidth/2, rectWidth, rectHeight);
			}
			
			_track.graphics.endFill();
		}
		
		
		/**
		 * If the scroll bar is to have up and down arrow btns this function sets the appearance for the OFF state of the 2 btns
		 * 
		 * @param fill		An object containing fill properties. Default null gives no fill.
		 * @param stroke	An object containing stroke properties for the btns border. Default null gives no stroke.
		 * @param ellipse	The amount of curve for rounding the btn corners. Default is 0 ie. square corners.
		 * @param arrowCol 	The color of the arrow in the up/down btn
		 */		
		public function styleArrowBtnsOffState(fill:Object = null, border:Object = null, ellipse:int = 0, arrowCol:uint = 0xFFFFFF):void
		{
			if(_ifUsingArrowBtns)
			{
				_arrowBtnUp.styleBtnOffState(fill, border, ellipse, arrowCol);
				_arrowBtnDown.styleBtnOffState(fill, border, ellipse, arrowCol);
			}
		
		}		
		/**
		 * If the scroll bar is to have up and down arrow btns this function sets the appearance for the OVER state of the 2 btns
		 * 
		 * @param fill		An object containing fill properties. Default null gives no fill.
		 * @param stroke	An object containing stroke properties for the btns border. Default null gives no stroke.
		 * @param ellipse	The amount of curve for rounding the btn corners. Default is 0 ie. square corners.
		 * @param arrowCol 	The color of the arrow in the up/down btn
		 */	
		public function styleArrowBtnsOverState(fill:Object = null, border:Object = null, ellipse:int = 0, arrowCol:uint = 0xFFFFFF):void
		{
			if(_ifUsingArrowBtns)
			{
				_arrowBtnUp.styleBtnOverState(fill, border, ellipse, arrowCol);
				_arrowBtnDown.styleBtnOverState(fill, border, ellipse, arrowCol);
			}
			
		}		
		/**
		 * If the scroll bar is to have up and down arrow btns this function sets the appearance for the DOWN state of the 2 btns
		 * 
		 * @param fill		An object containing fill properties. Default null gives no fill.
		 * @param stroke	An object containing stroke properties for the btns border. Default null gives no stroke.
		 * @param ellipse	The amount of curve for rounding the btn corners. Default is 0 ie. square corners.
		 * @param arrowCol 	The color of the arrow in the up/down btn
		 */	
		public function styleArrowBtnsDownState(fill:Object = null, border:Object = null, ellipse:int = 0, arrowCol:uint = 0xFFFFFF):void
		{
			if(_ifUsingArrowBtns)
			{
				_arrowBtnUp.styleBtnDownState(fill, border, ellipse, arrowCol);
				_arrowBtnDown.styleBtnDownState(fill, border, ellipse, arrowCol);
			}
			
		}
		

		
		
		/**
		 * This function sets the appearance for the OFF state for the thumb element of the scroll bar
		 * 
		 * @param fill		An object containing fill properties. Default null gives no fill.
		 * @param stroke	An object containing stroke properties for the btns border. Default null gives no stroke.
		 * @param ellipse	The amount of curve for rounding the btn corners. Default is 0 ie. square corners.
		 */		
		public function styleThumbOffState(fill:Object = null, border:Object = null, ellipse:int = 0):void
		{
			_thumb.styleThumbOffState(fill, border, ellipse);
			
		}		
		/**
		 * This function sets the appearance for the OVER state for the thumb element of the scroll bar
		 * 
		 * @param fill		An object containing fill properties. Default null gives no fill.
		 * @param stroke	An object containing stroke properties for the btns border. Default null gives no stroke.
		 * @param ellipse	The amount of curve for rounding the btn corners. Default is 0 ie. square corners.
		 */	
		public function styleThumbOverState(fill:Object = null, border:Object = null, ellipse:int = 0):void
		{
			_thumb.styleThumbOverState(fill, border, ellipse);
			
		}		
		/**
		 * This function sets the appearance for the DOWN state for the thumb element of the scroll bar
		 * 
		 * @param fill		An object containing fill properties. Default null gives no fill.
		 * @param stroke	An object containing stroke properties for the btns border. Default null gives no stroke.
		 * @param ellipse	The amount of curve for rounding the btn corners. Default is 0 ie. square corners.
		 */	
		public function styleThumbDownState(fill:Object = null, border:Object = null, ellipse:int = 0):void
		{
			_thumb.styleThumbDownState(fill, border, ellipse);
			
		}
		
		
		
		
		
		
		
		
		
		
		
		
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
///////////// FUNCTIONS CONCERED SETTING UP SCROLL BARS SCROLLING FUNCTIONALITY //////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	

		/**
		 * Function enebles or disables the mouse interactivity for the Scroll Bar
		 *  
		 * @param enabled
		 */		
		public function enable(enabled:Boolean):void
		{
			if(enabled)
			{
				if(_ifEnabled == false)
				{
					if(_ifUsingArrowBtns) // enable up and down arrow btns if present
					{
						_arrowBtnUp.addEventListener(MouseEvent.MOUSE_OVER, arrowBtn_rollOverHandler, false, 0, true);
						_arrowBtnUp.addEventListener(MouseEvent.MOUSE_OUT, arrowBtn_rollOffHandler, false, 0, true);
						_arrowBtnUp.addEventListener(MouseEvent.MOUSE_DOWN, arrowBtn_mouseDownHandler, false, 0, true);
						_arrowBtnUp.addEventListener(MouseEvent.MOUSE_UP, arrowBtn_mouseUpHandler, false, 0, true);
						
						_arrowBtnDown.addEventListener(MouseEvent.MOUSE_OVER, arrowBtn_rollOverHandler, false, 0, true);
						_arrowBtnDown.addEventListener(MouseEvent.MOUSE_OUT, arrowBtn_rollOffHandler, false, 0, true);
						_arrowBtnDown.addEventListener(MouseEvent.MOUSE_DOWN, arrowBtn_mouseDownHandler, false, 0, true);
						_arrowBtnDown.addEventListener(MouseEvent.MOUSE_UP, arrowBtn_mouseUpHandler, false, 0, true);
						
						_arrowBtnUp.buttonMode = true;
						_arrowBtnDown.buttonMode = true;
						
						_arrowTimer.addEventListener(TimerEvent.TIMER, scrollContent_handler, false, 0, true);
					}
					
					// enable scroll bar thumb
					_thumb.addEventListener(MouseEvent.MOUSE_OVER, thumb_rollOverHandler, false, 0, true);
					_thumb.addEventListener(MouseEvent.MOUSE_OUT, thumb_rollOffHandler, false, 0, true);
					_thumb.addEventListener(MouseEvent.MOUSE_DOWN, thumb_mouseDownHandler, false, 0, true);
					_thumb.buttonMode = true;
					_thumbTimer.addEventListener(TimerEvent.TIMER, scrubContent_handler, false, 0, true);
					
					// enable track
					_track.addEventListener(MouseEvent.MOUSE_DOWN, track_mouseDownHandler, false, 0, true);
					
					// enable mouse wheel
					_scrollableContent.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel_handler, false, 0, true);
					this.addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel_handler, false, 0, true);
					
					_ifEnabled = true;
					
				}
			}
			else
			{
				if(_ifEnabled == true)
				{
					if(_ifUsingArrowBtns) // disable up and down arrow btns if present
					{
						_arrowBtnUp.removeEventListener(MouseEvent.MOUSE_OVER, arrowBtn_rollOverHandler);
						_arrowBtnUp.removeEventListener(MouseEvent.MOUSE_OUT, arrowBtn_rollOffHandler);
						_arrowBtnUp.removeEventListener(MouseEvent.MOUSE_DOWN, arrowBtn_mouseDownHandler);
						_arrowBtnUp.removeEventListener(MouseEvent.MOUSE_UP, arrowBtn_mouseUpHandler);
						
						_arrowBtnDown.removeEventListener(MouseEvent.MOUSE_OVER, arrowBtn_rollOverHandler);
						_arrowBtnDown.removeEventListener(MouseEvent.MOUSE_OUT, arrowBtn_rollOffHandler);
						_arrowBtnDown.removeEventListener(MouseEvent.MOUSE_DOWN, arrowBtn_mouseDownHandler);
						_arrowBtnDown.removeEventListener(MouseEvent.MOUSE_UP, arrowBtn_mouseUpHandler);
						
						_arrowBtnUp.buttonMode = false;
						_arrowBtnDown.buttonMode = false;
						
						_arrowTimer.removeEventListener(TimerEvent.TIMER, scrollContent_handler);
					}
					
					// disable scroll bar thumb
					_thumb.removeEventListener(MouseEvent.MOUSE_OVER, thumb_rollOverHandler);
					_thumb.removeEventListener(MouseEvent.MOUSE_OUT, thumb_rollOffHandler);
					_thumb.removeEventListener(MouseEvent.MOUSE_DOWN, thumb_mouseDownHandler);
					_thumb.buttonMode = false;					
					_thumbTimer.removeEventListener(TimerEvent.TIMER, scrubContent_handler);
					
					// disable track
					_track.removeEventListener(MouseEvent.MOUSE_DOWN, track_mouseDownHandler);
					
					// disable mouse wheel
					_scrollableContent.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel_handler);
					this.removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheel_handler);
					
					_ifEnabled = false;
				}
			}
		}
		
		
		
		/**
		 * Function allow us to set the delay for scrolling. Ie. how long between updates when scrolling
		 *  
		 * @param delay
		 */		
		public function set scrollDelay(delay:Number):void
		{
			_scrollDelay = delay;
		}
		
		/**
		 * Function allow us to set the movement for scrolling. Ie. how much to scroll on each update when scrolling 
		 * 
		 * @param delay
		 */	
		public function set scrollMovement(movement:Number):void
		{
			_scrollMovement = movement;
		}
		
		
		
		

		
		

		
		
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
///////////// FUNCTIONS BELOW ARE CONCERNED WITH THE MOUSE BEHAVIOUR FOR THE SROLL BARS OPTIONAL UP AND    ///////////
///////////// DOWN ARROW BUTTONS                                                                           ///////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
		
		/**
		 * Function handles what happens when the user rolls over one of the up or down arrow btns. 
		 * 
		 * <p>Shows the arrow buttons OVER state.</p>
		 * 
		 * @param event
		 */		
		private function arrowBtn_rollOverHandler(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _arrowBtnUp:
					_arrowBtnUp.showOverState();
					break;
				
				case _arrowBtnDown:
					_arrowBtnDown.showOverState();
					break;
				
				default:
			}
		}
		
		/**
		 * Function handles what happens when the user rolls off one of the up or down arrow btns. 
		 * 
		 * <p>Shows the arrow buttons OFF state.</p>
		 * 
		 * @param event
		 */
		private function arrowBtn_rollOffHandler(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _arrowBtnUp:
					_arrowBtnUp.showOffState();
					break;
				
				case _arrowBtnDown:
					_arrowBtnDown.showOffState();
					break;
				
				default:
			}
		}
		
		/**
		 * Function handles what happens when the user press's one of the up or down arrow btns.
		 * 
		 * <p>Shows the arrow buttons DOWN state AND start the scrolling of the _scrollableContent.</p>
		 * 
		 * @param event
		 */
		private function arrowBtn_mouseDownHandler(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _arrowBtnUp:
					_arrowBtnUp.showDownState();
					_scrollDirection = SCROLL_UP;
					
					if(!_arrowTimer.running) // if timer is not running start it to begin the scrolling
					{
						scrollContent_handler(); // call here so its fred straight away without having to wait for first timer interval
						_arrowTimer.start();
					}
					break;
				
				case _arrowBtnDown:
					_arrowBtnDown.showDownState();
					_scrollDirection = SCROLL_DOWN;
					
					if(!_arrowTimer.running) // if timer is not running start it to begin the scrolling
					{
						scrollContent_handler();// call here so its fred straight away without having to wait for first timer interval
						_arrowTimer.start();
					}
					break;
				
				default:
			}
		}
		
		/**
		 * Function handles what happens when the user releases the mouse on one of the up or down arrow btns. 
		 * 
		 * <p>Shows the arrow buttons OVER state AND stops the scrolling of the _scrollableContent.</p>
		 * 
		 * @param event
		 */
		private function arrowBtn_mouseUpHandler(event:MouseEvent):void
		{
			switch(event.target)
			{
				case _arrowBtnUp:
					_arrowBtnUp.showOverState();
					_scrollDirection = SCROLL_NONE;

					if(_arrowTimer.running) // if timer is running stop it to stop the scrolling
					{
						_arrowTimer.stop();
					}					break;
				
				case _arrowBtnDown:
					_arrowBtnDown.showOverState();
					_scrollDirection = SCROLL_NONE;

					if(_arrowTimer.running) // if timer is running stop it to stop the scrolling
					{
						_arrowTimer.stop();
					}
					break;
				
				default:
			}
		}
		
		
		/**
		 * Function called on timer event by the _arrowTimer while the user holds down one of the arrow buttons
		 * 
		 * @param event
		 */		
		private function scrollContent_handler(event:TimerEvent = null):void
		{
			// get min and max y positions for the _scrollableContent
			var minPosition:Number = _contentMask.y - (_scrollableContent.height - _contentMask.height);
			var maxPosition:Number = _contentMask.y;
			
			var targetY:Number;
			
			// scroll upwards
			if(_scrollDirection == SCROLL_UP && _scrollableContent.y < maxPosition)
			{
				if(_scrollableContent.y + _scrollMovement > maxPosition)
				{
					targetY = maxPosition;
					_arrowTimer.stop();
				}
				else
				{
					targetY = _scrollableContent.y + _scrollMovement
				}
				
				if(_useEasing)
				{
					TweenLite.to(_scrollableContent, _easeTime, {y:targetY});
					easeThumbPosition(targetY)
				}
				else
				{
					_scrollableContent.y = targetY;
					setThumbPosition();
				}
			}
			
			// scroll downwards
			if(_scrollDirection == SCROLL_DOWN && _scrollableContent.y > minPosition)
			{
				if(_scrollableContent.y - _scrollMovement < minPosition)
				{
					targetY = minPosition;
					_arrowTimer.stop();
				}
				else
				{
					targetY = _scrollableContent.y - _scrollMovement
				}
				
				if(_useEasing)
				{
					TweenLite.to(_scrollableContent, _easeTime, {y:targetY});
					easeThumbPosition(targetY);
				}
				else
				{
					_scrollableContent.y = targetY;
					setThumbPosition();
				}
			}
		}
		
		
		/**
		 * Function sets the current position of the scroll bar thumb depending on how much of the scrollable
		 * content has scrolled via interaction with the up and down arrow buttons
		 */		
		private function setThumbPosition():void
		{
			// get min and max y positions for the thumb
			var minPosition:Number = _track.y;
			var maxPosition:Number = _track.y + _track.height - _thumb.height;
			
			// get the max distance the scrollable content can move
			var amountScrollable:Number = _scrollableContent.height - _contentMask.height;
			
			if(amountScrollable >= 0) 
			{
				// get distance the thumb should move for every pixel the scrollable content moves
				var thumbUnit:Number = (maxPosition - minPosition) / amountScrollable;
				
				// get distance in pixels the scrollable content has already scrolled
				var amountScrolled:Number = _contentMask.y - _scrollableContent.y;
				
				// set thumb y position
				_thumb.y = minPosition + (amountScrolled*thumbUnit);
				
				if(_thumb.y > maxPosition)
				{
					_thumb.y = maxPosition;
				}
				if(_thumb.y < minPosition)
				{
					_thumb.y = minPosition;
				}
				
			}
			else
			{
				_thumb.y = minPosition;
			}
		}
		
		
		
		
		/**
		 * Function sets the current position of the scroll bar thumb depending on how much of the scrollable
		 * content has scrolled via interaction with the up and down arrow buttons.
		 * 
		 * <p>Same as <code>setThumbPosition</code> except this function uses easing</p>
		 */		
		private function easeThumbPosition(contentTargetY:Number):void
		{
			// get min and max y positions for the thumb
			var minPosition:Number = _track.y;
			var maxPosition:Number = _track.y + _track.height - _thumb.height;
			
			// get the max distance the scrollable content can move
			var amountScrollable:Number = _scrollableContent.height - _contentMask.height;
			
			if(amountScrollable >= 0) 
			{
				// get distance the thumb should move for every pixel the scrollable content moves
				var thumbUnit:Number = (maxPosition - minPosition) / amountScrollable;
				
				// get distance in pixels the scrollable content is to scroll
				var amountToScroll:Number = _contentMask.y - contentTargetY;
				
				// set thumb y position
				var newThumbYpos:Number = minPosition + (amountToScroll*thumbUnit);
				
				if(newThumbYpos > maxPosition)
				{
					newThumbYpos = maxPosition;
				}
				if(newThumbYpos < minPosition)
				{
					newThumbYpos = minPosition;
				}
				
				TweenLite.to(_thumb, _easeTime, {y:newThumbYpos});

			}
			else
			{
				_thumb.y = minPosition;
			}
		}
		
		
		
		
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
///////////// FUNCTIONS BELOW ARE CONCERNED WITH THE MOUSE BEHAVIOUR FOR THE SCROLL BARS DRAGGABLE THUMB /////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
		/**
		 * Function handles what happens when the user rolls over the scroll bar thumb. 
		 * 
		 * <p>Shows the thumbs OVER state.</p>
		 * 
		 * @param event
		 */		
		private function thumb_rollOverHandler(event:MouseEvent):void
		{
			if(!_ifThumbing)
			{
				_thumb.showOverState();
			}
		}
		
		/**
		 * Function habdles what happens when the user rolls off the scroll bar thumb. 
		 * 
		 * <p>Shows the thumbs OFF state.</p>
		 * 
		 * @param event
		 */
		private function thumb_rollOffHandler(event:MouseEvent):void
		{
			if(!_ifThumbing)
			{
				_thumb.showOffState();
			}
		}
		
		
		
		
		/**
		 * Function handles what to do when the user clicks on the scroll bar thumb and starts to drag/scrub it
		 * 
		 * @param event
		 */		
		private function thumb_mouseDownHandler(event:Event):void
		{
			_thumb.showDownState();
			
			_ifThumbing = true;
			
			// set drag boundaries and start dragging
			_thumb.startDrag(false, new Rectangle(_thumb.x, _track.y, 0, _track.height - _thumb.height));

			// stop dragging if mouse released
			_thumb.addEventListener(MouseEvent.MOUSE_UP, stopThumbDrag_handler, false, 0, true);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopThumbDrag_handler, false, 0, true);
			
			// start the timer
			_thumbTimer.start();
		}

		
		/**
		 * Function handles what to do when the user releases the mouse button while dragging /scrubbing the scroll bar thumb
		 * and hences stops the dragging/scrubbing of the thumb and the scrolling of the _scrollableContent
		 * 
		 * @param event
		 */	
		private function stopThumbDrag_handler(event:Event):void
		{
			if(event.target == _thumb) // if released over thumb
			{
				_thumb.showOverState();
			}
			else// if released somewhere somewhere else
			{
				_thumb.showOffState();
			}
			
			_ifThumbing = false;

			_thumb.stopDrag();// stop the dragging/scrubbing
			
			// remove listeners
			_thumb.removeEventListener(MouseEvent.MOUSE_UP, stopThumbDrag_handler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopThumbDrag_handler);
			
			// stop the timer
			_thumbTimer.stop();
		}
		
		
		/**
		 * Function called on timer event by the _thumbTimer when the user holds down the mouse while dragging the scroll bars thumb
		 * @param event
		 * 
		 */		
		private function scrubContent_handler(event:TimerEvent):void
		{
			// get min and max y positions for the thumb
			var minPosition:Number = _track.y;
			var maxPosition:Number = _track.y + _track.height - _thumb.height;
			
			// get distance above from the top (ie.minPosition) the thumb has moved
			var thumbDistance:Number = _thumb.y - minPosition;
			
			// get movement of thumb as a ratio of its total possible movement
			var thumbMovementRatio:Number = thumbDistance /(maxPosition - minPosition);
			
			// get the max dsistance the scrollable content can move
			var amountScrollable:Number = _scrollableContent.height - _contentMask.height;
			
			// calculate new position for _scrollableContent based on where the thumb has been dragged to 
			var newYpos:Number = _contentMask.y - (amountScrollable*thumbMovementRatio);
			
			if(_useEasing)
			{
				TweenLite.to(_scrollableContent, _easeTime, {y:newYpos});
			}
			else
			{
				_scrollableContent.y = newYpos;
			}

		}
		
		
		
		
		
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
///////////// FUNCTIONS BELOW ARE CONCERNED WITH THE MOUSE BEHAVIOUR FOR THE SCROLL BARS CLICKABLE TRACK /////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	

		/**
		 * Function handles what happens when the user clicks on the track. Jumps the thumb and _scrollableContent
		 * to new positions.
		 * 
		 * @param event
		 */
		private function track_mouseDownHandler(event:MouseEvent):void
		{
			// get min and max y positions for the thumb
			var minPosition:Number = _track.y;
			var maxPosition:Number = _track.y + _track.height - _thumb.height;
			
			// get clicked y point
			var clickedYpos:Number = event.target.mouseY + _track.y;
			
			/////// get new thumb position //////
			var newThumbYpos:Number;
			if(clickedYpos < _thumb.y)
			{
				newThumbYpos = clickedYpos;
			}
			else
			{
				newThumbYpos = clickedYpos - _thumb.height;//maxPosition;
			}
			if(newThumbYpos > maxPosition)
			{
				newThumbYpos = maxPosition
			}
			
			/////// get new scrollable content position /////
			var thumbDistance:Number = newThumbYpos - minPosition; // get distance above from the top (ie.minPosition) the thumb is moving to
			var thumbMovementRatio:Number = thumbDistance /(maxPosition - minPosition); // get movement of thumb as a ratio of its total possible movement
			var amountScrollable:Number = _scrollableContent.height - _contentMask.height; // get the max distance the scrollable content can move
			var newContentYpos:Number = _contentMask.y - (amountScrollable*thumbMovementRatio); // calculate new position for _scrollableContent based on where the thumb is moving to 
			
			if(_useEasing)
			{
				TweenLite.to(_thumb, _easeTime, {y:newThumbYpos});
				TweenLite.to(_scrollableContent, _easeTime, {y:newContentYpos});
			}
			else
			{
				_thumb.y = newThumbYpos;
				_scrollableContent.y = newContentYpos;

			}
			
		}
		
		
		
		
		
		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
///////////// FUNCTIONS BELOW ARE CONCERNED WITH THE MOUSE WHEEL BEHAVIUOR WHEN OVER THE SCROLL BAR AND //////////////
///////////// SCROLLABLE CONTENT (_scrollableContent)                                                   //////////////	
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
			
		/**
		 * Function handles what happens when the user uses the mouse wheel when over the Scroll Bar or the
		 * scrollable content(_scrollableContent).
		 * 
		 * @param event
		 */		
		private function mouseWheel_handler(event:MouseEvent):void
		{
			if(event.delta > 0 || event.delta < 0)
			{
				if(event.delta > 0)
				{
					_scrollDirection = SCROLL_UP;
				}
				else
				{
					_scrollDirection = SCROLL_DOWN;
				}
			}
			else
			{
				_scrollDirection = SCROLL_NONE;
			}
			
			// get min and max y positions for the _scrollableContent
			var minPosition:Number = _contentMask.y - (_scrollableContent.height - _contentMask.height);
			var maxPosition:Number = _contentMask.y;
			
			var targetY:Number;
			
			
			
			// scroll upwards
			if(_scrollDirection == SCROLL_UP && _scrollableContent.y < maxPosition)
			{
				if(_scrollableContent.y + _scrollMovement > maxPosition)
				{
					targetY = maxPosition;
				}
				else
				{
					targetY = _scrollableContent.y + _scrollMovement
				}
				
				if(_useEasing)
				{
					TweenLite.to(_scrollableContent, _easeTime, {y:targetY});
					easeThumbPosition(targetY)
				}
				else
				{
					_scrollableContent.y = targetY;
					setThumbPosition();
				}
			}
			
			// scroll downwards
			if(_scrollDirection == SCROLL_DOWN && _scrollableContent.y > minPosition)
			{
				if(_scrollableContent.y - _scrollMovement < minPosition)
				{
					targetY = minPosition;
				}
				else
				{
					targetY = _scrollableContent.y - _scrollMovement
				}
				
				if(_useEasing)
				{
					TweenLite.to(_scrollableContent, _easeTime, {y:targetY});
					easeThumbPosition(targetY);
				}
				else
				{
					_scrollableContent.y = targetY;
					setThumbPosition();
				}
			}
		}
		
		
	}
}