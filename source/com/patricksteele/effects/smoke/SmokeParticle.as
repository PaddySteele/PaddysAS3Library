package com.patricksteele.effects.smoke
{
	import flash.display.Sprite;
	
	/**
	 * Class defines a single smoke particle to be used in the Smoke class. The smoke particles properties can
	 * be updated using its <code>update()</code> function
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 */	
	public class SmokeParticle extends Sprite
	{
		/**
		 * Amount to move the smoke particle's x position on each update 
		 */		
		private var _xVelocity:Number = 0;
		
		/**
		 * Amount to move the smoke particle's y position on each update 
		 */	
		private var _yVelocity:Number = 0;
		
		/**
		 * Allows us to accelerate or deccelerate the smoke particle's vertical movement. This is done by adding
		 * the _gravity value to the _yVelocity value on each update allowing us to increase/decrease the _yVelocity
		 * value over time
		 */		
		private var _gravity:Number = 0;
		
		/**
		 * This allows us to apply an easing effect to the motion of the smoke particle making it look a bit more realistic.
		 * At a default of 1 it does not make a difference but if we set it to a lower value like 0.9 then everytime we
		 * update our smoke particle the _friction will reduce the _xVelocity and _yVelocity properties slightly resulting
		 * in easing
		 */		
		private var _friction:Number = 1;
		
		/**
		 * The amount to scale the smoke particle size on each update. The default of 1 is 100% size.
		 */		
		private var _growX:Number = 1;
		private var _growY:Number = 1;
		
		/**
		 * Amount to fade out the smoke particle on each update 
		 */		
		private var _fade:Number;
			
		/**
		 * amount to spin/rotate the smoke particle on each update 
		 */		
		private var _spin:Number = 0;
		

		/**
		 * Constructor: Create shape to represent the Smoke Particle
		 * 
		 * @param smokeCol			The colour of the smoke particle
		 * @param particleDiameter	The sizeof the smoke particle
		 */		
		public function SmokeParticle(smokeCol:uint, particleDiameter:Number)
		{
			// draw a circle with a slice out of it. Missing slice helps smoke effect when we rotate the particle
			var startDeg:Number = 0;
			var endDeg:Number = 270;
			
			// More efficient to work in radians        
			var degreesPerRadian:Number = Math.PI / 180;
			var startRads:Number = startDeg * degreesPerRadian;
			var endRads:Number = endDeg * degreesPerRadian;
			var steps:Number = 1 * degreesPerRadian;
			
			this.graphics.lineStyle();
			this.graphics.beginFill(smokeCol);
			
			var circleOriginX:Number = 0;
			var circleOriginY:Number = 0;
			var circleRadius:Number = particleDiameter/2;
			
			// draw the circle segment
			this.graphics.moveTo(0, 0);			
			for (var theta:Number = startRads; theta < endRads; theta += Math.min(steps, endRads - theta))
			{            
				this.graphics.lineTo(circleOriginX + circleRadius * Math.cos(theta), circleOriginY + circleRadius * Math.sin(theta));
			}        
			
			this.graphics.lineTo(circleOriginX + circleRadius * Math.cos(endRads), circleOriginY + circleRadius * Math.sin(endRads));			
			this.graphics.lineTo(circleOriginX, circleOriginY);			
			this.graphics.endFill();
		}
		
		
		
		public function set xVelocity(val:Number):void
		{
			_xVelocity = val;
		}
		
		public function set yVelocity(val:Number):void
		{
			_yVelocity = val;
		}
		
		public function set gravity(val:Number):void
		{
			_gravity = val;
		}
		
		public function set friction(val:Number):void
		{
			_friction = val;
		}
		
		public function set growX(val:Number):void
		{
			_growX = val;
		}
		
		public function set growY(val:Number):void
		{
			_growY = val;
		}
		public function set fade(val:Number):void
		{
			_fade = val;
		}
		
		public function set spin(val:Number):void
		{
			_spin = val;
		}
		
		/**
		 * Function updates the positioning, alpha, rotation and scaling of the smoke particle 
		 */		
		public function update():void
		{
			_xVelocity *= _friction;
			_yVelocity *= _friction;			
			_yVelocity += _gravity;			
			this.x += _xVelocity;
			this.y += _yVelocity;			
			this.scaleX *= _growX;
			this.scaleY *= _growY;			
			this.alpha *= _fade;				
			this.rotation += _spin;
		}
	}
}