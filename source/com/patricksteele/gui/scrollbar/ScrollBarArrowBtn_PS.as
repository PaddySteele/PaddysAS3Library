package com.patricksteele.gui.scrollbar
{
	import flash.display.GradientType;
	import flash.display.LineScaleMode;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;

	/**
	 * Class defines a display object for use as a up or down arrow button in the Scroll Bar defined by the ScrollBar_PS class.
	 * 
	 * <p>An arrow btn will have an OFF(default), OVER and DOWN state. The different Sprites representing each state will be shown
	 * or hidden depending on the btns current state.</p>
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com
	 * 
	 */	
	public class ScrollBarArrowBtn_PS extends Sprite
	{
		/**
		 * arrow btn dimensions 
		 */		
		private var _btnWidth:Number;
		private var _btnHeight:Number;
		
		/**
		 * Sprite to represent the arrow btns off state 
		 */		
		private var _offState:Sprite;
		
		/**
		 * Sprite to represent the arrow btns over state 
		 */
		private var _overState:Sprite;
		
		/**
		 * Sprite to represent the arrow btns down state 
		 */
		private var _downState:Sprite;
		
		/**
		 * If this is an up or down arrow btn.
		 */		
		private var _btnType:String;
		
		/**
		 * Constants for defining the if the btn is an up or down arrow btn 
		 */		
		private const UP:String = "up";		
		private const DOWN:String = "down";		
		
		
		/**
		 * CONSRUCTOR
		 *  
		 * @param btnWidth
		 * @param btnHeight
		 * @param btnType		up or down arrow btn. Needed so we know what direction arrow should point in
		 */		
		public function ScrollBarArrowBtn_PS(btnWidth:Number, btnHeight:Number, btnType:String = "up"):void
		{
			// store btn dimension
			_btnWidth = btnWidth;
			_btnHeight = btnHeight;
			_btnType = btnType;
			
			// create btn state Sprites
			_offState = new Sprite();
			_overState = new Sprite();
			_downState = new Sprite();
			
			// by default all 3 states will just be a grey rectangle with a white arrow. These can all be reset later
			styleBtnOffState({color:0xCCCCCC}, null, 0, 0xFFFFFF);
			styleBtnOverState({color:0xCCCCCC}, null, 0, 0xFFFFFF);
			styleBtnDownState({color:0xCCCCCC}, null, 0, 0xFFFFFF);
		
			// add the state sprites
			addChild(_offState);
			addChild(_overState);
			addChild(_downState);
			
			// set initial visibilities for the state Sprites
			_offState.visible = true;
			_overState.visible = false;
			_downState.visible = false;
			
			// disable btn children
			_offState.mouseChildren = false;
			_overState.mouseChildren = false;
			_downState.mouseChildren = false;
			_offState.mouseEnabled = false;
			_overState.mouseEnabled = false;
			_downState.mouseEnabled = false;
		}
		
		/**
		 * Fuction allows re-styling of the default appearance for the btns off state  
		 * 
		 * @param fill
		 * @param border
		 * @param ellipse
		 * @param arrowCol
		 */		
		public function styleBtnOffState(fill:Object = null, border:Object = null, ellipse:int = 0, arrowCol:uint = 0xFFFFFF):void
		{
			// re-style btn states bg
			drawBtnStateBg(_offState, _btnWidth, _btnHeight, fill, border, ellipse);
			
			// draw arrow graphic for state
			drawArrow(_offState, arrowCol);
		}
		
		/**
		 * Fuction allows re-styling of the default appearance for the btns over state  
		 * 
		 * @param fill
		 * @param border
		 * @param ellipse
		 * @param arrowCol
		 */		
		public function styleBtnOverState(fill:Object = null, border:Object = null, ellipse:int = 0, arrowCol:uint = 0xFFFFFF):void
		{
			// re-style btn states bg
			drawBtnStateBg(_overState, _btnWidth, _btnHeight, fill, border, ellipse);
			
			// draw arrow graphic for state
			drawArrow(_overState, arrowCol);
		}
		
		/**
		 * Fuction allows re-styling of the default appearance for the btns down state  
		 * 
		 * @param fill
		 * @param border
		 * @param ellipse
		 * @param arrowCol
		 */		
		public function styleBtnDownState(fill:Object = null, border:Object = null, ellipse:int = 0, arrowCol:uint = 0xFFFFFF):void
		{
			// re-style btn states bg
			drawBtnStateBg(_downState, _btnWidth, _btnHeight, fill, border, ellipse);
			
			// draw arrow graphic for state
			drawArrow(_downState, arrowCol);
		}
		
		
		/**
		 * Function draws the arrow graphic on the specified state Sprite of an arrow btn
		 * 
		 * @param btnState
		 * @param arrowCol
		 */		
		private function drawArrow(btnState:Sprite, arrowCol:uint):void
		{
			// draw arrow
			btnState.graphics.lineStyle();
			btnState.graphics.beginFill(arrowCol);
			
			if(_btnType == UP)
			{
				btnState.graphics.moveTo(_btnWidth/2, _btnHeight/4);
				btnState.graphics.lineTo(3*_btnWidth/4, 3*_btnHeight/4);
				btnState.graphics.lineTo(_btnWidth/4, 3*_btnHeight/4);
				btnState.graphics.lineTo(_btnWidth/2, _btnHeight/4);
			}
			else
			{
				btnState.graphics.moveTo(_btnWidth/4, _btnHeight/4);
				btnState.graphics.lineTo(3*_btnWidth/4, _btnHeight/4);
				btnState.graphics.lineTo(_btnWidth/2, 3*_btnHeight/4);
				btnState.graphics.lineTo(_btnWidth/4, _btnHeight/4);
			}
			btnState.graphics.endFill();
		}
		
		
		
		/**
		 * Function sets the arrow buttons appearance to show its over state
		 */		
		public function showOverState():void
		{
			_offState.visible = false;
			_overState.visible = true;
			_downState.visible = false;
		}
		
		/**
		 * Function sets the arrow buttons appearance to show its off state
		 */		
		public function showOffState():void
		{
			_offState.visible = true;
			_overState.visible = false;
			_downState.visible = false;
		}
		
		/**
		 * Function sets the arrow buttons appearance to show its down state
		 */		
		public function showDownState():void
		{
			_offState.visible = false;
			_overState.visible = false;
			_downState.visible = true;
		}
		
		
		
		
/**************************************************************************************
* HELPER FUNCTIONS BELOW USED WHEN DRAWING THE ARROW BTNS APPEARANCE
*************************************************************************************/
		
		
		/**
		 * Function draws the graphics in the specified Sprite that act as one of the 3 states.
		 * 
		 * @param btnState	The Sprite to draw into
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
		 * drawBtnStateBg(mySprite, 200, 200, {color:0x000000});
		 * 
		 * // DRAW IN RECIEVED SPRITE A SQUARE WITH LINEAR GRADIENT FROM GREY TO BLACK
		 * drawBtnStateBg(mySprite, 200, 200, {color:[0xCCCCCC, 0x000000]});
		 * 
		 * // DRAW IN RECIEVED SPRITE A BLACK SQUARE WITH A 2px GREY BORDER AND ROUNDED CORNERS
		 * drawBtnStateBg(mySprite, 200, 200, {color:0x000000}, {weight:2, color:0xCCCCCC});
		 * 
		 * // DRAW IN RECIEVED SPRITE A BLACK SQUARE WITH ROUNDED CORNERS AND NO BORDER
		 * drawBtnStateBg(mySprite, 200, 200, {color:0x000000}, null, 20);
		 * 
		 * </listing>
		 */
		private function drawBtnStateBg(btnState:Sprite, rectWidth:Number, rectHeight:Number, fill:Object = null, stroke:Object = null, ellipse:int = 0):void
		{
			// clear any prev graphics
			btnState.graphics.clear();
			
			var borderSize:Number = 0;
			
			// determine required stroke properties for the rectangle's border
			if (stroke != null) 
			{
				var strokeObj:Object = getStroke(stroke);
				btnState.graphics.lineStyle(strokeObj.weight, strokeObj.color, strokeObj.alpha, strokeObj.pixelHinting, strokeObj.scaleMode);
				
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
				btnState.graphics.lineStyle();
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
					btnState.graphics.beginGradientFill(gradProps.type, gradProps.colors, gradProps.alphas, gradProps.ratios, gradMatrix, gradProps.Spread);
				}
				else // no gradient. just a solid fill
				{ 
					var fillProps:Object = getSolid(fill);
					btnState.graphics.beginFill(fillProps.color, fillProps.alpha);
				}
			}
			
			// determine if rounded corners and draw the rectangle
			if (ellipse > 0) // rounded corners
			{
				btnState.graphics.drawRoundRect(borderSize/2, borderSize/2, rectWidth, rectHeight, ellipse);
			}
			else // square corners
			{
				btnState.graphics.drawRect(borderSize/2, borderSize/2, rectWidth, rectHeight);
			}
			
			if(fill != null)
			{
				btnState.graphics.endFill();
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