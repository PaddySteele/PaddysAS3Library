package com.patricksteele.effects.confetti
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * The ConfettiPiece class creates and returns a dynamically drawn, 4-sided piece of confetti.
	 * Randomization logic is included to determine which points to use when drawing each piece.
	 * Note that the registration point is set to the center of the clip, via the X and Y
	 * coordinates being the negative value of half of the width and height.
	 * 
	 * @author Anthony Hessler, Hessler Design (www.hesslerdesign.com)
	 * @author Edited slightly by Patrick Steele to remove any references to stage. Befoew this was done it was
	 * giving errors when added to views that had not been already placed on the Display List
	 * 
	 * 
	 */
	public class ConfettiPiece extends MovieClip 
	{
		
		private var confetti:MovieClip;
		private var maxSize_num:Number;
		
	
		/**
		 * @public 
		 * The ConfettiPiece class takes 1 optional parameter that sets the maximum
		 * size (both height and width) of the piece of confetti that is generated.
		 */
		public function ConfettiPiece(pMaxSize_num:Number=8) 
		{
			maxSize_num = pMaxSize_num;
			//this.addEventListener(Event.ADDED_TO_STAGE, init);
			init();
		}
		
		
	
		/**
		 * Initilization function 
		 * @param e
		 * @return 
		 * 
		 */		
		//private function init(event:Event):MovieClip
		private function init():MovieClip
		{
			var points_arr:Array = new Array();
			for(var i:Number = 0; i < 4; i++) 
			{
				var point:Number = randomNumber();
				points_arr[i] = point;
			}
			
			confetti = new MovieClip();
			confetti.graphics.beginFill(0x000000, 1);
			confetti.graphics.moveTo(points_arr[0], 0);
			confetti.graphics.lineTo(maxSize_num, points_arr[1]);
			confetti.graphics.lineTo(points_arr[2], maxSize_num);
			confetti.graphics.lineTo(0, points_arr[3]);
			confetti.graphics.lineTo(points_arr[0], 0);
			confetti.graphics.endFill();
			confetti.x = (confetti.width/2)*(-1);
			confetti.y = (confetti.height/2)*(-1);
			addChild(confetti);
			
			return confetti;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Random Number Generator Method
		//
		//--------------------------------------------------------------------------
		private function randomNumber():Number
		{
			return Math.random()*maxSize_num;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Override Methods
		//
		//--------------------------------------------------------------------------
		override public function get width():Number
		{
			return maxSize_num;
		}
		override public function get height():Number
		{
			return maxSize_num;
		}
		
	}
	
}