package com.patricksteele.gui.scrollbar
{
	import flash.display.GradientType;
	import flash.display.LineScaleMode;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	/**
	 * Class defines a display object for use as a thumb/scrub handle in the Scroll Bar defined by the ScrollBar_PS class.
	 * 
	 * <p>The ScrollBarThumb_PS object will have an OFF(default), OVER and DOWN state. The different Sprites representing each state will be shown
	 * or hidden depending on the current state.</p>
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com
	 * 
	 */	
	public class ScrollBarThumb_PS extends Sprite
	{
		/**
		 * thumb dimensions 
		 */		
		private var _thumbWidth:Number;
		private var _thumbHeight:Number;
		
		/**
		 * Sprite to represent the thumbs off state 
		 */		
		private var _offState:Sprite;
		
		/**
		 * Sprite to represent the thumbs over state 
		 */
		private var _overState:Sprite;
		
		/**
		 * Sprite to represent the thumbs down state 
		 */
		private var _downState:Sprite;
		
		
		/**
		 * Arrays to hold the fill, border and elipse properties for the graphics to be drawn in the different thumb state Sprites. These have the
		 * defaults specified but can be reset via styleThumbOffState, styleThumbOverState and styleThumbDownState functions.
		 * 
		 * <p>Need to store these as instance vars so the <code>resizeThumb</code> function has access to them as we want to redraw the graphics on
		 * resize rather than just resizing to avoid any potential 9-grid scale issues when we have borders and elliped corners</p>
		 */		
		private var _arrStyleOff:Array = new Array(null, null, 0);
		private var _arrStyleOver:Array = new Array(null, null, 0);
		private var _arrStyleDown:Array = new Array(null, null, 0);

		
		/**
		 * CONSTRUCTOR
		 *  
		 * @param thumbWidth
		 * @param thumbHeight
		 */		
		public function ScrollBarThumb_PS(thumbWidth:Number, thumbHeight:Number = 20):void
		{
			// store btn dimension
			_thumbWidth = thumbWidth;
			_thumbHeight = thumbHeight;
			
			// create thumbs state Sprites
			_offState = new Sprite();
			_overState = new Sprite();
			_downState = new Sprite();
			
			// by default all 3 states will just be a grey rectangle. These can all be reset later
			styleThumbOffState({color:0x666666}, null, 0);
			styleThumbOverState({color:0x666666}, null, 0);
			styleThumbDownState({color:0x666666}, null, 0);
			
			// add the state sprites
			addChild(_offState);
			addChild(_overState);
			addChild(_downState);
			
			// set initial visibilities for the state Sprites
			_offState.visible = true;
			_overState.visible = false;
			_downState.visible = false;
			
			// disable thumb children
			_offState.mouseChildren = false;
			_overState.mouseChildren = false;
			_downState.mouseChildren = false;
			_offState.mouseEnabled = false;
			_overState.mouseEnabled = false;
			_downState.mouseEnabled = false;
		}
		
		/**
		 * Fuction allows re-styling of the default appearance for the thumbs off state  
		 * 
		 * @param fill
		 * @param border
		 * @param ellipse
		 */		
		public function styleThumbOffState(fill:Object = null, border:Object = null, ellipse:int = 0):void
		{
			// store settings
			_arrStyleOff[0] = fill;
			_arrStyleOff[1] = border;
			_arrStyleOff[2] = ellipse;

			// re-style thumb state
			drawThumbState(_offState, _thumbWidth, _thumbHeight, _arrStyleOff[0], _arrStyleOff[1], _arrStyleOff[2]);
		}
		
		/**
		 * Fuction allows re-styling of the default appearance for the btns over state  
		 * 
		 * @param fill
		 * @param border
		 * @param ellipse
		 */		
		public function styleThumbOverState(fill:Object = null, border:Object = null, ellipse:int = 0):void
		{
			// store settings
			_arrStyleOver[0] = fill;
			_arrStyleOver[1] = border;
			_arrStyleOver[2] = ellipse;
			
			// re-style thumb state
			drawThumbState(_overState, _thumbWidth, _thumbHeight, _arrStyleOver[0], _arrStyleOver[1], _arrStyleOver[2]);
		}
		
		/**
		 * Fuction allows re-styling of the default appearance for the thumbs down state  
		 * 
		 * @param fill
		 * @param border
		 * @param ellipse
		 */		
		public function styleThumbDownState(fill:Object = null, border:Object = null, ellipse:int = 0):void
		{
			// store settings
			_arrStyleDown[0] = fill;
			_arrStyleDown[1] = border;
			_arrStyleDown[2] = ellipse;
			
			// re-style thumb state
			drawThumbState(_downState, _thumbWidth, _thumbHeight, _arrStyleDown[0], _arrStyleDown[1], _arrStyleDown[2]);
		}
		
		
		
		/**
		 * Function sets the thumb appearance to show its over state
		 */		
		public function showOverState():void
		{
			_offState.visible = false;
			_overState.visible = true;
			_downState.visible = false;
		}
		
		/**
		 * Function sets the thumb appearance to show its off state
		 */		
		public function showOffState():void
		{
			_offState.visible = true;
			_overState.visible = false;
			_downState.visible = false;
		}
		
		/**
		 * Function sets the thumb appearance to show its down state
		 */		
		public function showDownState():void
		{
			_offState.visible = false;
			_overState.visible = false;
			_downState.visible = true;
		}
		
		
		/**
		 * Funciton allows the height of the thumb to be reset. Ie. b the ScrollBar_PS class when the scrollable content height has chamged
		 *  
		 * @param newHeight
		 */		
		public function resizeThumb(newHeight:Number):void
		{
			// set new height
			_thumbHeight = newHeight;
			
			// call style functions that will cause states to be redrawn in the new size
			styleThumbOffState(_arrStyleOff[0], _arrStyleOff[1], _arrStyleOff[2]);
			styleThumbOverState(_arrStyleOver[0], _arrStyleOver[1], _arrStyleOver[2]);
			styleThumbDownState(_arrStyleDown[0], _arrStyleDown[1], _arrStyleDown[2]);

		}
		
		
		
		
		/**************************************************************************************
		 * HELPER FUNCTIONS BELOW USED WHEN DRAWING THE THUMB APPEARANCE
		 *************************************************************************************/
		
		
		/**
		 * Function draws the graphics in the specified Sprite that acts as one of the 3 states.
		 * 
		 * @param thumbState The Sprite to draw into
		 * @param width		The width of the rectangle.
		 * @param height	The height of the rectangle.
		 * @param fill		An object containing fill properties. Default null gives no fill and an empty object ie. {} gives a solid 0x00FFFF fill with alpha of 1.
		 * @param stroke	An object containing stroke properties for the rectangle border. Default is no stroke.
		 * @param ellipse	The amount of curve for rounding the corners. Default is 0 ie. square corners.
		 * 
		 * @return Sprite
		 * 
		 * @examples Below are some examples of this function usage
		 * <listing version="3.0">
		 * 
		 * // DRAW IN RECIEVED SPRITE A BLACK SQUARE
		 * drawThumbState(mySprite, 200, 200, {color:0x000000});
		 * 
		 * // DRAW IN RECIEVED SPRITE A SQUARE WITH LINEAR GRADIENT FROM GREY TO BLACK
		 * drawThumbState(mySprite, 200, 200, {color:[0xCCCCCC, 0x000000]});
		 * 
		 * // DRAW IN RECIEVED SPRITE A BLACK SQUARE WITH A 2px GREY BORDER AND ROUNDED CORNERS
		 * drawThumbState(mySprite, 200, 200, {color:0x000000}, {weight:2, color:0xCCCCCC});
		 * 
		 * // DRAW IN RECIEVED SPRITE A BLACK SQUARE WITH ROUNDED CORNERS AND NO BORDER
		 * drawThumbState(mySprite, 200, 200, {color:0x000000}, null, 20);
		 * 
		 * </listing>
		 */
		private function drawThumbState(thumbState:Sprite, rectWidth:Number, rectHeight:Number, fill:Object = null, stroke:Object = null, ellipse:int = 0):void
		{
			// clear any prev graphics
			thumbState.graphics.clear();
		
			var borderSize:Number = 0;
			
			// determine required stroke properties for the rectangle's border
			if (stroke != null) 
			{
				var strokeObj:Object = getStroke(stroke);
				thumbState.graphics.lineStyle(strokeObj.weight, strokeObj.color, strokeObj.alpha, strokeObj.pixelHinting, strokeObj.scaleMode);
			
				// make sure any stroke does not increase the width and height of the btnState Sprite and that the width
				// and height stay the same no matter the stroke weight
				borderSize = strokeObj.weight;
				if(borderSize >= 1)
				{
					rectWidth = rectWidth - borderSize;
					rectHeight = rectHeight - borderSize;
				}
		
			}
			else // no border
			{
				thumbState.graphics.lineStyle();
			}
			
			// determine if there is a fill for the rectangle
			if(fill != null)
			{
				// determine required fill type properties for the rectabgle
				if (fill != null && fill.color != null && fill.color is Array && fill.color.length > 1)// gradient
				{
					var gradProps:Object = getGradient(fill);
					var gradMatrix:Matrix = new Matrix();
					gradMatrix.createGradientBox(rectWidth, rectHeight, gradProps.rotation, 0, 0);
					thumbState.graphics.beginGradientFill(gradProps.type, gradProps.colors, gradProps.alphas, gradProps.ratios, gradMatrix, gradProps.Spread);
				}
				else // no gradient. just a solid fill
				{ 
					var fillProps:Object = getSolid(fill);
					thumbState.graphics.beginFill(fillProps.color, fillProps.alpha);
				}
			}
			
			// determine if rounded corners and draw the rectangle
			if (ellipse > 0) // rounded corners
			{
				thumbState.graphics.drawRoundRect(borderSize/2, borderSize/2, rectWidth, rectHeight, ellipse);
			}
			else // square corners
			{
				thumbState.graphics.drawRect(borderSize/2, borderSize/2, rectWidth, rectHeight);
			}
			
			if(fill != null)
			{
				thumbState.graphics.endFill();
			}
		}
		
		
		/**
		 * Creates stroke properties object, using defaults for any null values
		 * 
		 * <p>Defaults for stroke properties if none are specified in the recieved parameter are as follows:
		 * thickness = 1, color = black, pixelHinting = true, scaleMode = none, alpha = 1</p>
		 *  
		 * @param props	An object containing stroke properties
		 * 
		 * @return 
		 */		
		private function getStroke(strokeProps:Object):Object 
		{
			var stroke:Object = {};
			
			var strokeThickness:Number = (strokeProps.thickness != null) ? strokeProps.thickness : 1;
			var strokeColor:uint = (strokeProps.color != null) ? strokeProps.color : 0x000000;
			var pixelHinting:Boolean = (strokeProps.pixelHinting != null) ? strokeProps.pixelHinting : true;
			var scaleMode:String = (strokeProps.scaleMode != null) ? strokeProps.scaleMode : LineScaleMode.NONE;
			var strokeAlpha:Number = (strokeProps.alpha != null) ? strokeProps.alpha : 1;
			
			stroke.weight = strokeThickness;
			stroke.color = strokeColor;
			stroke.pixelHinting = pixelHinting;
			stroke.scaleMode = scaleMode;
			stroke.alpha = strokeAlpha;
			
			return stroke;
		}
		
		
		/**
		 * Creates a gradient fill properties object, using defaults for any null values
		 * 
		 * <p>Defaults for fill properties if none are specified in the recieved parameter are as follows:
		 * alphas = 1, type = linear, spread = pad, alpha = 1, ratios = [0,255], rotation = 0</p>
		 *  
		 * @param props	An object containing fill properties
		 * 
		 * @return 
		 */	
		private function getGradient(fill:Object):Object
		{
			var gradient:Object = {};
			
			var gradColors:Array = [parseInt(fill.color[0]), parseInt(fill.color[1])];
			var gradAlphas:Array = (fill.alpha is Array) ? (fill.alpha.length > 1) ? [fill.alpha[0], fill.alpha[1]] : [fill.alpha[0], fill.alpha[0]] : (fill.alpha != null) ? [fill.alpha, fill.alpha] : [1, 1];
			var gradType:String = (fill.gradientType != null) ? fill.gradientType : GradientType.LINEAR;
			var gradSpread:String = (fill.spreadMethod != null) ? fill.spreadMethod : SpreadMethod.PAD;
			var gradRatios:Array = (fill.ratios is Array && fill.ratios.length > 1) ? [fill.ratios[0], fill.ratios[1]] : [0, 255];
			var gradRotation:Number = (fill.rotation != null) ? fill.rotation : 0;
			
			gradient.colors = gradColors;
			gradient.alphas = gradAlphas;
			gradient.type = gradType;
			gradient.spread = gradSpread;
			gradient.ratios = gradRatios;
			gradient.rotation = gradRotation;
			
			return gradient;
		}
		
		
		/**
		 * Creates a solid fill properties object, using defaults for any null values
		 * 
		 * <p>Defaults for fill properties if none are specified in the recieved parameter are as follows:
		 * alphas = 1, color = white</p>
		 *  
		 * @param props	An object containing fill properties
		 * 
		 * @return 
		 */
		private function getSolid(fill:Object):Object
		{
			var solid:Object = {};
			
			var fillAlpha:Number = (fill.alpha == null) ? 1 : (fill.alpha is Array) ? fill.alpha[0] : fill.alpha;
			var fillColor:uint = (fill.color != null) ? (fill.color is Array) ? parseInt(fill.color[0]) : parseInt(fill.color) : 0x00FFFF;
			
			solid.alpha = fillAlpha;
			solid.color = fillColor;
			
			return solid;
		}
		
	}
}