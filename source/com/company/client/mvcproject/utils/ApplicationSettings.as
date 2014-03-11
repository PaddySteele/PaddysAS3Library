package com.company.client.mvcproject.utils
{

	/**
	 * A Singleton class for storing and providing global access to application settings loaded from XML. 
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 * @example The following example uses the Singleton ApplicationSettings to store and return a global app setting 
	 * <listing version="3.0">
	 * 	package 
	 * 	{ 
	 * 		com.company.client.mvcproject.utils.ApplicationSettings;
	 * 
	 * 		public class SettingsExample
	 * 		{ 
	 * 			public function SettingsExample()
	 * 			{
	 * 				ApplicationSettings.getInstance().setProperty("myVarId", "myVarValue");				
	 * 				
	 * 				// Displays: myVarValue
	 * 				trace(ApplicationSettings.getInstance().getProperty("myVarId"));
	 *  		}
	 * 		}
	 *	}
	 * </listing>
	 * 
	 */	
	public class ApplicationSettings
	{
		/**
		 * set as static so it is accessible to getInstance() function below 
		 */		
		private static var _instance:ApplicationSettings;
		
		/**
		 * Object to hols properties 
		 */		
		private var _properties:Object = {};
		
		

		/**
		 * enforced constructor 
		 * 
		 * @param enforcer
		 * 
		 */		
		public function ApplicationSettings(enforcer:SingletonEnforcer):void
		{
			super();
			
			if (enforcer == null)
			{
				throw Error("Singleton Enforcer Not Valid. Multiple Instances Not Allowed.");
			}
		}
		
		
		/**
		 * This function is static therefore it can be invoked before an instance of the class exists 
		 * @return 
		 * 
		 */		
		public static function getInstance():ApplicationSettings
		{
			if(_instance == null)
			{
				_instance = new ApplicationSettings(new SingletonEnforcer());
			}

			return _instance;
		}

		
		/**
		 * function stores a proptery with its identifier
		 *  
		 * @param id
		 * @param prop
		 * 
		 */		
		public function setProperty(id:String, prop:*):void
		{
			_properties[id] = prop;
		}
		
		/**
		 * function returns the property with the specified identifier 
		 * @param id
		 * @return 
		 * 
		 */		
		public function getProperty(id:String):*
		{
			if (_properties[id] != null)
			{
				return _properties[id];
			}
			else 
			{
				return null;
			}
		}

	}
}



/**
 * Singleton enforcer class 
 * 
 */
class SingletonEnforcer
{
	public function SingletonEnforcer()
	{
		// trace("ApplicationSettings:SingletonEnforcer called");
	}
}