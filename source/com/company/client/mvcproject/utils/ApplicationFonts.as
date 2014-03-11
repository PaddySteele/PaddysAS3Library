package com.company.client.mvcproject.utils
{
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	
	/**
	 * Class allows access to embedded Fonts liinked and exported from library of Fla file
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 */	
	public class ApplicationFonts
	{
		/**
		 * CONSTRUCTOR 
		 */		
		public function ApplicationFonts(){}
		
		
		/**
		 * Specify an embedded font from the Fla library. The font in the library must have it's linkage setup so
		 * it is exported for actionscript. 
		 * 
		 * <p>If we need variations of a font such as bold and italic we must also create a Font for them in the Fla library
		 * and set up linkage for them.</p>
		 * 
		 * <p>Although all needed variations of the Font must be declared here when we create a TextFormat we only need
		 * to set the first variation for it's font property and Flash will automatically find the bold and italic variations.</p>
		 */
		private static var _font:Font = new VerdanaFont(); // Verdana
		private static var _fontB:Font = new VerdanaFontBold(); // Verdana Bold
		private static var _fontI:Font = new VerdanaFontBoldItalic(); // Verdana Italic
		private static var _fontBI:Font = new VerdanaFontItalic(); // Verdana Bold + Italic

		
		

		/**
		 * Function returns a TextFormat for standard TextFields
		 * @return TextFormat
		 * 
		 */		
		public static function getStandardTextFormat():TextFormat
		{
			var standardTF:TextFormat = new TextFormat(_font.fontName, 12);
			standardTF.align = TextFormatAlign.LEFT;
			//standardTF.leading = -5;
			//standardTF.kerning = -20;		
			return standardTF;
		}
		
		
		/**
		 * Function returns TextFormat for Input TextFields
		 * @return TextFormat
		 * 
		 */		
		public static function getInputTextFormat():TextFormat
		{
			var inputTF:TextFormat = new TextFormat(_font.fontName, 12);
			inputTF.align = TextFormatAlign.LEFT;
			return inputTF;
		}
		
		
		
		/**
		 * Function returns TextFormat for ToolTips
		 * @return TextFormat
		 * 
		 */		
		public static function getToolTipTextFormat():TextFormat
		{
			var tooltipTF:TextFormat = new TextFormat(_font.fontName,10);
			tooltipTF.align = TextFormatAlign.LEFT;
			return tooltipTF;
		}
		
		

	}
}