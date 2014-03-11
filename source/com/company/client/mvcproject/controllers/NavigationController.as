package com.company.client.mvcproject.controllers
{
	import com.company.client.mvcproject.enums.ApplicationState;
	import com.company.client.mvcproject.model.IModel;
	
	/**
	 * This controller implements the INavigationHandler interface and decides how user interaction
	 * with the NavigationView (ie. the concrete component view that contains the applications
	 * primary navigation) should be handled.
	 * 
	 * <p>The controller has handler functions that may trigger changes in the model based on how
	 * the user interacts with it's associated view.</p>
	 * 
	 * <p>The relationship between the controller and view is that of strategy and context in
	 * a Strategy Pattern. Each controller will be a concrete strategy implementing required behaviours
	 * defined in a strategy interface. The context class will be the controllers associated concrete 
	 * component view</p>
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 */	
	public class NavigationController implements INavigationController
	{
		private var _model:Object;
		
		/**
		 * CONSTRUCTOR 
		 * @param aModel Takes in an instance of the model to be controlled
		 * 
		 */		
		public function NavigationController(aModel:IModel)
		{
			_model = aModel;
		}
		
		
		
		/**
		 * Updates the model with the index of the users newly selected page.
		 * 
		 */		
		public function changePageHandler(pageID:Number):void
		{
			var arrPages:Array = _model.getPages();
			
			var pageIndex:Number = -1;
			
			for(var i:int = 0; i < arrPages.length; i++)
			{
				if(arrPages[i].getPageId() == pageID)
				{
					pageIndex = i;
				}
			}
			
			// ONLY UPDATE IF A NEW PAGE
			if(pageIndex != -1 && pageIndex != _model.getCurrentPageIndex())
			{
				(_model as IModel).setCurrentPageIndex(pageIndex);
			}
							
		}
		
		/**
		 * Updates the model with the new state for the application.
		 * 
		 */		
		public function changeStateHandler(stateID:Number):void
		{
			var newState:ApplicationState;
			
			switch(stateID)
			{
				case 1:
					newState = ApplicationState.STATEA;
					break;
				
				case 2:
					newState = ApplicationState.STATEB;
					break;
				
				default:
			}
			
			// ONLY UPDATE IF A NEW STATE
			if((_model as IModel).getApplicationState() != newState)
			{
				(_model as IModel).setApplicationState(newState);
			}
			
		}
		
	
		
	}
}