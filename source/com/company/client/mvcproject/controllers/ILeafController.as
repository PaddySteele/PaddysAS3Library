package com.company.client.mvcproject.controllers
{
	/**
	 * This is the strategy interface implemented by a controller (concrete strategy) in a Strategy Pattern
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 */
	public interface ILeafController
	{
		function userActionHandler(userInput:Number):void
	}
}