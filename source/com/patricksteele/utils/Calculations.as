package com.patricksteele.utils
{
	import flash.display.DisplayObject;
	
	/**
	 * A collection of usefule Mathmatical functions
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 */	
	public class Calculations
	{
		public function Calculations():void
		{
		}
		
		
		/**
		 * Returns a random whole number within the specifed range
		 * 
		 * @param	maxNum max number allowed
		 * @param	minNum min number allowed. Default of 0
		 * @return  Number
		 *
		 * @example randomRange(3); // value between 0 and 3
 		 * @example randomRange(5,2); // value between 2 and 5
		 */
		public static function randomRange(maxNum:Number, minNum:Number = 0):Number 
        {
            return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
        }
		
		/**
		 * Evaluates the x and y coordinates of the two supplied objects 
		 * and returns the distance between origin points
		 * 
		 * @param	p1 first object to evaluated
		 * @param	p2 second object to evaluated
		 * @return  Number
		 */
		public static function distance(objA:DisplayObject ,objB:DisplayObject):Number 
		{
			 var dist:Number;
			 var distX:Number;
			 var distY:Number;
			 
			 distX = objB.x-objA.x;
			 distY = objB.y-objA.y;
			 
			 dist = Math.sqrt(distX*distX + distY*distY);
			 return dist;
		}
		
		
		
		/**
		 * Function recieves a total number of seconds and formats it in mins and secs 
		 * and returns it as a string 
		 * 
		 * @param totalSecs
		 * @return 
		 * 
		 */		
		public static function getTimeCode(totalSecs:Number):String
		{
			var t:Number = Math.round(totalSecs);
			var mins:Number = Math.floor(t/60);
			var secs:Number = t%60;
			var s:String = "";
	
			if(mins < 10)
			{
				s += "0";
			}
			if(mins >= 1)
			{
				s += mins.toString();
			}
			else
			{
				s += "0";
			}
			
			s += ":";
			if(secs < 10)
			{
				s += "0";
				s += secs.toString();
			}
			else
			{
				s += secs.toString();
			}
			
			return s;	
		}

		
		
		/**
		 * Function rounds the recieved number to the specified number of decimal places
		 * 
		 * @param numIn
		 * @param decimalPlaces
		 * @return 
		 */		
		public static function roundToDecimalPlaces(numIn:Number, decimalPlaces:int):Number
		{
			var nExp:int = Math.pow(10,decimalPlaces); 
			
			var nRetVal:Number = Math.round(numIn * nExp) / nExp;
			
			return nRetVal;
		} 

	}
}