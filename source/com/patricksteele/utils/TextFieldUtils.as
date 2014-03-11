package com.patricksteele.utils
{
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	/**
	 * Class defines some handy static functions for creating customized TextFields
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 */	
	public class TextFieldUtils
	{
		
		/**
		 * constructor. Does nothing. 
		 */		
		public function TextFieldUtils()
		{
		}
		

		/**
		 * Function creates a customized standard TextField with the properties defined by the recieved parameters
		 * 
		 * @param ifSelectable	If text should be selectable by the mouse. Default = true.
		 * @param ifMultiLine	If TextField should be a single line or multiline. Default = false.
		 * @param ifWordWrap	If text should be word wrapped in a multiline TextField. Default = false.
		 * @param ifBorder		If the TextField should have a border. Default = false.
		 * @param ifEmbedFonts	Whether or not to embed fonts. Default = false.
		 * @param autoSizing	The autosize value. Default = TextFieldAutoSize.LEFT.
		 * @param antiAliasing	The antiAliasType value. Default = AntiAliasType.ADVANCED.
		 * 
		 * @return 
		 * 
		 * @example Below is an example
		 * <listing version="3.0">
		 * 		var tf:TextField = TextFieldUtils.getStandardTextField(true, false, false, false, true, "left", "advanced");
		 * 		tf.defaultTextFormat = myTextFormat;
		 * 		tf.htmlText = "<font color='#333333'>myText</font>";
		 * 		addChild(tf);
		 * </listing>
		 */		
		public static function getStandardTextField(ifSelectable:Boolean = true, ifMultiLine:Boolean = false, ifWordWrap:Boolean = false, ifBorder:Boolean = false, ifEmbedFonts:Boolean = false, autoSizing:String = "left", antiAliasing:String = "advanced"):TextField
		{
			var standardTextField:TextField = new TextField();
			standardTextField.selectable = ifSelectable;			
			standardTextField.multiline = ifMultiLine;
			standardTextField.wordWrap = ifWordWrap;
			standardTextField.border = ifBorder;
			standardTextField.embedFonts = ifEmbedFonts;			
			standardTextField.autoSize = autoSizing;
			standardTextField.antiAliasType = antiAliasing; //AntiAliasType.ADVANCED , AntiAliasType.NORMAL;

			return standardTextField;
		}
		
		
		

		
		
		/**
		 * Method creates a customized input TextField with the properties defined by the recieved parameters
		 * 
		 * @param tfWidth		Width of the input TextField
		 * @param tfHeight		Height of the input TextField
		 * @param ifSelectable	If text should be selectable by the mouse. Default = true.
		 * @param ifMultiLine	If TextField should be a single line or multiline. Default = false.
		 * @param ifWordWrap	If text should be word wrapped in a multiline TextField. Default = false.
		 * @param ifBorder		If the TextField should have a border. Default = false.
		 * @param ifEmbedFonts	Whether or not to embed fonts. Default = false.
		 * @param antiAliasing	The antiAliasType value. Default = AntiAliasType.ADVANCED.
		 * @param ifBackground	If there should be a background for the TextField. Default = true.
		 * @param bgColor		The color for the background if present. Default = 0xFFFFFF.
		 * 
		 * @return 
		 * 
		 * @example Below is an example
		 * <listing version="3.0">
		 * 		var tf:TextField = TextFieldUtils.getInputTextField(120, 25, true, false, false, false, false, "normal", true, 0xFFFFFF);
		 * 		tf.defaultTextFormat = myTextFormat; // if we want to set a text format
		 * 		addChild(tf);
		 * </listing>
		 * 
		 */		
		public static function getInputTextField(tfWidth:Number, tfHeight:Number, ifSelectable:Boolean = true, ifMultiLine:Boolean = false, ifWordWrap:Boolean = false, ifBorder:Boolean = false, ifEmbedFonts:Boolean = false, antiAliasing:String = "normal", ifBackground:Boolean = true, bgColor:uint = 0xFFFFFF):TextField
		{
			var inputTextField:TextField = new TextField();
			inputTextField.type = TextFieldType.INPUT;
			
			inputTextField.width = tfWidth;
			inputTextField.height = tfHeight;
			
			inputTextField.selectable = ifSelectable;			
			inputTextField.multiline = ifMultiLine;
			inputTextField.wordWrap = ifWordWrap;
					
			inputTextField.border = ifBorder;
			inputTextField.embedFonts = ifEmbedFonts;
			inputTextField.antiAliasType = antiAliasing; //AntiAliasType.ADVANCED , AntiAliasType.NORMAL;

			inputTextField.background = ifBackground;			
			if(ifBackground)
			{
				inputTextField.backgroundColor = bgColor;
			}
			
			return inputTextField;
		}
		
		
		/** 
		 * Restrict a TextField to email only characters. 
		 * 
		 * @param tf The TextField to restrict. 
		 */ 
		public static function restrictToEmail(tf:TextField):void 
		{ 
			tf.restrict = "a-zA-Z0-9@._-"; 
		} 
		
		
		/** 
		 * Restrict a TextField to letters (lower+upper) and numbers only. 
		 * 
		 * @param tf The TextField to restrict. 
		 */ 
		public static function restrictToLettersAndNumbers(tf:TextField):void 
		{ 
			tf.restrict = "a-zA-Z0-9"; 
		}
		
		
		/** 
		 * Restrict a TextField to letters (lower+upper) only. 
		 * 
		 * @param tf The TextField to restrict. 
		 */ 
		public static function restrictToLetters(tf:TextField):void 
		{ 
			tf.restrict = "a-zA-Z"; 
		}
		
		
		/** 
		 * Restrict a TextField to numbers only. 
		 * 
		 * @param tf The TextField to restrict. 
		 */ 
		public static function restrictToNumbers(tf:TextField):void 
		{ 
			tf.restrict = "0-9"; 
		} 
		
		
	
	}
}