package com.company.client.mvcproject.model
{
	/**
	 * Page Class defines the content for a Page
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 */	
	public class Page
	{		
		/**
		 * page id
		 */		
		private var _id:Number;
		
		/**
		 * page name
		 */		
		private var _name:String;
		
		/**
		 * heading
		 */		
		private var _strHeading:String;
		
		/**
		 * text content
		 */
		private var _strContent:String;
		
		
		/**
		 * constructor 
		 * 
		 */		
		public function Page(id:Number, name:String, headingStr:String, contentStr:String)
		{
			_id = id;
			_name = name;
			_strHeading = headingStr;
			_strContent = contentStr;			
		}
		
		
		/**
		 * returns the id of a Page
		 * @return 
		 */		
		public function getPageId():Number
		{
			return _id;
		}
		
		/**
		 * returns the id of a Page
		 * @return 
		 */		
		public function getPageName():String
		{
			return _name;
		}	
		
		
		/**
		 * returns the heading for a page
		 * @return 
		 */		
		public function getPageHeading():String
		{
			return _strHeading;
		}		
		
		
		/**
		 * returns the text content for a page
		 * @return 
		 */		
		public function getPageContent():String
		{
			return _strContent;
		}
	
	}
}