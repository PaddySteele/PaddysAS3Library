package com.patricksteele.utils
{
	import flash.display.DisplayObject;
	import flash.filters.BevelFilter;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;

	/**
	 * Class defines some useful static functions for adding filters effects such as Blur, Drop Shadow, Bevel and Glow to DisplayObjects.
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 */	
	public class FilterUtils
	{
				
		/**
		 * Function adds a drop shadow filter effect to the target DispplayObject
		 *  
		 * @param target		The DisplayObject to which the drop shadow should be added.
		 * @param distance		The offset distance for the drop shadow, in pixels. The default value is 4.0 (floating point).
		 * @param angle			The angle of the drop shadow. Valid values are 0 to 360 degrees (floating point). The default value is 45.
		 * @param color			The color of the drop shadow. The Default is black.
		 * @param alpha			The alpha transparency value for the shadow color.
		 * @param blurX			The amount of horizontal blur. Valid values are 0 to 255.0 (floating point). The default value is 4.0. 
		 * @param blurY			The amount of vertical blur. Valid values are 0 to 255.0 (floating point). The default value is 4.0. 
		 * @param strength		The strength of the imprint or spread. The higher the value, the more color is imprinted and the stronger the contrast between the shadow and the background. Valid values are from 0 to 255.0. The default is 1.0. 
		 * @param quality		The number of times to apply the filter. The default value is 1, which applies the filter once. The value 2 applies the filter twice; the value 3 applies it three times. Filters with lower values are rendered more quickly.
		 * @param inner			Indicates whether or not the shadow is an inner shadow. The default is <code>false</code>, an outer shadow (a shadow around the outer edges of the object).
		 * @param knockout		Applies a knockout effect (<code>true</code>), which effectively makes the object's fill transparent and reveals the background color of the document. The default is <code>false</code> (no knockout).
		 * @param hideObject	Indicates whether or not the object is hidden. The value <code>true</code> indicates that the object itself is not drawn; only the shadow is visible. The default is <code>false</code> (the object is shown). 
		 * 
		 */		
		public static function addDropShadowFilter(target:DisplayObject, distance:Number = 4, angle:Number = 45, color:uint = 0, alpha:Number = 1, blurX:Number = 4, blurY:Number = 4, strength:Number = 1, quality:Number = 1, inner:Boolean = false, knockout:Boolean = false, hideObject:Boolean = false):void
		{
			var dropShadow:DropShadowFilter = new DropShadowFilter(); 
			dropShadow.distance = distance;
			dropShadow.angle = angle;
			dropShadow.color = color;
			dropShadow.alpha = alpha;
			dropShadow.blurX = blurX;
			dropShadow.blurY = blurY;			
			dropShadow.strength = strength;			
			dropShadow.quality = quality;
			dropShadow.inner = inner;
			dropShadow.knockout = knockout;
			dropShadow.hideObject = hideObject;				
			
			// check if there are any existing filters on the target DisplayObject
			var existingFilters:Array = target.filters;
			
			// add new drop shadow filter to existing filter list
			existingFilters.push(dropShadow);
			
			// apply filters to target DisplayObject
			target.filters = existingFilters;			
		}
		
		
		
		/**
		 * Function adds a glow filter effect to the target DispplayObject
		 * 
		 * @param target	The DisplayObject to which the glow should be added.
		 * @param color		The color of the glow.
		 * @param alpha		The alpha transparency value for the color. The default value is 1. 
		 * @param blurX		The amount of horizontal blur. Valid values are 0 to 255 (floating point). The default value is 6. Values that are a power of 2 (such as 2, 4, 8, 16, and 32) are optimized to render more quickly than other values. 
		 * @param blurY		The amount of vertical blur. Valid values are 0 to 255 (floating point). The default value is 6. Values that are a power of 2 (such as 2, 4, 8, 16, and 32) are optimized to render more quickly than other values. 
		 * @param strength	The strength of the imprint or spread. The higher the value, the more color is imprinted and the stronger the contrast between the glow and the background. Valid values are 0 to 255. The default is 2. 
		 * @param quality	The number of times to apply the filter. The default value is 1, which applies the filter once. The value 2 applies the filter twice; the value 3 applies it three times. Filters with lower values are rendered more quickly.
		 * @param inner		Specifies whether the glow is an inner glow. The value <code>true</code> indicates an inner glow. The default is <code>false</code>, an outer glow (a glow around the outer edges of the object). 
		 * @param knockout	Specifies whether the object has a knockout effect. A value of <code>true</code> makes the object's fill transparent and reveals the background color of the document. The default value is <code>false</code> (no knockout effect). 
		 * 
		 */		
		public static function addGlowFilter(target:DisplayObject, color:uint = 0xFF0000, alpha:Number = 1.0, blurX:Number = 6.0, blurY:Number = 6.0, strength:Number = 2, quality:int = 1, inner:Boolean = false, knockout:Boolean = false):void
		{
			var glow:GlowFilter = new GlowFilter();
			glow.color = color;
			glow.alpha = alpha;
			glow.blurX = blurX;
			glow.blurY = blurY;
			glow.strength = strength;
			glow.quality = quality;
			glow.inner = inner;
			glow.knockout = knockout;
						
			// check if there are any existing filters on the target DisplayObject
			var existingFilters:Array = target.filters;
			
			// add new glow filter to existing filter list
			existingFilters.push(glow);
			
			// apply filters to target DisplayObject
			target.filters = existingFilters;			
		}
		
		
		
		/**
		 * Function adds a blur filter effect to the target DispplayObject. A blur effect softens the details of an image.
		 * 
		 * @param target	The DisplayObject to which the blur should be added.
		 * @param blurX		The amount of horizontal blur. Valid values are from 0 to 255 (floating point). The default value is 4. Values that are a power of 2 (such as 2, 4, 8, 16 and 32) are optimized to render more quickly than other values.
		 * @param blurY		The amount of vertical blur. Valid values are from 0 to 255 (floating point). The default value is 4. Values that are a power of 2 (such as 2, 4, 8, 16 and 32) are optimized to render more quickly than other values.
		 * @param quality	The number of times to apply the filter.  The default value is 1, which applies the filter once. The value 2 applies the filter twice; the value 3 applies it three times. Filters with lower values are rendered more quickly.
		 * 
		 */		
		public static function addBlurFilter(target:DisplayObject,blurX:Number = 4.0, blurY:Number = 4.0, quality:int = 1):void
		{
			var blur:BlurFilter = new BlurFilter();
			blur.blurX = blurX;
			blur.blurY = blurY;
			blur.quality = quality;
		
			// check if there are any existing filters on the target DisplayObject
			var existingFilters:Array = target.filters;
			
			// add new blur filter to existing filter list
			existingFilters.push(blur);
			
			// apply filters to target DisplayObject
			target.filters = existingFilters;			
		}
		
		
		
		/**
		 * Function adds a bevel filter effect to the target DispplayObject. A bevel effect gives objects such as buttons a three-dimensional look.
		 * 
		 * @param target			The DisplayObject to which the blur should be added.
		 * @param distance			The offset distance of the bevel. Valid values are in pixels (floating point). The default is 4.
		 * @param angle				The angle of the bevel. Valid values are from 0 to 360. The default value is 45. The value is the angle of the theoretical light source falling on the object and determines the placement of the effect relative to the object. If the distance property is set to 0, the effect is not offset from the object and, therefore, the angle property has no effect.
		 * @param highlightColor	The highlight color of the bevel. Default is white.
		 * @param highlightAlpha	The alpha transparency value of the highlight color. Default is 1.
		 * @param shadowColor		The shadow  color of the bevel. Default is black.
		 * @param shadowAlpha		The alpha transparency value of the shadow color. Default is 1.
		 * @param blurX				The amount of horizontal blur, in pixels. Valid values are from 0 to 255 (floating point). The default value is 4. Values that are a power of 2 (such as 2, 4, 8, 16, and 32) are optimized to render more quickly than other values.
		 * @param blurY				The amount of vertical blur, in pixels. Valid values are from 0 to 255 (floating point). The default value is 4. Values that are a power of 2 (such as 2, 4, 8, 16, and 32) are optimized to render more quickly than other values.
		 * @param strength			The strength of the imprint or spread. Valid values are from 0 to 255. The larger the value, the more color is imprinted and the stronger the contrast between the bevel and the background. The default value is 1. 
		 * @param quality			The number of times to apply the filter. The default value is 1, which applies the filter once. The value 2 applies the filter twice; the value 3 applies it three times. Filters with lower values are rendered more quickly.
		 * @param type				The placement of the bevel on the object. Inner and outer bevels are placed on the inner or outer edge; a full bevel is placed on the entire object. Valid values are the BitmapFilterType constants: BitmapFilterType.INNER, BitmapFilterType.OUTER, BitmapFilterType.FULL.
		 * @param knockout			Applies a knockout effect (<code>true</code>), which effectively makes the object's fill transparent and reveals the background color of the document. The default value is <code>false</code> (no knockout).
		 * 
		 */		
		public static function addBevelFilter(target:DisplayObject, distance:Number = 4.0, angle:Number = 45, highlightColor:uint = 0xFFFFFF, highlightAlpha:Number = 1.0, shadowColor:uint = 0x000000, shadowAlpha:Number = 1.0, blurX:Number = 4.0, blurY:Number = 4.0, strength:Number = 1, quality:int = 1, type:String = "inner", knockout:Boolean = false):void
		{
			var bevel:BevelFilter = new BevelFilter();
			bevel.distance = distance;
			bevel.angle = angle;
			bevel.highlightColor = highlightColor;
			bevel.highlightAlpha = highlightAlpha;
			bevel.shadowColor = shadowColor;
			bevel.shadowAlpha = shadowAlpha;
			bevel.blurX = blurX;
			bevel.blurY = blurY;
			bevel.strength = strength;
			bevel.quality = quality;
			bevel.type = type;
			bevel.knockout = knockout;
			
			// check if there are any existing filters on the target DisplayObject
			var existingFilters:Array = target.filters;
			
			// add new bevel filter to existing filter list
			existingFilters.push(bevel);
			
			// apply filters to target DisplayObject
			target.filters = existingFilters;			
		}
		
		
	}
}