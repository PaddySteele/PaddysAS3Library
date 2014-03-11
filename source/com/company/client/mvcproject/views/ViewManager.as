package com.company.client.mvcproject.views
{
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	/**
	 * Singleton class that defines functions for adding/removing ComponentViews from the root Composite
	 * View and hence the display list. Also defines functions for the transitions used when showing/hiding
	 * Component Views
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 */	
	public class ViewManager
	{
		/**
		 * set as static so it is accessible to getInstance() function below. 
		 * Holds an instance of this Singleton class.
		 */	
		private static var _instance:ViewManager;

		/**
		 * The CompositeView that contains the various ComponentView's to be managed. 
		 * This is the root Composite View in the Composite Pattern of the MVC's Views
		 */		
		private var _rootView:CompositeView;
		
		
		
		/**
		 * Singleton costructor
		 * 
		 * @param enforcer	See SingletonEnforcer class at bottom of this .as file
		 */		
		public function ViewManager(enforcer:SingletonEnforcer)
		{		
			if (enforcer == null)
			{
				throw Error("Singleton Enforcer Not Valid. Multiple Instances Not Allowed.");
			}
		}
		
		
		/**
		 * This is the Singleton instatiation method. If ViewManager._instance already exists it is returned
		 * otherwise a new one is created.
		 * 
		 * <p>This function is static therefore it can be invoked before an instance of the class exists</p>
		 * 
		 * @return an Instance of the ViewManager Singleton
		 * 
		 */		
		public static function getInstance():ViewManager
		{
			if(_instance == null)
			{
				_instance = new ViewManager(new SingletonEnforcer());
			}
			
			return _instance;
		}
		
		
		
		/**
		 * Stores ref to root display object 
		 * @param rootView	The root DisplayObjectContainer which contains the views
		 * 
		 */		
		public function init(rootView:CompositeView):void 
		{
			_rootView = rootView;			
		}
		
		
		/**
		 * Function adds a ComponentView to the display list
		 * 
		 * @param aView	The ComponentView to be added
		 * 
		 */		
		public function addViewToDisplay(aView:ComponentView):void
		{
			if(_rootView != null)
			{
				if(_rootView.contains(aView) == false)
				{
					_rootView.addChild(aView);
				}
			}
		}
		
		
		/**
		 * Function removes a ComponentView from the display list. 
		 * 
		 * <p>View is just removed from display list but is left in the Composite Pattern for future use</p>
		 * 
		 * @param aView	The ComponentView to be removed
		 * 
		 */				
		public function removeViewFromDisplay(aView:ComponentView):void
		{
			if(_rootView != null)
			{
				if(_rootView.contains(aView) == true)
				{
					_rootView.removeChild(aView);
				}
			}
		}
		
		
		/**
		 * Function removes a ComponentView from the Composite Pattern of which _rootView
		 * is the root CompositeView. This means the ComponentView will no longer be in the update chain
		 * when a model is updated. Also removes the ComponentView from the display list
		 * 
		 * <P>This function would be useful for when removing all references to a ComponentView
		 * if it is to be DESTROYED!</p>
		 * 
		 * @param aView	The ComponentView to be removed
		 * 
		 */				
		public function removeViewFromComposite(aView:ComponentView):void
		{
			if(_rootView != null)
			{
				if(_rootView.contains(aView) == true)
				{
					_rootView.removeChild(aView);
				}
				
				_rootView.remove(aView);
			}
		}
		
		
		
		
		/**
		 * Function fades in a view
		 *  
		 * @param view		The ComponentView to be faded in
		 * @param fadeTime	The time it takes for the fade tween
		 * @param callback	An optional function to be called once the transition is complete
		 * 
		 */	
		public function fadeInView(aView:ComponentView, fadeTime:Number = 1, callback:Function = null):void
		{
			if (callback != null) // fire callback function on complete if specified
			{
				TweenLite.to(aView, fadeTime, {alpha:1, onComplete:callback});
			}
			else
			{
				TweenLite.to(aView, fadeTime, {alpha:1});
			}
		}
		
		/**
		 * Function fades out a view
		 *  
		 * @param view		The ComponentView to be faded out
		 * @param fadeTime	The time it takes for the fade tween
		 * @param callback	An optional function to be called once the transition is complete
		 * 
		 */	
		public function fadeOutView(aView:ComponentView, fadeTime:Number = 1, callback:Function = null):void
		{
			if (callback != null) // fire callback function on complete if specified
			{
				TweenLite.to(aView, fadeTime, {alpha:0, ease:Cubic.easeOut, onComplete:callback});
			}
			else
			{
				TweenLite.to(aView, fadeTime, {alpha:0, ease:Cubic.easeOut});
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
		// trace("ViewManager:SingletonEnforcer called");
	}
}