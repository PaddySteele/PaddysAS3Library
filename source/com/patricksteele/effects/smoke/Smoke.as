package com.patricksteele.effects.smoke
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BlurFilter;

	
	/**
	 * Class defines a display object to simulate a smoke effect
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 *
	 * @example Below is an example of how a smoke effect can be created
	 * <listing version="3.0">
	 * 
	 * // create a smoke effect with 60 smoke particles and a smoke particle size of 20 px
	 * var smoke:Smoke = new Smoke(0x999999, 60, 20);
	 * addChild(smoke);
	 * smoke.x = 100;
	 * smoke.y = 100;
	 * 
	 * // start smoke particle movement
	 * smoke.startSmoke(); 
	 * </listing>
	 *  
	 */	
	public class Smoke extends MovieClip
	{
		/**
		 * The colour of the smoke 
		 */		
		private var _smokeCol:uint = 0x666666;
		
		/**
		 * The number of smoke particles 
		 */		
		private var _numOfParticles:uint = 60;
		
		/**
		 * the diameter of the smoke particles 
		 */		
		private var _smokeParticalSize:Number;
		
		/**
		 * an array to hold reference to all the smoke particles 
		 */		
		private var _arrParticles:Array;
		
		/**
		 * a Sprite to hold the smoke particles 
		 */		
		private var _smokeContainer:Sprite;
		
		
		/**
		 * 
		 * @param col			The colour of the smoke
		 * @param numParticles	The number of SmokeParticle objects used to create the smoke
		 * @param particalSize	The size of the smoke particles
		 * 
		 */		
		public function Smoke(col:uint, numParticles:Number, particalSize:Number)
		{
			_smokeCol = col;
			_numOfParticles = numParticles;
			_smokeParticalSize = particalSize;
			
			_arrParticles = new Array();
			_smokeContainer = new Sprite();
			
			// add Sprite to hold the smoke particles
			addChild(_smokeContainer);
			
			// apply a blur filter to the sprite that will contain the smoke particles to make the smoke look more realistic
			_smokeContainer.filters = [new BlurFilter(_smokeParticalSize, _smokeParticalSize, 1)];
		}
		
		
		/**
		 * Function starts the smoke movement. 
		 * 
		 */		
		public function startSmoke():void
		{
			this.addEventListener(Event.ENTER_FRAME, makeSmoke);
		}
		
		/**
		 * Function stops the smoke movement 
		 * 
		 */		
		public function stopSmoke():void
		{
			this.removeEventListener(Event.ENTER_FRAME, makeSmoke);
		}
		
		/**
		 * Function called on every enter frame to add a new smoke particle if current amount is currently below _numOfParticles.
		 * Function then updates each existing SmokeParticle object
		 * 
		 * @param event
		 */				
		private function makeSmoke(event:Event):void
		{
			var tempParticle:SmokeParticle;
		
			// create a new SmokeParticle if there are currently less than _numOfParticles
			if(_arrParticles.length < _numOfParticles)
			{
				var smokeParticle:SmokeParticle = new SmokeParticle(_smokeCol, _smokeParticalSize);
				_smokeContainer.addChild(smokeParticle);
				_arrParticles.push(smokeParticle);
				initSmokeParticle(smokeParticle);
			}
			else // if already the max amount of smoke particles reset the first one in the _arrParticles Array and move it to end of the Array
			{
				tempParticle = _arrParticles.shift();
				initSmokeParticle(tempParticle);
				_arrParticles.push(tempParticle);
			}
			
			// update the properties of all the smoke particles to create the animating smoke effect
			for(var i:uint = 0; i < _arrParticles.length; i++)
			{
				_arrParticles[i].update();
				
				// if any smoke particles are invisible reset them to inital state
				if(_arrParticles[i].alpha <= .01)
				{
					initSmokeParticle(_arrParticles[i]);
				}
			}
		}
		
		
		/**
		 * Function sets/resets the initial properties of a smoke particle
		 * 
		 * @param smokeParticle	The Smokeparticle object to be manipulated
		 */		
		private function initSmokeParticle(smokeParticle:SmokeParticle):void
		{
			// set initial position within _smokeContainer
			smokeParticle.x = 0;
			smokeParticle.y = 0;
			
			// set initial properties of SmokeParticle object
			smokeParticle.gravity = -.05;
			smokeParticle.friction = 1.02;
			smokeParticle.yVelocity = Math.random() * 1 - 1; // val between -2 and -1
			smokeParticle.xVelocity = Math.random() * 1 - 0.5; // val between -0.5 and 0.5
			smokeParticle.fade = 0.95;
			smokeParticle.spin = 2;
			smokeParticle.growX = 1.02;
			smokeParticle.growY = 1.02;
			
			// set alpha, scaling and rotation of the smoke particle
			smokeParticle.alpha = Math.random() * 0.5 + 0.5; // val between 0.5 and 1
			smokeParticle.scaleX = smokeParticle.scaleY = Math.random() * .5 + .5; // val between 0.5 and 1
			smokeParticle.rotation = Math.random() * 360 - 180; // val between -180 and 180
		}
		
		
	}
}