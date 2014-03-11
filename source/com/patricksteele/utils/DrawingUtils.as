package com.patricksteele.utils
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * Class defines some useful static functions for drawing shapes and lines and returning them as Sprites
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 */	
	public class DrawingUtils 
	{
		
		/**
		 * Function creates and returns a rectangle Sprite.
		 * 
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
		 * // DRAW A BLACK SQUARE
		 * var rectangleA:Sprite = DrawingUtils.drawRectangleSprite(200, 200, {color:0x000000});
		 * 
		 * // DRAW A SQUARE WITH LINEAR GRADIENT FROM GREY TO BLACK (left to right)
		 * var rectangleB:Sprite = DrawingUtils.drawRectangleSprite(200, 200, {color:[0xCCCCCC, 0x000000]});
		 * 
		 * // DRAW A SQUARE WITH LINEAR GRADIENT FROM GREY TO BLACK (top to bottom)
		 * var rectangleB:Sprite = DrawingUtils.drawRectangleSprite(200, 200, {color:[0xCCCCCC, 0x000000], rotation:-90*Math.PI/180});
		 * 
		 * // DRAW A BLACK SQUARE WITH A 2px GREY BORDER AND ROUNDED CORNERS
		 * var rectangleC:Sprite = DrawingUtils.drawRectangleSprite(200, 200, {color:0x000000}, {weight:2, color:0xCCCCCC});
		 * 
		 * // DRAW A BLACK SQUARE WITH ROUNDED CORNERS AND NO BORDER
		 * var rectangleE:Sprite = DrawingUtils.drawRectangleSprite(200, 200, {color:0x000000}, null, 20);
		 * 
		 * </listing>
		 * 
		 */		
		public static function drawRectangleSprite(rectWidth:Number, rectHeight:Number, fill:Object = null, stroke:Object = null, ellipse:int = 0):Sprite
		{
			var aRectangle:Sprite = new Sprite();
			
			// determine required stroke properties for the rectangle's border
			if (stroke != null) 
			{
				var strokeObj:Object = getStroke(stroke);
				aRectangle.graphics.lineStyle(strokeObj.weight, strokeObj.color, strokeObj.alpha, strokeObj.pixelHinting, strokeObj.scaleMode);
			}
			else // no border
			{
				aRectangle.graphics.lineStyle();
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
					aRectangle.graphics.beginGradientFill(gradProps.type, gradProps.colors, gradProps.alphas, gradProps.ratios, gradMatrix, gradProps.Spread);
				}
				else // no gradient. just a solid fill
				{ 
					var fillProps:Object = getSolid(fill);
					aRectangle.graphics.beginFill(fillProps.color, fillProps.alpha);
				}
			}
			
			// determine if rounded corners and draw the rectangle
			if (ellipse > 0) // rounded corners
			{
				aRectangle.graphics.drawRoundRect(0, 0, rectWidth, rectHeight, ellipse);
			}
			else // square corners
			{
				aRectangle.graphics.drawRect(0, 0, rectWidth, rectHeight);
			}
			
			
			if(fill != null)
			{
				aRectangle.graphics.endFill();
			}
			
			return aRectangle;
		}
		
		
		/**
		 * A handy function which sets up scale9Grid behaviour for a Sprite.
		 * 
		 * <p>When you define the scale9Grid property, the display object is divided into a grid 
		 * with nine regions based on a specified scale9Grid rectangle, which defines the center
		 * region of the grid.</p>
		 * 
		 * <p>When the display object is scaled or stretched, the objects within the rectangle scale normally,
		 * but the 8 areas outside of the rectangle scale as follows: The 4 corners do not scale. The 2 areas
		 * above and below the rectangle only scale horizontally and the 2 areas left and right of the 
		 * rectangle only scale vertically.</p>
		 * 
		 * <p> NOTE: If a display object is rotated, all subsequent scaling is 
		 * normal (and the scale9Grid property is ignored).</p>
		 * 
		 * <p> COMMON ERROR: You must make sure that the x, y, width, and height of the scaleGridRect
		 * all fall within the target Sprite. Otherwise you will get the following error:
		 * "#2004 ArgumentError: One of the parameters is invalid."</p>
		 * 
		 * @param target 	The target Sprite we want to set the scale9Grid property for
		 * @param offset	The offset from the sprites borders used for drawing the scale9Grid Rectangle
		 * @param showGrid	If we want to display the actual grid (handy for testing). Default = false.
		 * 
		 * @example	The code below creates a rectangluar Sprite with curved corners and then
		 * uses <code>set9GridScaling()</code> to make sure corners are not scaled. 
		 * <listing version="3.0">
		 * 
		 * var cornerSize:Number = 20;
		 * var mySprite:Sprite = DrawingUtils.drawRectSprite(100,100, {color:0xcccccc}, {color:0x000000, thickness:1, pixelHinting:true}, cornerSize);
		 * addChild(mySprite);
		 * mySprite.y = 100;
		 * mySprite.x =100;
		 * DrawingUtils.set9GridScaling(mySprite, cornerSize, false);
		 * 
		 * </listing>
		 * 
		 */		
		public static function set9GridScaling(target:Sprite, offset:Number, showGrid:Boolean = false):void
		{
			var gridWidth:Number = target.width - offset*2;
			var gridHeight:Number = target.height - offset*2;
			
			var scaleGridRect:Rectangle = new Rectangle(offset,offset,gridWidth,gridHeight);
			target.scale9Grid = scaleGridRect;
			
			
			// if we want to display the actual grid. Probably we never will but this can be handy for testing
			if(showGrid)
			{
				var lineColor:uint = 0x00ff00;
				target.graphics.lineStyle(1, lineColor);
				target.graphics.moveTo(0, scaleGridRect.y);
				target.graphics.lineTo(target.width, scaleGridRect.y );
				target.graphics.moveTo(scaleGridRect.x, 0);
				target.graphics.lineTo(scaleGridRect.x, target.height);
				target.graphics.moveTo(0, scaleGridRect.y + scaleGridRect.height);
				target.graphics.lineTo(target.width, scaleGridRect.y + scaleGridRect.height);
				target.graphics.moveTo(scaleGridRect.x + scaleGridRect.width, 0);
				target.graphics.lineTo(scaleGridRect.x + scaleGridRect.width, target.height);
			}			
		}
		
	
		
		
		
		/**
		 * Function creates and returns a circle Sprite.
		 * 
		 * @param circleRadius	The radius of the circle.
		 * @param fill			An object containing fill properties. Default null gives no fill and an empty object ie. {} gives a solid 0x00FFFF fill with alpha of 1.
		 * @param stroke		An object containing stroke properties for the circles border. Default is no stroke.
		 * 
		 * @return Sprite
		 * 
		 * @example	Some examples of this function usage are shown below
		 * <listing version="3.0">
		 * 
		 * // DRAW A BLACK CIRCLE
		 * var circleA:Sprite = DrawingUtils.drawCircleSprite(200, {color:0x000000});
		 * 
		 * // DRAW A CIRCLE WITH LINEAR GRADIENT FROM GREY TO BLACK
		 * var circleB:Sprite = DrawingUtils.drawCircleSprite(200, {color:[0xCCCCCC, 0x000000]});
		 * 
		 * // DRAW A GREY CIRCLE WITH A 2px BLACK BORDER
		 * var circleC:Sprite = DrawingUtils.drawCircleSprite(200, {color:0xCCCCCC}, {thickness:2, color:0x000000});
		 * 
		 * </listing>
		 */
		public static function drawCircleSprite(circleRadius:int, fill:Object = null, stroke:Object = null):Sprite
		{
			var aCircle:Sprite = new Sprite();
			
			// determine required stroke properties for the circle's border
			if (stroke != null) 
			{
				var strokeObj:Object = getStroke(stroke);
				aCircle.graphics.lineStyle(strokeObj.thickness, strokeObj.color, strokeObj.alpha, strokeObj.pixelHinting, strokeObj.scaleMode);
			}
			else // no border
			{
				aCircle.graphics.lineStyle();
			}
			
			// determine if there is a fill for the circle
			if(fill != null)
			{
				// determine required fill type properties for the circle
				if (fill != null && fill.color != null && fill.color is Array && fill.color.length > 1)// gradient fill
				{
					var gradProps:Object = getGradient(fill);
					var gradMatrix:Matrix = new Matrix();
					gradMatrix.createGradientBox(circleRadius, circleRadius, gradProps.rotation, 0, 0);
					aCircle.graphics.beginGradientFill(gradProps.type, gradProps.colors, gradProps.alphas, gradProps.ratios, gradMatrix, gradProps.Spread);
				}
				else // no gradient. just a solid fill
				{ 
					var fillProps:Object = getSolid(fill);
					aCircle.graphics.beginFill(fillProps.color, fillProps.alpha);
				}
			}
			
			// draw the circle
			aCircle.graphics.drawCircle(circleRadius, circleRadius, circleRadius);
			
			if(fill != null)
			{
				aCircle.graphics.endFill();
			}
			
			return aCircle;
		}
		
		

		/**
		 * Function creates and returns a circle segment Sprite.
		 * **TODO**: Gradient fills dont seem to work properly **
		 * 
		 * @param x   			The x-coordinate of the origin of the segment.
		 * @param y         	The y-coordinate of the origin of the segment.
		 * @param circleRadius	The radius of the segmented circle.
		 * @param aStart    	The starting angle (degrees) of the segment (0 = East)
		 * @param aEnd    		The ending angle (degrees) of the segment (0 = East)
		 * @param step    		The number of degrees between each point on the segment's circumference. Default is 1.
		 * @param fill			An object containing fill properties. Default null gives no fill and an empty object ie. {} gives a solid 0x00FFFF fill with alpha of 1.
		 * @param stroke		An object containing stroke properties for the circles border. Default is no stroke.
		 * 
		 * @return Sprite
		 * 
		 * @example	Some examples of this function usage are shown below
		 * <listing version="3.0">
		 * 
		 * // DRAW A BLACK CIRCLE SEGMENT FROM 3 O'CLOCK TO 12 O'CLOCK WITH A RADIUS OF 40px
		 * var circleSegmentA:Sprite = DrawingUtils.drawCircleSegmentSprite(0,0,40,0,270,1, {color:0x000000});
		 * 
		 * // DRAW A CIRCLE SEGMENT WITH LINEAR GRADIENT FROM GREY TO BLACK FROM 6 O'CLOCK TO 9 O'CLOCK WITH A RADIUS OF 60px AND A BLACK BORDER OF 2px
		 * var circleSegmentB:Sprite = DrawingUtils.drawCircleSegmentSprite(0,0,60,90,180,1, {color:[0xCCCCCC, 0x000000]}, {thickness:2, color:0x000000, pixelHinting:false});
		 * 
		 * </listing>
		 */
		public static function drawCircleSegmentSprite(x:Number, y:Number, circleRadius:Number, aStart:Number, aEnd:Number, step:Number = 1, fill:Object = null, stroke:Object = null):Sprite
		{
			var aCircle:Sprite = new Sprite();
			
			// More efficient to work in radians        
			var degreesPerRadian:Number = Math.PI / 180;
			aStart *= degreesPerRadian;
			aEnd *= degreesPerRadian;
			step *= degreesPerRadian;
			
			// determine required stroke properties for the circle's border
			if (stroke != null) 
			{
				var strokeObj:Object = getStroke(stroke);
				aCircle.graphics.lineStyle(strokeObj.thickness, strokeObj.color, strokeObj.alpha, strokeObj.pixelHinting, strokeObj.scaleMode);
			}
			else // no border
			{
				aCircle.graphics.lineStyle();
			}
			
			// determine if there is a fill for the circle segment
			if(fill != null)
			{
				// determine required fill type properties for the circle
				if (fill != null && fill.color != null && fill.color is Array && fill.color.length > 1)// gradient fill
				{
					var gradProps:Object = getGradient(fill);
					var gradMatrix:Matrix = new Matrix();
					gradMatrix.createGradientBox(circleRadius, circleRadius, gradProps.rotation, 0, 0);
					aCircle.graphics.beginGradientFill(gradProps.type, gradProps.colors, gradProps.alphas, gradProps.ratios, gradMatrix, gradProps.Spread);
				}
				else // no gradient. just a solid fill
				{ 
					var fillProps:Object = getSolid(fill);
					aCircle.graphics.beginFill(fillProps.color, fillProps.alpha);
				}
			}
			
			// draw the circle segment
			aCircle.graphics.moveTo(x, y);
			
			for (var theta:Number = aStart; theta < aEnd; theta += Math.min(step, aEnd - theta))
			{            
				aCircle.graphics.lineTo(x + circleRadius * Math.cos(theta), y + circleRadius * Math.sin(theta));
			}        
			
			aCircle.graphics.lineTo(x + circleRadius * Math.cos(aEnd), y + circleRadius * Math.sin(aEnd));			
			aCircle.graphics.lineTo(x, y);
			
			if(fill != null)
			{
				aCircle.graphics.endFill();
			}
			
			return aCircle;
		}
		
		
		
	
		/**
		 * Function creates and returns a triangle Sprite.
		 * 
		 * @param triangleBase	The length of the triangle base (the other sides will be the same)
		 * @param fill			An object containing fill properties. Default null gives no fill and an empty object ie. {} gives a solid 0x00FFFF fill with alpha of 1.
		 * @param stroke		An object containing stroke properties for the triangles border. Default is no stroke.
		 * 
		 * @return Sprite
		 * 
		 * @example	Some examples of this function usage are shown below
		 * <listing version="3.0">
		 * 
		 * // DRAW A BLACK TRIANGLE
		 * var triangleA:Sprite = DrawingUtils.drawTriangleSprite(200, {color:0x000000});
		 * 
		 * // DRAW A TRIANGLE WITH LINEAR GRADIENT FROM GREY TO BLACK
		 * var triangleB:Sprite = DrawingUtils.drawTriangleSprite(200, {color:[0xCCCCCC, 0x000000]});
		 * 
		 * // DRAW A GREY TRIANGLE WITH A 2px BLACK BORDER
		 * var triangleC:Sprite = DrawingUtils.drawTriangleSprite(200, {color:0xCCCCCC}, {thickness:2, color:0x000000});
		 * 
		 * // DRAW A TRIANGLE WITH A 2px BLACK BORDER AND A LINEAR GRADIENT FILL FROM GREY TO WHITE
		 * var triangleD:Sprite = DrawingUtils.drawTriangleSprite(200, {color:[0xCCCCCC, 0xFFFFFF]}, {thickness:2, color:0x000000});
		 * 
		 * </listing>
		 */
		public static function drawTriangleSprite(triangleBase:int, fill:Object = null, stroke:Object = null):Sprite
		{
			var triangleHeight:Number = Math.sqrt((triangleBase*triangleBase)-((triangleBase/2)*(triangleBase/2)));
			
			var aTriangle:Sprite = new Sprite();
		
			// determine required stroke properties for the triangle's border
			if (stroke != null) 
			{
				var strokeObj:Object = getStroke(stroke);
				aTriangle.graphics.lineStyle(strokeObj.thickness, strokeObj.color, strokeObj.alpha, strokeObj.pixelHinting, strokeObj.scaleMode);
			}
			else // no border
			{
				aTriangle.graphics.lineStyle();
			}
			
			// determine if there is a fill for the triangle
			if(fill != null)
			{
				// determine required fill type properties for the rectabgle
				if (fill != null && fill.color != null && fill.color is Array && fill.color.length > 1)// gradient
				{
					var gradProps:Object = getGradient(fill);
					var gradMatrix:Matrix = new Matrix();
					gradMatrix.createGradientBox(triangleBase, triangleHeight, gradProps.rotation, 0, 0);
					aTriangle.graphics.beginGradientFill(gradProps.type, gradProps.colors, gradProps.alphas, gradProps.ratios, gradMatrix, gradProps.Spread);
				}
				else // no gradient. just a solid fill
				{ 
					var fillProps:Object = getSolid(fill);
					aTriangle.graphics.beginFill(fillProps.color, fillProps.alpha);
				}
			}
			
			// draw the triangle
			aTriangle.graphics.moveTo(0, triangleHeight);
			aTriangle.graphics.lineTo(triangleBase/2, 0);
			aTriangle.graphics.lineTo(triangleBase, triangleHeight);
			aTriangle.graphics.lineTo(0, triangleHeight);
			
			if(fill != null)
			{
				aTriangle.graphics.endFill();
			}
			
			return aTriangle;
		}
		
		
		
		
		/**
		 * Function draws a dashed line and returns a Sprite containing the line
		 * 
		 * <p>Note that a dash length of 1 will might show up as more than a pixel due
		 *  to limitations with the drawing API. Use the pixelDottedLine() function below for pixel perfect stuff.</p>
		 * 
		 * @param relativeEndPoint	Relative end point of the line if start is assumed to be (0,0)
		 * @param dashLength		Length of a dash			
		 * @param dashGap			Gap between dashes
		 * @param lineThickness		Thickness of line
		 * @param lineColor			Colour of line
		 * 
		 * @return 
		 * 
		 * @example	Some examples of this function usage are shown below
		 * <listing version="3.0">
		 * 
		 * 		// DRAW A BLACK DASHED LINE ON STAGE FROM (10,10) to (60,10)
		 * 		var dashedLine:Sprite = DrawingUtils.dashedLine(new Point(50, 0), 5, 5, 2, 0x000000); 		
		 * 		dashedLine.x = 10;
		 *  	dashedLine.y = 10;
		 * 		addChild(dashedLine);
		 * </listing>
		 */		
		static public function dashedLine(relativeEndPoint:Point, dashLength:Number = 5, dashGap:Number=5, lineThickness:Number = 1, lineColor:uint = 0x000000):Sprite 
		{
			var aDashedLine:Sprite = new Sprite();
			
			var startPoint:Point = new Point(0,0);
			var endPoint:Point = relativeEndPoint;
			
			var lineLength:Number = Point.distance(startPoint, endPoint);
			
			if(lineLength > 0)
			{
				var lStep:Number = (dashLength/lineLength);
				var gStep:Number = (dashGap/lineLength);
				
				var n:Number = 0;
				
				aDashedLine.graphics.lineStyle(lineThickness, lineColor, 1, false, "normal", "none");
				
				while(n < 1) 
				{		
					var p1:Point = Point.interpolate(startPoint, endPoint, n );
					n += lStep;
					var p2:Point = Point.interpolate(startPoint, endPoint, n );
					n += gStep;
					aDashedLine.graphics.moveTo(p1.x, p1.y);
					aDashedLine.graphics.lineTo(p2.x, p2.y);				
				}
			}
			
			return aDashedLine;
			
		}
		
		

		/**
		 * Function draws a dotted line and returns a Sprite containng the line
		 * 
		 * @param relativeEndPoint	Relative end point of the line if start is assumed to be (0,0)
		 * @param dotSpacing		Space between dots
		 * @param dotDiameter		Diameter of each dot
		 * @param dotColor			Colour of dots
		 * 
		 * @return 
		 *
		 * @example	Some examples of this function usage are shown below
		 * <listing version="3.0">
		 * 
		 * 		// DRAW A BLACK DOTTED LINE ON STAGE FROM (10,10) to (60,10)
		 * 		var dottedLine:Sprite = DrawingUtils.dashedLine(new Point(50, 0), 10, 10, 0x000000); 		
		 * 		dottedLine.x = 10;
		 *  	dottedLine.y = 10;
		 * 		addChild(dottedLine);
		 * </listing>
		 * 
		 */		
		static public function dottedLine(relativeEndPoint:Point, dotSpacing:Number = 5, dotDiameter:Number = 1, dotColor:uint = 0x000000):Sprite
		{
			var aDottedLine:Sprite = new Sprite();
			
			var startPoint:Point = new Point(0,0);
			var endPoint:Point = relativeEndPoint;
			
			var lineLength:Number = Point.distance(startPoint, endPoint);
			
			var dotRadius:Number = dotDiameter/2;
			
			if(lineLength > 0)
			{
				var step:Number = ((dotSpacing + dotRadius*2)/lineLength);
				var n:Number = 0;
				
				aDottedLine.graphics.beginFill(dotColor,1);
				
				while(n < 1)
				{		
					var p:Point = Point.interpolate(startPoint, endPoint, n);				
					aDottedLine.graphics.drawCircle(p.x, p.y, dotRadius);			
					n += step;
				}
				
				aDottedLine.graphics.endFill();
			}
			
			return aDottedLine;
		}
		
		

		/**
		 * Function draws a Pixel perfect dotted line (each dot is a pixel) and returns a Sprite containng the line
		 * 
		 * @param relativeEndPoint	Relative end point of the line if start is assumed to be (0,0)
		 * @param dotSpacing		Space between dots
		 * @param dotColor			Colour of dots
		 * 
		 * @return 
		 * 
		 * @example	Some examples of this function usage are shown below
		 * <listing version="3.0">
		 * 
		 * 		// DRAW A BLACK PIXEL PERFECT DOTTED LINE ON STAGE FROM (10,10) to (60,10)
		 * 		var dottedLine:Sprite = DrawingUtils.dashedLine(new Point(50, 0), 10, 0x000000); 		
		 * 		dottedLine.x = 10;
		 *  	dottedLine.y = 10;
		 * 		addChild(dottedLine);
		 * </listing>
		 * 		 */		
		static public function pixelDottedLine(relativeEndPoint:Point, dotSpacing:Number = 5, dotColor:uint = 0x000000):Sprite
		{
			var aDottedLine:Sprite = new Sprite();
			
			var startPoint:Point = new Point(0,0);
			var endPoint:Point = relativeEndPoint;
			
			var lineLength:Number = Point.distance(startPoint, endPoint);
			
			
			if(lineLength > 0)
			{
				var step:Number = ((dotSpacing+1)/lineLength);
				var n:Number = 0;
				
				aDottedLine.graphics.beginFill(dotColor,1);
				
				while(n < 1)
				{		
					var p:Point = Point.interpolate(startPoint, endPoint, n);	
					aDottedLine.graphics.drawRect(Math.round(p.x), Math.round(p.y), 1, 1);
					n += step;
				}
				
				aDottedLine.graphics.endFill();
			}
			
			return aDottedLine;
			
		}
		
		
		
		
		
		
		
		
		/**
		 * Function alows us to create a hitarea for a Sprite, MovieClip or Bitmap. Very useful for creating hit areas for externally loaded assets.
		 * 
		 * <p>In certain cases we may have a bitmap with transparency around the edges so the image does not fill the bitmaps
		 * bounding rectangle. Let’s say you are loading in an external asset that has an alpha channel, such as a PNG. Now let’s 
		 * say that you want that asset to act like a button, with rollover and click actions. No problem. No reason you can’t do that.
		 * But, actually, there is a problem. The hit area for that external asset will be its entire bounding box. In such an instance
		 * we may not want the whole rectangle shape to be mouse detectable. This function allows us to create a hit area with only the
		 * non transparent pixels drawn in it. We could then use this hitarea usually by setting its alpha to zero and placing it over the
		 * DisplayObject in question</p>
		 * 
		 * <p>When checking the alpha of the pixels this function moves left to right one row at a time. An alternative
		 * function <code>createHitAreaSpriteV()</code> is included below which works in the same way but checks the
		 * pixels top to bottom column by column. Depending on your image one function may be more appropriate than the other
		 * so you should test with both</p>
		 * 
		 * @param source		The MovieClip, Sprite or Bitmap for which we want to create a hit area.
		 * @param hitAreaColor	The color to make the hitarea Sprite.
		 * 
		 * @return Sprite
		 * 
		 * @example	The exampe below creates a hit area for a button containing a png.
		 * <listing version="3.0">
		 * 
		 * // create the btn
		 * var myButton:Sprite = new Sprite();
		 * myButton.addChild(myPNG);
		 * addChild(myButton);
		 * myButton.x = 100;
		 * myButton.y = 100;
		 * 
		 * // create hit area for the btn
		 * var hitArea:Sprite =  DrawingUtils.createHitAreaSprite(myButton);
		 * addChild(hitArea);
		 * hitArea.x = 100;
		 * hitArea.y = 100;
		 * hitArea.addEventListener(MouseEvent.CLICK, btn_clickHandler);
		 * 
		 * </listing>
		 */
		public static function createHitAreaSprite(source:DisplayObject, hitAreaColor:uint = 0x000000):Sprite
		{
			// Sprite into which our hit area will be drawn
			var hitArea:Sprite = new Sprite();
		
			// get dimensions of source DisplayObject bounding rectangle
			var pxW:Number = source.width;
			var pxH:Number = source.height;
			
			// get the bitmap data for the DisplayObject so we can analyse it's pixels
			var bmd:BitmapData = new BitmapData(pxW, pxH, true, 0x000000);
			bmd.draw(source);
			
			//Arrays to hold the points needed to draw the hit area outline
			var arrLeftPts:Array = new Array();
			var arrRightPts:Array = new Array();
			
			// determine outline points by looking for the outermost pixels that are not transparent
			for(var yPos:Number = 0; yPos <= pxH; yPos++) // check BitmapData pixels one row at a time
			{
				var flag:Boolean = false; // if the left edge has been found
				
				var leftX:Number = -1;
				var rightX:Number = -1;
				
				for(var xPos:Number = 0; xPos <= pxW; xPos++)  // check each pixel in a row
				{
					if(!flag)
					{
						if(bmd.getPixel(xPos, yPos) != 0) // left most pixel that is not transparent
						{
							leftX = xPos;
							rightX = xPos;
							flag = true;
						}
					}
					else
					{
						if(bmd.getPixel(xPos, yPos) != 0) // right most pixel that is not transparent
						{
							rightX = xPos;
						}
					}					
				}
				
				// store the Points
				if(leftX != -1)
				{
					arrLeftPts.push(new Point(leftX, yPos));
					leftX = -1;
				}				
				if(rightX != -1)
				{
					arrRightPts.push(new Point(rightX, yPos));
					rightX = -1;
				}				
				flag = false;
			}
			
			
			// draw the hitarea
			hitArea.graphics.lineStyle(1,hitAreaColor);
			hitArea.graphics.beginFill(hitAreaColor);
			
			
			// DRAW LEFT HAND OUTLINE
			for(var i:Number = 0; i < arrLeftPts.length; i++)
			{
				if(i == 0) // ie. first point
				{
					hitArea.graphics.moveTo(arrLeftPts[i].x, arrLeftPts[i].y);
				}
				else
				{
					hitArea.graphics.lineTo(arrLeftPts[i].x, arrLeftPts[i].y);
				}
			}
			
			// DRAW BOTTOM OUTLINE
			hitArea.graphics.lineTo(arrRightPts[arrRightPts.length-1].x, arrRightPts[arrRightPts.length-1].y);
			
			// DRAW RIGHT HANDOUTLINE
			for(var j:Number = arrRightPts.length-1; j >= 0; j--)
			{
				hitArea.graphics.lineTo(arrRightPts[j].x, arrRightPts[j].y);
			}
			
			// DRAW BOTTOM OUTLINE
			hitArea.graphics.lineTo(arrLeftPts[0].x, arrLeftPts[0].y);
			
			hitArea.graphics.endFill();
			
			return hitArea;
		}
		
		
		
		/**
		 * Function alows us to create a hitarea for a Sprite, MovieClip or Bitmap. Very useful for creating hit areas for externally loaded assets.
		 * 
		 * <p>In certain cases we may have a bitmap with transparency around the edges so the image does not fill the bitmaps
		 * bounding rectangle. Let’s say you are loading in an external asset that has an alpha channel, such as a PNG. Now let’s 
		 * say that you want that asset to act like a button, with rollover and click actions. No problem. No reason you can’t do that.
		 * But, actually, there is a problem. The hit area for that external asset will be its entire bounding box. In such an instance
		 * we may not want the whole rectangle shape to be mouse detectable. This function allows us to create a hit area with only the
		 * non transparent pixels drawn in it. We could then use this hitarea usually by setting its alpha to zero and placing it over the
		 * DisplayObject in question</p>
		 * 
		 * <p>When checking the alpha of the pixels this function moves top to bottom one column at a time. An alternative
		 * function <code>createHitAreaSprite()</code> is included above which works in the same way but checks the
		 * pixels left to right one row at a time. Depending on your image one function may be more appropriate than the other
		 * so you should test with both</p>
		 * 
		 * @param source		The MovieClip, Sprite or Bitmap for which we want to create a hit area.
		 * @param hitAreaColor	The color to make the hitarea Sprite.
		 * 
		 * @return Sprite
		 * 
		 * @example	The exampe below creates a hit area for a button containing a png.
		 * <listing version="3.0">
		 * 
		 * // create the btn
		 * var myButton:Sprite = new Sprite();
		 * myButton.addChild(myPNG);
		 * addChild(myButton);
		 * myButton.x = 100;
		 * myButton.y = 100;
		 * 
		 * // create hit area for the btn
		 * var hitArea:Sprite =  DrawingUtils.createHitAreaSpriteV(myButton);
		 * addChild(hitArea);
		 * hitArea.x = 100;
		 * hitArea.y = 100;
		 * hitArea.addEventListener(MouseEvent.CLICK, btn_clickHandler);
		 * 
		 * </listing>
		 */		
		public static function createHitAreaSpriteV(source:DisplayObject, hitAreaColor:uint = 0x000000):Sprite
		{
			// Sprite into which our hit area will be drawn
			var hitArea:Sprite = new Sprite();
			
			// get dimensions of source DisplayObject bounding rectangle
			var pxW:Number = source.width;
			var pxH:Number = source.height;
			
			// get the bitmap data for the DisplayObject so we can analyse it's pixels
			var bmd:BitmapData = new BitmapData(pxW, pxH, true, 0x000000);
			bmd.draw(source);
			
			//Arrays to hold the points needed to draw the hit area outline
			var arrTopPts:Array = new Array();
			var arrBottomPts:Array = new Array();
			
			// determine outline points by looking for the outermost pixels that are not transparent
			for(var xPos:Number = 0; xPos <= pxW; xPos++) // check BitmapData pixels one row at a time
			{
				var flag:Boolean = false; // if the top edge has been found
				
				var topY:Number = -1;
				var bottomY:Number = -1;
				
				for(var yPos:Number = 0; yPos <= pxH; yPos++)  // check each pixel in a row
				{
					if(!flag)
					{
						if(bmd.getPixel(xPos, yPos) != 0) // top most pixel that is not transparent
						{
							topY = yPos;
							bottomY = yPos;
							flag = true;
						}
					}
					else
					{
						if(bmd.getPixel(xPos, yPos) != 0) // bottom most pixel that is not transparent
						{
							bottomY = yPos;
						}
					}					
				}
				
				// store the Points
				if(topY != -1)
				{
					arrTopPts.push(new Point(xPos, topY));
					topY = -1;
				}				
				if(bottomY != -1)
				{
					arrBottomPts.push(new Point(xPos, bottomY));
					bottomY = -1;
				}				
				flag = false;
			}
			
			
			// draw the hitarea
			hitArea.graphics.lineStyle(1,hitAreaColor);
			hitArea.graphics.beginFill(hitAreaColor);
			
			
			// DRAW TOP OUTLINE
			for(var i:Number = 0; i < arrTopPts.length; i++)
			{
				if(i == 0) // ie. first point
				{
					hitArea.graphics.moveTo(arrTopPts[i].x, arrTopPts[i].y);
				}
				else
				{
					hitArea.graphics.lineTo(arrTopPts[i].x, arrTopPts[i].y);
				}
			}
			
			// DRAW RIGHT HAND OUTLINE
			hitArea.graphics.lineTo(arrBottomPts[arrBottomPts.length-1].x, arrBottomPts[arrBottomPts.length-1].y);
			
			// DRAW BOTTOM HANDOUTLINE
			for(var j:Number = arrBottomPts.length-1; j >= 0; j--)
			{
				hitArea.graphics.lineTo(arrBottomPts[j].x, arrBottomPts[j].y);
			}
			
			// DRAW LEFT HAND OUTLINE
			hitArea.graphics.lineTo(arrTopPts[0].x, arrTopPts[0].y);
			
			hitArea.graphics.endFill();
			
			return hitArea;
		}
		

/**************************************************************************************
 * HELPER FUNCTIONS BELOW
 *************************************************************************************/
			

		/**
		 * Creates stroke properties object, using defaults for any null values
		 * 
		 * <p>Defaults for stroke properties if none are specified in the recieved parameter are as follows:
		 * thickness = 1, color = black, pixelHinting = true, scaleMode = none, alpha = 1</p>
		 *  
		 * @param props	An object containing stroke properties
		 * 
		 * @return 
		 * 
		 */		
		private static function getStroke(strokeProps:Object):Object 
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
		 * 
		 */	
		private static function getGradient(fill:Object):Object
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
		 * 
		 */
		private static function getSolid(fill:Object):Object
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
