package com.company.client.mvcproject.controllers
{
	import com.company.client.mvcproject.model.IModel;

	/**
	 * This controller implements the ILeafController interface and decides how user interaction
	 * with the LeafView (ie. the concrete component view that contains ...) should be handled.
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
	public class LeafController implements ILeafController
	{
		private var _model:Object;
		
		/**
		 * CONSTRUCTOR 
		 * @param aModel Takes in an instance of the model to be controlled
		 * 
		 */		
		public function LeafController(aModel:IModel)
		{
			_model = aModel;
		}
		
		
		/**
		 * Updates the model with 
		 * 
		 */		
		public function userActionHandler(userInput:Number):void
		{
			//(_model as IModel).setModelProperty(userInput);					
		}
		
	}
}