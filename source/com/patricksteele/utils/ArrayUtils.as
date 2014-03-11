package com.patricksteele.utils
{
	/**
	 * Class contains a collection of useful array manipulation functions
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * @date 11.10.2010
	 * 
	 */
	public class ArrayUtils
	{
		public function ArrayUtils()
		{
		}
		
		

		/**
		 * Function shuffles an array (modifies original)
		 * @param arr
		 * 
		 */		
		static public function shuffle(arr:Array):void
		{			
			var lengthOfArray:uint = arr.length;
			
			var currentElement:*;
			var newPosition:uint;			
			
			for (var i:Number = 0; i < lengthOfArray; i++)
			{
				currentElement = arr[i]; // store current element
				
				// find a random new position for the element				
				newPosition = Math.floor(Math.random() * lengthOfArray);
				
				// swap currentElement with element in the new position
				a[i] = a[newPosition];
				a[newPosition] = currentElement;
			}		
		}
		
		
		
	}
}