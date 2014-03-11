package com.patricksteele.utils
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;

	/**
	 * Some usefult function for altering the colour of DisplayObjects
	 *  
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 */	
	public class ColorUtils
	{
		public function ColorUtils()
		{
		}
		
		
		/**
		 * Function tints the display object the specified color
		 *  
		 * @param displayItem
		 * @param newColor
		 * 
		 */		
		public static function tint(displayItem:DisplayObject, newColor:uint):void
		{
			var colorTransform:ColorTransform = displayItem.transform.colorTransform;
			colorTransform.color = newColor;
			displayItem.transform.colorTransform=colorTransform;
		}
		
		
	}
}