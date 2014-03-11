package com.patricksteele.utils
{
	/**
	 * Class contains a collection of useful string manipulations functions
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 */
	public class StringUtils
	{
		public function StringUtils()
		{
		}
		
		/**
		 *	Funtion determines if the specified string begins with the specified prefix
		 *
		 *	@param str 		 The string that the prefix will be checked against
		 *	@param strPrefix The prefix that will be tested against the string
		 *
		 *	@returns Boolean
		 */
		public static function beginsWith(str:String, strPrefix:String):Boolean
		{
			var result:Boolean = false;
			
			if(str != null)
			{ 
				if(str.indexOf(strPrefix) == 0)
				{
					result = true;
				}
			}
			
			return result;
		}
		
		
		/**
		 *	Function determines if the specified string ends with the specified suffix
		 *
		 *	@param str 		 The string that the suffic will be checked against
		 *	@param strSuffix The suffix that will be tested against the string
		 *
		 *	@returns Boolean
		 */
		public static function endsWith(str:String, strSuffix:String):Boolean
		{
			var result:Boolean = false;
			
			if(str != null)
			{
				if(str.lastIndexOf(strSuffix) == str.length - strSuffix.length)
				{
					result = true;
				}
			}
			
			return result;
		}
		
		
		/**
		 *	Function determines if the specified string contains any instances of a substring
		 *
		 *	@param str 		The string to search
		 *	@param subStr 	The character or sub-string we are looking for
		 *
		 *	@returns Boolean
		 *
		 */
		public static function contains(str:String, subStr:String):Boolean
		{
			var result:Boolean = false;

			if(str != null)
			{
				if(str.indexOf(subStr) != -1)
				{
					result = true;
				}
			}
			
			return result;
		}
		
		
		
		
		/**
		 *	Function returns the number of times a character or sub-string occurs within a string
		 *
		 *	@param str 			  The string to search
		 *	@param subStr 		  The character or sub-string we are looking for
		 *	@param caseSensitive  A boolean flag to indicate if the search is case sensitive
		 *
		 *	@returns Number
		 */
		public static function countOf(str:String, subStr:String, caseSensitive:Boolean = true):Number
		{
			var count:Number = 0;
			
			if(str != null)
			{ 
				var char:String = subStr.replace(/(\]|\[|\{|\}|\(|\)|\*|\+|\?|\.|\\)/g, '\\$1');				
				var flags:String = (!caseSensitive) ? 'ig' : 'g';
				
				count =  str.match(new RegExp(char, flags)).length;
			}
			
			return count;			
		}
		
		
	
		/**
		 *	Function counts the number of words in a string
		 *
		 *	@param str The string to be checked
		 *
		 *	@returns Number
		 */
		public static function wordCount(str:String):Number
		{
			var count:Number = 0;
			
			if(str != null)
			{ 
				count = str.match(/\b\w+\b/g).length;
			}
			
			return count;
		}
		
		
		
		/**
		 *	Function determines if the specified string is numeric
		 *
		 *	@param str The string to check
		 *
		 *	@returns Boolean
		 *
		 */
		public static function isNumeric(str:String):Boolean
		{
			var result:Boolean = false;

			if(str != null)
			{
				var regx:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
				
				result = regx.test(str);
			}
			
			return result;
		}
		
		
		
		/**
		 *	Function returns the specified string in reverse character order
		 *
		 *	@param str The String that will be reversed
		 *
		 *	@returns String

		 */
		public static function reverse(str:String):String
		{
			var newStr:String = '';
			
			if(str != null)
			{
				newStr = str.split('').reverse().join('');
			}

			return newStr;
		}
		
		
		/**
		 *	Function returns the specified string in reverse word order
		 *
		 *	@param str The String that will be reversed
		 *
		 *	@returns String
		 */
		public static function reverseWords(str:String):String
		{
			var newStr:String = '';
			
			if(str != null)
			{
				newStr = str.split(/\s+/).reverse().join('');
			}
			
			return newStr;
		}
		
		
		/**
		 *	Fuction remove's all < and > based html tags from a string
		 *
		 *	@param str	 The string to be stripped of tags
		 *
		 *	@returns String
		 */
		public static function stripHTMLTags(str:String):String
		{
			var newStr:String = '';
			
			if(str != null)
			{
				newStr = str.replace(/<\/?[^>]+>/igm, '');
			}
			
			return newStr;
		}
		
		
		/**
		 *	Function removes whitespace from the front and the end of the specified
		 *	string
		 *
		 *	@param str	 The String whose beginning and ending whitespace will be removed
		 *
		 *	@returns String
		 */
		public static function trim(str:String):String
		{
			var newStr:String = '';
			
			if(str != null)
			{
				newStr = str.replace(/^\s+|\s+$/g, '');
			}
			
			return newStr;
		}
		
		
		/**
		 *	Function removes whitespace from the front of the specified string
		 *
		 *	@param str 	The String whose beginning whitespace will be removed
		 *
		 *	@returns String
		 */
		public static function trimLeft(str:String):String
		{
			var newStr:String = '';
			
			if(str != null)
			{
				newStr = str.replace(/^\s+/, '');
			}
			
			return newStr;
		}
		
		
		/**
		 *	Function removes whitespace from the end (right-hand side) of the specified string
		 *
		 *	@param str The String whose ending whitespace will be removed
		 *
		 *	@returns String
		 */
		public static function trimRight(str:String):String
		{
			var newStr:String = '';
			
			if(str != null)
			{
				newStr = str.replace(/\s+$/, '');
			}
			
			return newStr;
		}
		
		

	}
}