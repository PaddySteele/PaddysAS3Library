package com.patricksteele.video
{
	import com.patricksteele.utils.Calculations;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	

	/**
	 * This class defines a display obj with controls for controlling the playback of a video file
	 * via the VideoPlayer class.
	 * 
	 * <p>Contains a play/pause btn, a load progress bar, a play progress bar, rewind to start btn,
	 * volume slider</p>
	 * 
	 * @author Patrick Steele
	 * @date 10.03.2010
	 * 
	 * 
	 */ 	
	public class VideoControlBar extends Sprite
	{
		/**
		 * reference to the VideoPlayer object that this VideoControlBar will control 
		 */		
		private var _parent:VideoPlayer;
		
		/**
		 * background for the control bar 
		 */		
		private var _bg:Sprite;
		
		/**
		 * the dimensions of the Control Bar 
		 */		
		private var _controlBarWidth:Number;
		private var _controlBarHeight:Number;

		/**
		 * Play Pause Btn 
		 */		
		private var _playPauseBtn:PlayPauseBtn;
		
		/**
		 * Rewind to start btn 
		 */		
		private var _rewindToStartBtn:RewindBtn;
		
		/**
		 * slider objec to control the volume 
		 */		
		private var _volSlider:VolumeSlider;
		
		/**
		 * load progress bar 
		 */		
		private var _loadProgressBar:Sprite;
		
		/**
		 * play progress br 
		 */		
		private var _playProgressBar:Sprite;
		
		/**
		 * the width for the load and play progress bar's 
		 */		
		private var _progressBarWidth:Number = 100;
		
		
		/**
		 * Textfield for displying the current time of the playhead in the _parent VideoPlayer 
		 */		
		private var _tfVideoClock:TextField;
		
				
		/**
		 * Timer used to display the progress of the videos download
		 */		
		private var _videoLoadingTimer:Timer;
		
		/**
		 * Timer used to display the progress of the videos playhead and clock 
		 */		
		private var _videoPlayingTimer:Timer;
		
		/**
		 * Timer used when scrubbing the video playhead position 
		 */		
		private var _scrubVideoTimer:Timer;
		
		
		/**
		 * CONSTRUCTOR
		 *  
		 * @param parent
		 * @param barWidth
		 * @param barHeight
		 * 
		 */		
		public function VideoControlBar(parent:VideoPlayer, barWidth:Number, barHeight:Number):void
		{
			_parent = parent;			
			_controlBarWidth = barWidth;
			_controlBarHeight = barHeight;
			
			// 	background for the control bar
			_bg = new Sprite();
			_bg.graphics.clear();
			_bg.graphics.lineStyle();
			_bg.graphics.beginFill(VideoPlayerStyling.vpControlBarBgCol);
			_bg.graphics.drawRect(0, 0, _controlBarWidth, _controlBarHeight);
			_bg.graphics.endFill();
			addChild(_bg);
			
			
			// ADD REWIND TO START BTN
			_rewindToStartBtn = new RewindBtn(_controlBarHeight, _controlBarHeight);
			addChild(_rewindToStartBtn);
			
			// ADD PLAY/PAUSE BTN
			_playPauseBtn = new PlayPauseBtn(_controlBarHeight, _controlBarHeight);
			addChild(_playPauseBtn);
			_playPauseBtn.x = _rewindToStartBtn.width;					
			
			// ADD LOAD PROGRESS BAR
			_loadProgressBar = new Sprite();
			_loadProgressBar.graphics.lineStyle();
			_loadProgressBar.graphics.beginFill(VideoPlayerStyling.vpLoadProgressBarCol);
			_loadProgressBar.graphics.drawRect(0, 0, _progressBarWidth, 10);
			_loadProgressBar.graphics.endFill();
			addChild(_loadProgressBar);
			_loadProgressBar.y = 5;
			_loadProgressBar.x = _playPauseBtn.x + _playPauseBtn.width;
			
			// ADD PLAY PROGRESS BAR
			_playProgressBar = new Sprite();
			_playProgressBar.graphics.lineStyle();
			_playProgressBar.graphics.beginFill(VideoPlayerStyling.vpPlayProgressBarCol);
			_playProgressBar.graphics.drawRect(0, 0, _progressBarWidth, 10);
			_playProgressBar.graphics.endFill();
			addChild(_playProgressBar);
			_playProgressBar.mouseEnabled = false;
			_playProgressBar.y = _loadProgressBar.y;
			_playProgressBar.x = _loadProgressBar.x;
			
			
			// ADD CLOCK TEXTFIELD
			var clockFormat:TextFormat = new TextFormat();
			clockFormat.font = "Arial";
			clockFormat.size = 11;
			clockFormat.align = TextFormatAlign.LEFT;
			_tfVideoClock = new TextField();
			_tfVideoClock.defaultTextFormat = clockFormat;
			//_tfVideoClock.embedFonts = true;
			_tfVideoClock.antiAliasType = AntiAliasType.ADVANCED;
			_tfVideoClock.autoSize = TextFieldAutoSize.LEFT;
			_tfVideoClock.textColor = VideoPlayerStyling.vpClockTextCol;
			_tfVideoClock.selectable = false;
			_tfVideoClock.multiline = false;
			_tfVideoClock.wordWrap = false;
			_tfVideoClock.text = "00:00";
			addChild(_tfVideoClock);
			_tfVideoClock.x = 160;
			_tfVideoClock.y = 0;
			
			
			_volSlider = new VolumeSlider(60,20);
			addChild(_volSlider);
			_volSlider.x = _tfVideoClock.x + _tfVideoClock.width;
			
			
			
			// set up event listeners for the various controls
			_rewindToStartBtn.addEventListener(MouseEvent.CLICK, rewindBtn_clicked_handler);
			_playPauseBtn.addEventListener(MouseEvent.CLICK, playPauseBtn_clicked_handler);
			_loadProgressBar.addEventListener(MouseEvent.MOUSE_DOWN, startScrub_handler);
			
			
			
			// create the Timers needed by the VideoControlBar			
			_videoLoadingTimer = new Timer(100);
			_videoPlayingTimer = new Timer(100);
			_scrubVideoTimer = new Timer(100);
		}
		
		
		/**
		 * Function initilizes this VideoControlBar for a newly loaded video file in _parent VideoPlayer class
		 * 
		 * @see VideoControlBar#nsMetaDataCallback
		 */		
		public function initControlBar():void
		{
			// set up Timer used to display the progressive load progress for a flv file	
			_videoLoadingTimer.addEventListener(TimerEvent.TIMER, videoLoadingTimer_handler);
			_videoLoadingTimer.start();
			
			
			// set up Timer used to visually display the playhead position for a flv file
			_videoPlayingTimer.addEventListener(TimerEvent.TIMER, videoPlayingTimer_handler);
			
			// set initital width of _playProgressBar
			_playProgressBar.width = 0;
			
			// check if video is autoplayed
			if(_parent.checkPlayStatus())
			{
				_videoPlayingTimer.start();
				_playPauseBtn.showPlaySymbol();
			}
			else
			{
				_playPauseBtn.showPauseSymbol();
			}
			
			// set up Timer to handle scrubbing of payhead position when user clicks and drags on the _loadProgressBar
			_scrubVideoTimer.addEventListener(TimerEvent.TIMER, scrubVideoTimer_handler);
			
			
		}
		
		
		/**
		 * This function updates the _loadProgressBar to display the load progress of the video file 
		 * loaded in the _parent VideoPlayer
		 * @param event
		 * 
		 */		
		private function videoLoadingTimer_handler(event:TimerEvent):void
		{
			// check how much of the video has downloaded so far
			var percentLoaded:Number = _parent.getPercentageLoaded();
			
			_loadProgressBar.width = Math.floor(percentLoaded * (_progressBarWidth/100));

			// when download has completed stop the Timer and remove listener
			if(percentLoaded == 100)
			{
				_videoLoadingTimer.stop();
				_videoLoadingTimer.removeEventListener(TimerEvent.TIMER, videoLoadingTimer_handler);
			}
		}
		
		
		/**
		 * This function updates the _playProgressBar and _tfVideoClock to display the current playhead position 
		 * of the video file playing in the _parent VideoPlayer obj
		 * 
		 * @param event
		 * 
		 */	
		private function videoPlayingTimer_handler(event:TimerEvent):void
		{
			if(!_parent.checkPlayStatus()) // if NOT currently playing
			{
				_playPauseBtn.showPauseSymbol();
				_videoPlayingTimer.stop();
			}
				
			
			var totalSecs:Number = _parent.getVideoDuration();
			var secsGone:Number = _parent.getVideoPosition();				
			var progressRatio:Number = secsGone/totalSecs;	
			_playProgressBar.width = progressRatio * _progressBarWidth;
				
			var strTime:String = Calculations.getTimeCode(secsGone);
			_tfVideoClock.text = strTime;
		}
		
		
		/**
		 * function handles what happens when the _rewindBtn button is clicked. 
		 * Returns the loaded video in the _parent VideoPlayer to its start
		 * 
		 * @param event
		 * 
		 */				
		private function rewindBtn_clicked_handler(event:MouseEvent):void
		{
			_parent.seekToPosition(0);
			_playProgressBar.width = 0;
			var strTime:String = Calculations.getTimeCode(0);
			_tfVideoClock.text = strTime;
			
			/* if(_parent.checkPlayStatus()) // if currently playing, pause the video
			{
				_parent.playVideo(false);
				_playPauseBtn.showPauseSymbol();
				_videoPlayingTimer.stop();
			}
			else // if currently paused, play the video
			{
				_parent.playVideo(true);
				_playPauseBtn.showPlaySymbol();
				_videoPlayingTimer.start();
			} */
		}
		

		/**
		 * function handles what happens when the _playPauseBtn button is clicked. Will either play or pause
		 * the loaded video in the _parent VideoPlayer
		 * 
		 * @param event
		 * 
		 */				
		private function playPauseBtn_clicked_handler(event:MouseEvent):void
		{
			if(_parent.checkPlayStatus()) // if currently playing, pause the video
			{
				_parent.playVideo(false);
				_playPauseBtn.showPauseSymbol();
				_videoPlayingTimer.stop();
			}
			else // if currently paused, play the video
			{
				_parent.playVideo(true);
				_playPauseBtn.showPlaySymbol();
				_videoPlayingTimer.start();
			}
		}
		
		
		
		
		
		/**
		 * function starts to scrub the _playProgressBar when the _loadProgressBar is pressed
		 * @param event
		 * 
		 */		
		private function startScrub_handler(event:MouseEvent):void
		{
			this.addEventListener(MouseEvent.MOUSE_UP, stopScrub_handler);
			_parent.addEventListener(MouseEvent.MOUSE_UP, stopScrub_handler);
			stage.addEventListener(MouseEvent.MOUSE_UP, stopScrub_handler);
			
			if(_parent.checkPlayStatus()) // temporarially stop playback while we scrub
			{
				_parent.scrubbing();
				_videoPlayingTimer.stop(); 
			}
			
			scrubVideoTimer_handler();
			_scrubVideoTimer.start();
		}
		
		
		
		/**
		 * function stops scrubbing the _playProgressBar when the _loadProgressBar is released
		 * @param event
		 * 
		 */		
		private function stopScrub_handler(event:MouseEvent):void
		{
			//_loadProgressBar.removeEventListener(MouseEvent.MOUSE_UP, stopScrub_handler);
			this.removeEventListener(MouseEvent.MOUSE_UP, stopScrub_handler);
			_parent.removeEventListener(MouseEvent.MOUSE_UP, stopScrub_handler);
			stage.removeEventListener(MouseEvent.MOUSE_UP, stopScrub_handler);
			
			_scrubVideoTimer.stop();
			
			if(_parent.checkPlayStatus())
			{
				_parent.playVideo(true);
				_videoPlayingTimer.start(); // resume playback if it was active before we started scrubbing
			}
		}
		
		/**
		 * function habndles scrubbing of the _playProgressBar and the associated playhead position in 
		 * the _parent VideoPlayer
		 * @param event
		 * 
		 */		
		private function scrubVideoTimer_handler(event:TimerEvent = null):void
		{
			var xPos:Number = _loadProgressBar.mouseX;

			if(xPos > _loadProgressBar.width)
			{
				xPos = _loadProgressBar.width;
			}
			
			if(xPos < 0)
			{
				xPos = 0;
			}
			
			// update _playProgressBar width
			var newProgressWidth:Number = xPos;
			_playProgressBar.width = newProgressWidth;
			
			// set new position of playhead in _parent VideoPlayer
			var progressRatio:Number = xPos/_progressBarWidth;			
			var newPlayHeadPosition:Number = progressRatio * _parent.getVideoDuration();
			_parent.seekToPosition(newPlayHeadPosition);
			
			// update clock to match scrub
			var secsGone:Number = _parent.getVideoPosition();		
			var strTime:String = Calculations.getTimeCode(newPlayHeadPosition);
			_tfVideoClock.text = strTime;
			
		}
		
		

	}
}