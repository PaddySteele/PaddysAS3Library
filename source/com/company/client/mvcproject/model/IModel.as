package com.company.client.mvcproject.model
{
	import com.company.client.mvcproject.enums.ApplicationState;
	
	import flash.events.IEventDispatcher;
	import flash.geom.Point;

	public interface IModel extends IEventDispatcher
	{
		function startApplication():void
		function setSwfDimensions(swfWidth:Number, swfHeight:Number):void
		function getSwfDimensions():Point
			
		function init(modelXML:XML):void
		function getPages():Array
		function setCurrentPageIndex(index:Number):void
		function getCurrentPageIndex():Number
			
		function setApplicationState(state:ApplicationState, additionalParams:Object = null):void
		function getApplicationState():ApplicationState
	
	}
}
