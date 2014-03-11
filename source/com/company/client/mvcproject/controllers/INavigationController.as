package com.company.client.mvcproject.controllers
{
	/**
	 * This is the strategy interface implemented by a controller (concrete strategy) in a Strategy Pattern
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 */
	public interface INavigationController
	{
		function changePageHandler(pageID:Number):void
		function changeStateHandler(stateID:Number):void
	}
}