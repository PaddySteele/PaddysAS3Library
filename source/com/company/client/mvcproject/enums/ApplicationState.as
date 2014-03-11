package com.company.client.mvcproject.enums
{
	/**
	 * Enumerations class specifing custom data type to keep track of the current state the application. The different states
	 * will determine which views should be on the display list.
	 * 
	 * <p>By convention an enumerator class is declared with the final attribute as there is no need to extend the class</p> 
	 * 
	 * <p>This enummerator stores the various sections (and hence views) the swf can display</p>
	 * 
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 * @see <url>http://vijayram.wordpress.com/2007/01/26/actionscript-code-tricks-2/</url>
	 * @see <url>http://livedocs.adobe.com/flex/2/docs/00001843.html</url>
	 * 
	 */	
	public final class ApplicationState
	{
				
		public static const STATEA:ApplicationState = new ApplicationState(0);
		public static const STATEB:ApplicationState = new ApplicationState(1);
			
		/**
		 * holds an associated Number for the enummerator 
		 */		
		private var _value:Number;
		
		/**
		 * Constructor 
		 * @param val
		 * 
		 */		
		public function ApplicationState(val:Number):void
		{
			_value = val;
		}

		

		/**
		 * getter function to return an enummerators associated Number value 
		 * @return 
		 * 
		 */		
		public function get value():Number
		{
			return _value;
		}

	}
}