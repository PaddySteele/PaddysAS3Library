package com.company.client.mvcproject.views
{
	import com.company.client.mvcproject.events.CustomEvent;
	import com.company.client.mvcproject.model.IModel;
	
	import flash.display.Stage;
	import flash.events.Event;

	/**
	 * Subclasses CompositeView and acts as the main root view for all views to be displayed on screen.
	 * 
	 * <p>Doesnt really do anything but act as the parent/owner of all it's child views and send updates
	 * recieved from Model down to them</p>
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 */	
	public class RootCompositeView extends CompositeView
	{
	
		 /**
		 * CONSTRUCTOR
		 * @param aModel Reference to Model in MVC Pattern
		 * @param aController Reference to Controller in MVC Pattern. (Default of null as not all component views need to handle user input)
		 * 
		 */	
		public function RootCompositeView(aModel:IModel = null, aController:Object = null)
		{
			super(aModel, aController);		
		}
		

		
		/**
		 * As this is a Composite View the overriden <code>updateView()</code> needs to call its superclass
		 * to ensure that updates trickle down to its children as well.
		 * 
		 * <p>Calls the <code>updateView()</code> method in all its children allowing them to update themselves
		 * when the Models current state changes.
		 * 
		 * @param event
		 * 
		 * @see CompositeView#updateView()
		 */		
		override public function updateView(event:CustomEvent = null):void 
		{			
			super.updateView(event);
		}
		
		
		
	}
		

}
