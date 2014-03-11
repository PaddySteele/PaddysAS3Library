package com.company.client.mvcproject.events
{
	import flash.events.Event;

	/**
	 * This class allows us to define custom Events. 
	 * 
	 * <p>This CustomEvent allows passing of custom parameters when dispatching events
	 * that can then be retrieved by the handler function defined in the addEventListener</p>
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 * 
	 * @example The following code creates and dispatches a CustomEvent
	 * <listing version="3.0">
	 * var myEvent:CustomEvent = new CustomEvent(CustomEvent.CUSTOM_EVENT_TYPE);
	 * dispatchEvent(myEvent);
	 * </listing>
	 * 
	 * 
	 * @example The following code creates and dispatches a CustomEvent with custom parameters passed
	 * <listing version="3.0">
	 * var myEvent:CustomEvent = new CustomEvent(CustomEvent.CUSTOM_EVENT_TYPE, false, false, {param1: "first param", param2: "second param"});
	 * dispatchEvent(myEvent);
	 * </listing>
	 * 
	 * 
	 * @example The following code adds an EventListener for a CustomEvent
	 * <listing version="3.0">
	 * myObject.addEventListener(CustomEvent.CUSTOM_EVENT_TYPE, _eventHandler);
	 * 
	 * function _eventHandler(event:CustomEvent):void
	 * {
	 * 		trace(event.eventParams.param1); // traces custom parameter value
	 * }
	 * </listing>
	 * 
	 * 
	 */	
	public class CustomEvent extends Event
	{
		/**
		 * event constants
		 */		
		public static const CUSTOM_EVENT_TYPE:String = "customeventtype";
		
		public static const START_APPLICATION:String = "startapplication";
		
		public static const STAGE_RESIZED:String = "stageresized";
		
		public static const PAGE_CHANGED:String = "pagechanged";		
		public static const STATE_CHANGED:String = "stagechanged";	
		
		
		
		/**
		 * can hold any additional parameters for the CustomEvent 
		 */		
		private var _eventParams:Object;
		
		/**
		 * CONSTRUCTOR
		 * 
		 * @param type
		 * @param bubbles
		 * @param cancelable
		 * @param params
		 * 
		 */		 
		public function CustomEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, params:Object = null)
		{
			super(type, bubbles, cancelable);
			_eventParams = params;
		}
		
		
		public function get eventParams():Object
        {
            return _eventParams;
        }

		
		/**
		 * every custom event class must override clone()
		 * @return
		 */
		public override function clone():Event
		{
			return new CustomEvent(type, bubbles, cancelable, _eventParams);
		}
		

		/**
		 * every custome event class must override toString(). Note that "eventPhase"
		 * is an instance variable relating to the event flow
		 * 
		 * @return 
		 */		
		public override function toString():String
		{
			return formatToString("CustomEvent", "type", "bubbles", "cancelable", "eventPhase", "_eventParams")
			
		}

	}
}