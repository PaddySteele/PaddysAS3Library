package com.patricksteele.video
{
    import flash.display.Sprite;
    import flash.events.NetStatusEvent;
    import flash.media.SoundTransform;
    import flash.media.Video;
    import flash.net.NetConnection;
    import flash.net.NetStream;
	
		
	/**
 	* This class defines a custom FLV player that plays flv by progressive download. 
	*
	* @author Patrick Steele
	* @date 10.03.2010
	* 
	* @example The following code shows how to set up a VideoPlayer obj and load in a video to be played
	* <listing version="3.0">
	* 		var vidPlayer:VideoPlayer = new VideoPlayer(320, 240, true, 20, 10);
			vidPlayer.loadVideo("flv/wayout.flv");
	* </listing>
	* 
 	*/
    public class VideoPlayer extends Sprite
	{
        /**
		* Need a NetStream Object to load and control playback of the video. The NetStream constructor requires that we pass it a 
		* NetConnection Object. A NetConnection Object determines the origin of the data that a NetStream Object handles.
		* Can think of a NetStream as a single stream of media thats flowing inside of the NetConnection Object. (Can have 
		* multiple NetStreams flowing through the same NetConnection)
		* @private
		*/
		private var _ns:NetStream;
		
		/**
		* When the Flash Video streams from a Flash Communication Server or a Flash Media Server the NetConnection points to the
		* server. However for Progressive download video content the NetConnection object uses a null connection string.
		* Can think of a NetConnection as the main pipe line to outside world where external media can come in through
		* @private
		*/
		private var _nc:NetConnection;
	
		/**
		* An NetStream Object is only concerned with moving data and does not know how to render the data as a video therefore we
		* need a Video Object to display the video. The Video Object allows you to pass it a NetStream Object and then uses the
		* NetStream data to render the video to screen.
		* @private
		*/
		private var _video:Video;
		
		/**
		 * Object used to handle metadata events
		 */		
		private var _client:Object;

		/**
		 * path to FLV file to be loaded and played back by th VideoPlayer
		 */		
		private var _flvPath:String;
		
		/**
		 * stores the total duration of the loaded flv in seconds
		 */		
		private var _videoDuration:uint = 0;
		
		/**
		 * whether the video is currently playing
		 */		
		private var _isVideoPlaying:Boolean = false;
		
		/**
		 * if the VideoPlayer autoplays a flv when it is loaded
		 */		
		private var _autoPlay:Boolean = false;
		
		private var _loopPlayback:Boolean = false;
		
		/**
		 * a SoundTransform Object used to control the videos volume
		 */		
		private var _soundTransform:SoundTransform;
		
		/**
		 * dimensions to play the video back at 
		 */		
		private var _videoWidth:Number = 320;
		private var _videoHeight:Number = 320;
		
		/**
		 * a border for around the Video object 
		 */		
		private var _videoBorder:Sprite;
		
		/**
		 * if we want to display a control bar to allow control of video during playback  
		 */		
		private var _showControlBar:Boolean = true;
		
		/**
		 * The ControlBar object used for controlling Video playback if the _showControlBar value above is 'true'
		 */		
		private var _controlBar:VideoControlBar;
		
				
		/**
		 * CONSTRUCTOR
		 * 
		 * @param flvWidth			The width at which a loaded flv should be rendered
		 * @param flvHeight			The height at which a loaded flv should be rendered
		 * @param autoPlay			If the VideoPlayer automatically plays a Video when it is loaded
		 * @param initialVolume		The volume of the Video at the start compared to it's maximum
		 * @param showControlBar	If the VideoPlayer has a control bar to allow control of Video during playback
		 * @param controlBarHeight	Height of videos control bar if there is one
		 * @param borderPadding		Padding bewteen the border and edges of the Video
		 * 
		 */		 
		public function VideoPlayer(flvWidth:Number, flvHeight:Number, autoPlay:Boolean = false, loop:Boolean = false, initialVolume:Number = 0.75, showControlBar:Boolean = true, controlBarHeight:Number = 20, borderPadding:Number = 5)
		{
			_videoWidth = flvWidth;
			_videoHeight = flvHeight;
			_showControlBar = showControlBar;
			_autoPlay = autoPlay;
			_loopPlayback = loop;
			
			// TODO: prevent video from being too small. ie If _videoWidth < 100 set _videoWidth = 100
			
			// call function to set up the display of the video player
			setUpDisplay(controlBarHeight, borderPadding);

			// setup NetConnection
			_nc = new NetConnection();
			_nc.connect(null); // set to 'null' as not using a media server ie.Flash Media Server
			
			// setup NetStream
			_ns = new NetStream(_nc); // pass the NetStream constructor an argument specifing the NetConnection it should flow through
			_ns.addEventListener(NetStatusEvent.NET_STATUS, onStatusEvent);
			
			// display and position the Video
			_video = new Video(_videoWidth, _videoHeight);// 320*240 are the default dimensions
			this.addChild(_video);
			_video.x = borderPadding;
			_video.y = borderPadding;

			// call function that takes care of handling metadata and cue point events
			handleMetaDataAndCuePoints();

			// associate a NetStream Object with a Video Object. Now any video data controlled by  
			// the NetStream Object will be rendered by the Video Object
			_video.attachNetStream(_ns);
			//_ns.setBufferTime(10);
			
			
			// set up volume control
			_soundTransform = new SoundTransform();
			_soundTransform.volume = initialVolume; // initially set volume to 75%
			_ns.soundTransform = _soundTransform;
        }
		
		
		
		
		/**
		 * Function sets up the display of the video player such as the border and control bar (if present)
		 * 
		 * @param controlBarHeight
		 * @param borderPadding
		 * @param borderCol
		 * 
		 */		
		private function setUpDisplay(controlBarHeight:Number, borderPadding:Number):void
		{
			// add sprite into which the video players border will be drawn
			_videoBorder = new Sprite();
			addChild(_videoBorder);
			
			// if no control bar
			if(_showControlBar == false)
			{
				controlBarHeight = 0;
			}
			
			// determine the height and width the _videoBorder Sprite needs to be
			var borderW:Number = _videoWidth + (2*borderPadding);
			var borderH:Number = _videoHeight + (3*borderPadding) + controlBarHeight;
			
			// draw the border
			_videoBorder.graphics.lineStyle();
			_videoBorder.graphics.beginFill(0xCCCCCC);
			_videoBorder.graphics.drawRoundRect(0, 0, borderW, borderH, 10);
			_videoBorder.graphics.endFill();
			
			// if using a control bar create and add it to the display
			if(_showControlBar)
			{
				_controlBar = new VideoControlBar(this, _videoWidth, controlBarHeight);				
				addChild(_controlBar);
				_controlBar.x = borderPadding;
				_controlBar.y = _videoHeight + (borderPadding*2);
			}
		}
		
		
		
		/**
		 * This function recieves path to a flv file and commences loading/playback 
		 * 
		 * @param flvPath
		 */		
		public function loadVideo(flvPath:String):void
		{
			if(_flvPath > "") // if already a video loaded get rid of it
			{
				_ns.close();
			}
			
			_flvPath = flvPath;
			
			// load and start playback of external flv
			_ns.play(_flvPath); // tell the NetStream which flv to play
		}
						


		
		/**
		 * When a NetStream object is loading a FLV file it automatically calls an onMetaData() callback method when the
		 * metadata has loaded. This event is triggered after a call to the NetStream.play() method, but before the
		 * video playhead has advanced.
		 * The callback model differs from the standard event model used by most of the ActionScript 3.0 API's
		 * In most cases in which you work with events you add a listener using addEventListener(). However, in the case
		 * of metadata events you must define an onMetaData() method for an Object and then assign that Object to the
		 * client property of the NetStream Object. The method is automatically passed an associativce array parameter
		 * typed as Object that contains properties and values corresponding to each of the metadata properties that
		 * have been read from the FLV file.
		 * 
		 * <p>If a FLV contains metadata and/or cue points and the events are not handled Flash Player throws errors</p>
		*/
		private function handleMetaDataAndCuePoints():void
		{
			// create Object with an onMetaData callback method that that will be
			// called when NetStream meta data is recieved	
			_client = new Object();
			
			// define onMetaData and onCurePoint methods for the object			
			_client.onMetaData = nsMetaDataCallback; 
			_client.onCuePoint = onCue;
			
			// assign created Object to the client property of the NetStream Object.
			_ns.client = _client;		  
		}
		
        /**
         * Dispatched when the application receives descriptive information embedded in the video being played.
         * The onMetaData() callback method called once the flv's metadata has loaded. 
         * Allows us to catch important meta data such as the flv's duration
         * @param mdata
         * 
         */        
        private function nsMetaDataCallback(mdata:Object):void 
		{
			_videoDuration = mdata.duration; // get duration (secs) of flv
			
			var info:String;
			for(info in mdata)
			{
				trace(info + ":" + mdata[info]);
			}
			
			// once we have the flv duration decide whether to autoplay the video 
			if(_autoPlay)
			{
				_isVideoPlaying = true;
			}
			else
			{
				_ns.seek(0); // so 1st frame is shown
				_ns.pause(); // pause the video
				_isVideoPlaying = false;
			}
			
			// initilize the control bar for the newly loaded video file
			_controlBar.initControlBar();			
        }
		
		 /**
         * The onCuePoint() method. Invoked when an embedded cue point is reached while playing a video file.
         * @param mdata
         * 
         */  
        private function onCue(info:Object):void 
		{
            trace("cuepoint: time=" + info.time + " name=" + info.name + " type=" + info.type);
        }
    
	
		/**
		 * This function is fired when there is a change in the Videos status  
		 * @param stat
		 * 
		 */		
		private function onStatusEvent(stat:Object):void
		{
			switch(stat.info.code)
			{
				// The FLV passed to the play() method can't be found.
				case "NetStream.Play.StreamNotFound":
                    trace("Stream not found "+_flvPath+"");
                    break;

				// Playback has started.
				case "NetStream.Play.Start":
					trace("NetStream.Play.Start");
					break;
				
				// Playback has stopped.
				case "NetStream.Play.Stop":
					trace("NetStream.Play.Stop");
					
					/* if(time == duration)
					{
						if _loopPlayback
					}
					*/
					playbackComplete();	 
					break;		
					
				// The buffer is full and the stream will begin playing.
				case "NetStream.Buffer.Full":
					trace("NetStream.Buffer.Full");
					//mc_bufferTxt._visible = false;
					break;
					
				// Data is not being received quickly enough to fill the buffer. Data flow will be interrupted 
				// until the buffer refills, at which time a NetStream.Buffer.Full message will be sent and the stream will begin playing again.
				case "NetStream.Buffer.Empty":
					trace("NetStream.Buffer.Empty");
					//mc_bufferTxt._visible = true;
					break;
					
				// Data has finished streaming, and the remaining buffer will be emptied.
				case "NetStream.Buffer.Flush": 
					trace("NetStream.Buffer.Flush");
					//mc_bufferTxt._visible = true;
					break;
					
				default:
					trace("###"+stat.info.code);
					break;
			}					
		}
		
		
		/**
		 * function returns the playhead to the start oncee the whole video file has been played
		 * 
		 */		
		private function playbackComplete():void
		{
			_ns.seek(0);

			// decide whether to autoplay the video 
			if(_autoPlay)
			{
				_isVideoPlaying = true;
			}
			else
			{
				_ns.pause(); // pause the video
				_isVideoPlaying = false;
			}
			
		}
		
		
////////////////////////////////////////////////////////////////////////////////////////////////////
////////// THE PUBLIC FUNCTIONS BELOW ALLOW CONTROL OF THIS VideoPlayer VIA THE _controlBar ////////
////////////////////////////////////////////////////////////////////////////////////////////////////
		
		/**
		 * Function returns the percentage of the video file that has loaded so far
		 * 
		 * @return 
		 */		
		public function getPercentageLoaded():Number
		{
			var perLoaded:Number = (_ns.bytesLoaded / _ns.bytesTotal) * 100;
			return perLoaded;			
		}
		
		
		/**
		 * Function moves the playhead to the specified time in the video file 
		 * 
		 * @param secs
		 * 
		 */		
		public function seekToPosition(secs:Number):void
		{
			_ns.seek(secs);			
		}
		
	
		/**
		 * Function returns if the loaded video file is currently playing or paused 
		 * 
		 * @return 
		 * 
		 */		
		public function checkPlayStatus():Boolean
		{
			return _isVideoPlaying;			
		}
		
		
		/**
		 * Function returns the total duration in secs of the currently loaded video file 
		 * @return 
		 * 
		 */		
		public function getVideoDuration():Number
		{
			return _videoDuration;
		}
		
		/**
		 * Function returns the current position of the playhead in secs 
		 * @return 
		 * 
		 */		
		public function getVideoPosition():Number
		{
			return _ns.time;//Math.floor(_ns.time);
		}
		
		
	
		/**
		 * Function pauses and unpauses the playback of the currently loaded flv file
		 * 
		 * @param ifPlay
		 * 
		 */		
		public function playVideo(ifPlay:Boolean):void
		{
			if(ifPlay == true)
			{
				_ns.resume(); // resume the video
				_isVideoPlaying = true;
			}
			else
			{
				_ns.pause(); // pause the video
				_isVideoPlaying = false;				
			}
		}
		
		
		/**
		 * function allows pausng of video playback if the _controlBar is scrubbing the playhead position 
		 * 
		 */		
		public function scrubbing():void
		{
			_ns.pause(); // pause the video
		}
		
		

		
		public function setVideoVolume(vol:Number):void
		{
			_soundTransform.volume = vol;
		}
		
		

		

		
		
    }
}