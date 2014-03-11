package com.patricksteele.utils
{
	/**
	 * Class contains a collection of useful form validation functions
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 */	
	public class ValidationUtils
	{
		public function ValidationUtils()
		{
		}

		
		/**
		 * Function checks if the passed in email address is valid 
		 * @param email Eamil address to check
		 * 
		 * @return Returns <code>true</code> if email is valid. Returns <code>false</code> if email is invalid
		 * 
		 * @example Below is an example of how this would be called
		 * <listing version="3.0">
		 * 		trace(ValidationUtils.isValidEmail("paddy@gmail.com")); // true
		 * 		trace(ValidationUtils.isValidEmail("paddygmail.com")); // false
		 * 		trace(ValidationUtils.isValidEmail("paddy@gmail.c")); // false 
		 * </listing>
		 * 
		 */		
		public static function isValidEmail(strEmail:String):Boolean
		{
			var emailExpression:RegExp = /^[a-z][\w.-]+@\w[\w.-]+\.[\w.-]*[a-z][a-z]$/i;
			return emailExpression.test(strEmail);
		}
		
		
		
		/**
		 * Determines if a string is a valid UK PostCode Format
		 * 
		 * @param   strPostCode The postcode to be tested
		 * @return  Returns <code>true</code> if postcode is valid. Returns <code>postcode</code> if email is invalid
		 */
		public static function postCodeUK(strPostCode:String):Boolean
		{
			var regExp:RegExp = /^([Gg][Ii][Rr] 0[Aa]{2})|((([A-Za-z][0-9]{1,2})|(([A-Za-z][A-Ha-hJ-Yj-y][0-9]{1,2})|(([A-Za-z][0-9][A-Za-z])|([A-Za-z][A-Ha-hJ-Yj-y][0-9]?[A-Za-z])))) {0,1}[0-9][A-Za-z]{2})$/i;
			return regExp.test(strPostCode);		
		}
		
		
		
		/**
		 * Function checks if a Strings length sits within the required bounds
		 * 
		 * @param str		The String to check
		 * @param minChars	String must be at least this length
		 * @param maxChars	String can't be longer than this
		 * 
		 * @return
		 */
		public static function charLimitCheck(str:String, minChars:int = 0, maxChars:int = 15):Boolean
		{
			if (str.length >= minChars && str.length <= maxChars)
			{
				return true;
			}
			
			return false;
		}
		
		
		
			

		/**
		 * Function checks if the string passed in contains a profanity
		 * 
		 * @param str	The string to check for profanities
		 * 
		 * @return True if recieved String contains a profanity. False if clean.
		 * 
		 * @example Below is an example of how this would be used
		 * <listing version="3.0">
		 * 		trace(ValidationUtils.checkProfanity("SH1T")); // true
		 * 		trace(ValidationUtils.checkProfanity("SHIT")); // true
		 * 		trace(ValidationUtils.checkProfanity("hello")); // false
		 * </listing> 
		 * 
		 * 
		 */		
		public static function checkProfanity(str:String):Boolean
		{
			var newStr:String = toLCAN(str);
			newStr = replaceSuspectNumbers(newStr);
			
			trace("The string we are checking for profanity is: " + newStr);
			
			for (var i:Number = 0; i < _profanities.length; i++)
			{
				if (newStr.search(_profanities[i]) != -1)
				{
					return true;
				}
			}
			
			return false;
		}
		
		
		
		
/******************************************************************
 * HELPER FUNCTIONS FOR checkProfanity() FUNCTION
 ******************************************************************/
		
		/**
		 * Function strips out all spaces, punctuation etc. from a string and converts it to lowercase.
		 * 
		 * <p>The String returned contains only lower case alphanumeric characters</p>
		 * 
		 * @param	str
		 * 
		 * @return
		 */
		private static function toLCAN(str:String):String
		{
			var newStr:String = "";
			
			var lowStr:String = str.toLowerCase();
			
			var a:String = "a";
			var z:String = "z";
			var zero:String = "0";
			var nine:String = "9";
			
			for (var i:Number = 0; i < lowStr.length; i++)
			{
				if (((lowStr.charCodeAt(i) >= a.charCodeAt(0) && lowStr.charCodeAt(i) <= z.charCodeAt(0)) || 
					(lowStr.charCodeAt(i) >= zero.charCodeAt(0) && lowStr.charCodeAt(i) <= nine.charCodeAt(0))))
				{
					newStr += lowStr.charAt(i);
				}
			}
			
			return newStr;
		}
		
		
		/**
		 * Function replaces any suspicious numbers in the string passed in. 
		 * This is to try and stop things like 5h1t and V14gra
		 * 
		 * @param str The string to be processed
		 * 
		 * @return
		 */		
		private static function replaceSuspectNumbers(str:String):String
		{
			var letterNumbers:Array = new Array();
			letterNumbers.push({number:0, letter:"o"});
			letterNumbers.push({number:1, letter:"i"});
			letterNumbers.push({number:2, letter:"z"});
			letterNumbers.push({number:3, letter:"e"});
			letterNumbers.push({number:4, letter:"a"});			
			letterNumbers.push({number:5, letter:"s"});
			letterNumbers.push({number:7, letter:"t"});
			letterNumbers.push({number:8, letter:"b"});
			
			var newStr:String = str.substring(0);
			
			for (var i:Number = 0; i < letterNumbers.length; i++)
			{
				newStr = newStr.split(letterNumbers[i].number).join(letterNumbers[i].letter);
			}
			
			return newStr;			
		}
		
		
		/**
		 * A list of bad words used by checkProfanity() function
		 */		
		private static var _profanities:Array = [
			"anal",
			"anus",
			"arse",
			"ass",
			"ballsack",
			"balls",
			"bastard",
			"bellend",
			"bitch",
			"biatch",
			"bloody",
			"blowjob",
			"blow job",
			"bollock",
			"bollok",
			"boner",
			"boob",
			"bugger",
			"bum",
			"butt",
			"buttplug",
			"cannabis",
			"cialis",
			"clitoris",
			"cocaine",
			"cock",
			"coon",
			"crack",
			"crap",
			"cunt",
			"damn",
			"dick",
			"dickhead",
			"dildo",
			"dyke",
			"fag",
			"feck",
			"fellate",
			"fellatio",
			"felcher",
			"felching",
			"fuck",
			"f u c k",
			"fudgepacker",
			"fudge packer",
			"flange",
			"Goddamn",
			"God damn",
			"hell",
			"homo",
			"http",
			"jerk",
			"jizz",
			"knobend",
			"knob end",
			"labia",
			"lmao",
			"lmfao",
			"muff",
			"nigger",
			"nigga",
			"omg",
			"penis",
			"piss",
			"poop",
			"prick",
			"pube",
			"pussy",
			"queer",
			"scrotum",
			"sex",
			"shit",
			"s hit",
			"sh1t",
			"slut",
			"smegma",
			"spunk",
			"tit",
			"titties",
			"tosser",
			"turd",
			"twat",
			"vagina",
			"viagra",
			"wank",
			"whore",
			"wtf",
			"www"			
		];
		

	}
}