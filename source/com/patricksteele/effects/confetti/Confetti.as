package com.patricksteele.effects.confetti
{	

	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.ColorTransform;
	import flash.utils.*;
	
	/**
	 * The Confetti class creates a batch of confetti pieces that start at the top of the fall
	 * area and tween to the bottom of the fall area. Each piece of confetti created is given
	 * a randomly set design, rotation, X coordinate, fall time, tint, delay, scale, and alpha.
	 *
	 * Logic is included to determine when to add and remove individual pieces of confetti.
	 *
	 * The class extends MovieClip, to support multi-frame symbols that may be set to Export to
	 * ActionScript in the Library and passed in as the Class that the symbol uses when generating 
	 * new pieces of confetti.
	 *
	 * Note: The const AVERAGE_PIECE_DIVIDER is a number that is used in determining (a) the average
	 * number of pieces on screen at a given time, based on the fall height, and (b) the number of pieces
	 * of confetti (batch amount) to add each frame if the max number of pieces hasn't been reached.
	 * The value of this number is constant, because it was founded based on testing with an exhaustive
	 * set of samples that used a variety of fall heights, batch amounts, and max piece values.
	 *
	 * In short, the class creates a unique animation that mirrors the randomness of real confetti.
	 * 
	 * @author Anthony Hessler, Hessler Design (www.hesslerdesign.com)
	 * 
	 * @author Edited by Patrick Steele to remove any references to stage. Before this was done it was
	 * giving errors when added to views that had not been already placed on the Display List. Also removed any
	 * reference to the fl.motion.Color package and replaced with flash.geom.ColorTransform
	 * 
	 * @example
	 * <listing version="3.0">
	 * 
	 * // Default Confetti shapes
	 * var c:Confetti = new Confetti({width:500, height:200, colors:[0x003399, 0xcc0000, 0xcccc00, 0x00de00, 0x00dece], maxPieces:1000});
	 * addChild(c);
	 * c.start();
	 * 
	 * // Custom Confetti shapes
	 * var c:Confetti = new Confetti({width:500, height:200, symbol:myMovieClipClass, colors:[0x003399, 0xcc0000], maxPieces:1000});
	 * addChild(c);
	 * c.start();
	 * 
	 * </listing>
	 * 
	 *
	 */
	public class Confetti extends MovieClip 
	{
		
		private static const AVERAGE_PIECE_DIVIDER:Number = 2.3145;
		private static const DEFAULT_MAX_PIECES:Number = 1000;
		private static const MAX_PIECE_WARNING_THRESHOLD:Number = 3000;
		private static const DEFAULT_COLORS:Array = [0x000000];
		private static const DEFAULT_SYMBOL:Class = ConfettiPiece;
		
		/**
		 * added by Paddy 
		 */		
		private static const DEFAULT_WIDTH:Number = 500;
		private static const DEFAULT_HEIGHT:Number = 500;

		
		private var colors_arr:Array;
		private var container_mc:MovieClip;
		private var fallHeight_num:Number;
		private var fallWidth_num:Number;
		private var maxPieces_num:Number;
		private var minFallTime_num:Number;
		private var maxFallTime_num:Number;
		private var maxFallDelay_num:Number;
		private var totalPieces_num:Number;
		private var batchAmount_num:Number;
		//private var tintColor:Color;
		private var tintColor:ColorTransform
		private var attributes:Object;
		private var symbol:Class;
		
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @public
		 * The Confetti class takes 1 optional Object as a parameter. This Object can contain:
		 * 	- width:Number
		 * 	- height:Number
		 * 	- colors:Array of uint values (e.x. [0xff0000, 0x00cc00, 0x336699])
		 * 	- maxPieces:Number
		 * 	- symbol:Class (e.x. The Linkage Class name for an object in the Library.)
		 * 	- speed:Number (the lower the number, the faster the fall)
		 * 
		 * If no Object is passed in as a parameter, the Confetti class will generate default
		 * values for all of these attributes, within the setVariablesAndAttributes() function.
		 */
		public function Confetti(pObj:Object=null):void
		{
			attributes = pObj;
			//this.addEventListener(Event.ADDED_TO_STAGE, setVariablesAndAttributes);
			setVariablesAndAttributes();
		}
		
		/**
		 * @public
		 * The start() function actually begins the whole process of creating and animating the
		 * confetti. It is not done by default, so you can instantiate a new Confetti object in
		 * your project, and start it at a particular time later in the code.
		 */
		public function start():void
		{
			init();
		}
		
		/**
		 * @public
		 * The stop() function removes the event listener for adding new confetti pieces to the 
		 * display list, thus creating the effect of a smooth stop to the animation.
		 */
		override public function stop():void
		{
			removeEventListener(Event.ENTER_FRAME, checkForAdditionalConfetti);
		}
		
		/**
		 * @public
		 * The clear() function loops through all children of the container, removing
		 * every individual piece of confetti, killing its tween, and updating the
		 * totalPieces_num variable to reflect an accurate count of total pieces.
		 */
		public function clear():void
		{
			var lTotalConfettiPieces_num:Number = container_mc.numChildren;
			for (var i:Number = 0; i < lTotalConfettiPieces_num; i++) 
			{
				var lPiece:MovieClip = MovieClip(container_mc.getChildAt(0));
				TweenMax.killTweensOf(lPiece);
				container_mc.removeChildAt(0);
				totalPieces_num = container_mc.numChildren;
			}
		}
		
		/**
		 * @public
		 * The remove() function calls the clear() function to remove all pieces
		 * of confetti, and also calls the stop() function to stop the flow of new
		 * pieces by removing the enter frame event that makes new batches.
		 */
		public function remove():void
		{
			stop();
			clear();
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Initialization Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 *The setVariablesAndAttributes() function does just what it says - It sets local variable values.
		 * 
		 */
		//private function setVariablesAndAttributes(event:Event):void
		private function setVariablesAndAttributes():void
		{
			if(attributes) 
			{
				if(attributes.width) 
				{
					fallWidth_num = attributes.width;
				} 
				else 
				{
					fallWidth_num = DEFAULT_WIDTH;// stage.stageWidth;
				}
				if(attributes.height)
				{
					fallHeight_num = attributes.height;
				} 
				else 
				{
					fallHeight_num = DEFAULT_HEIGHT;//stage.stageHeight;
				}
				if(attributes.colors)
				{
					colors_arr = attributes.colors;
				}
				else 
				{
					colors_arr = DEFAULT_COLORS;
				}
				if(attributes.maxPieces)
				{
					maxPieces_num = attributes.maxPieces;
				}
				else
				{
					maxPieces_num = DEFAULT_MAX_PIECES;
				}
				if(attributes.symbol)
				{
					symbol = attributes.symbol;
				}
				else
				{
					symbol = DEFAULT_SYMBOL;
				}
				if(attributes.speed && (attributes.speed > 0))
				{
					minFallTime_num = attributes.speed;
				} 
				else 
				{
					minFallTime_num = fallHeight_num / 135;
				}
			} 
			else 
			{
				fallWidth_num = DEFAULT_WIDTH; //stage.stageWidth;
				fallHeight_num = DEFAULT_HEIGHT; //stage.stageHeight;
				minFallTime_num = fallHeight_num / 135;
				colors_arr = DEFAULT_COLORS;
				maxPieces_num = DEFAULT_MAX_PIECES;
				symbol = DEFAULT_SYMBOL;
			}
			
			if(maxPieces_num >= MAX_PIECE_WARNING_THRESHOLD) 
			{
				trace("WARNING: Setting a maxPiece value above 3,000 may result in severly decreased performance.");
			}
			
			// Set min and max fall times based on fall height, to keep same average fall rate for all heights.
			totalPieces_num = 0;
			//tintColor = new Color();
			tintColor = new ColorTransform();
			maxFallTime_num = minFallTime_num * 2.5;
			maxFallDelay_num = minFallTime_num;
			batchAmount_num = Math.floor(maxPieces_num/(fallHeight_num/AVERAGE_PIECE_DIVIDER));
			if (batchAmount_num < 1)
			{
				batchAmount_num = 1;
			}
		}
		
		/**
		 * @private
		 * The init() function sets the fall width and fall height values, if not already done.
		 * The container is created and added to the display list, and an initial batch of confetti
		 * is created. An Event.ENTER_FRAME listener is added, which calls the function to check
		 * if it is safe to create a new batch of confetti. The batches are created so a steady 
		 * stream of new flakes will be made for a relatively seamless looping animation.
		 *
		 * NOTE: The container_mc MovieClip MUST be created and added to the display list BEFORE
		 * the createBatchOfConfetti() function is called, as each piece of confetti is added to
		 * this container.
		 */
		private function init():void
		{
			container_mc = new MovieClip();
			addChild(container_mc);
			
			createBatchOfConfetti();
			
			addEventListener(Event.ENTER_FRAME, checkForAdditionalConfetti);
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Creation/Removal Methods
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private	
		 * The createBatchOfConfetti() function creates a batch of confetti, based on 
		 * the amount passed in as a parameter, and updates the totalPieces_num variable,
		 * which tracks the total number of MovieClips in existence..
		 */
		private function createBatchOfConfetti(pAmountToCreate_num:Number = 1):void
		{
			for (var i:Number = 0; i < pAmountToCreate_num; i++) 
			{
				var lNewbie:MovieClip = newConfetti();
				container_mc.addChild(lNewbie);
				totalPieces_num = container_mc.numChildren;
			}
		}
		
		/**
		 * @private	
		 * The newConfetti() function returns a new MovieClip with the randomly set design (if MovieClip has 
		 * multiple frames), rotation value, X coordinate, fall time, tint, delay, scale, and alpha. The 
		 * difference values for fall time, scale, and alpha really help create the effect of depth of field.
		 *
		 * Note that a tint is only set and applied if at least one hex value is set in colors_arr. This allows
		 * you to create your own colors in a unique MovieClip passed in as the Class to use in creation, and
		 * not have the tint default to black.
		 *
		 * The function also creates the tween for each object to use when falling.
		 *
		 * In short, this function creates a unique MovieClip object that contributes to the randomness of real confetti.
		 */
		private function newConfetti():MovieClip
		{
			var lNewbie:MovieClip = new symbol();
			var numFrames:Number = lNewbie.totalFrames;
			var design_num:Number = Math.ceil(Math.random() * numFrames);
			var posNegRotation_num:Number = Math.round(Math.random());
			
			if (posNegRotation_num == 0) 
			{
				posNegRotation_num--;
			}
			
			var tintHex:uint;
			
			if ((colors_arr) && (colors_arr.length > 0))
			{
				 tintHex = colors_arr[Math.floor(Math.random() * colors_arr.length)];
				// tintColor.setTint(tintHex, 1);
				// lNewbie.transform.colorTransform = tintColor;
				
				tintColor = lNewbie.transform.colorTransform;
				tintColor.color = tintHex;
				lNewbie.transform.colorTransform = tintColor;
				
			}
			
			var rotation_num:Number = Math.floor(Math.random() * 720 * (posNegRotation_num));
			var xPos_num:Number = Math.floor(Math.random() * fallWidth_num);
			var xShift_num:Number = Math.round(Math.random() * 30) * posNegRotation_num;
			var fallTime_num:Number = (Math.random() * (maxFallTime_num - minFallTime_num)) + minFallTime_num;
			var fallDelay_num:Number = Math.random() * maxFallDelay_num;
			var scale_num:Number = Math.random();
			var alpha_num:Number = Math.random()*0.5 + 0.5;
			
			lNewbie.gotoAndStop(design_num);
			lNewbie.rotation = rotation_num;
			lNewbie.x = xPos_num;
			lNewbie.y = (-1) * lNewbie.height;
			lNewbie.alpha = alpha_num;
			lNewbie.scaleX = lNewbie.scaleY = scale_num;
			
			TweenMax.to(lNewbie, fallTime_num, {x:(lNewbie.x + xShift_num), y:(fallHeight_num + lNewbie.height), ease:Linear.easeNone, rotation:(rotation_num*(-1)), delay:fallDelay_num, onComplete:removeConfettiPiece, onCompleteParams:[lNewbie]});
			
			return lNewbie;
		}
		
		/**
		 * @private
		 * The removeConfettiPiece() function removes confetti MovieClip from stage, and 
		 * updates totalPieces_num, which tracks the total number of MovieClips in existence.
		 */
		private function removeConfettiPiece(pTarget:MovieClip):void
		{
			container_mc.removeChild(pTarget);
			totalPieces_num = container_mc.numChildren;
		}
		
		
		//--------------------------------------------------------------------------
		//
		//  Event Handlers
		//
		//--------------------------------------------------------------------------
		
		/**
		 * @private
		 * The checkForAdditionalConfetti() function checks the total number of confetti pieces, 
		 * and if there are less than the maximum, creates a new batch.
		 */
		private function checkForAdditionalConfetti(event:Event):void
		{
			if (totalPieces_num < maxPieces_num)
			{
				createBatchOfConfetti(batchAmount_num);
			}
		}
		
	}
	
}

