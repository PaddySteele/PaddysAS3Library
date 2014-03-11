/**
 * StageStatusNotifier by Grant Skinner. June 20, 2006
 * Visit www.gskinner.com/blog for documentation, updates and more free code.
 *
 * You may distribute this class freely, provided it is not modified in any way (including
 * removing this header or changing the package path).
 *
 * Please contact info@gskinner.com prior to distributing modified versions of this class.
 */

package com.gskinner.utils {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	public class StageStatusNotifier extends EventDispatcher {
		
		public static var ADDED_TO_STAGE:String = "addedToStage";
		public static var REMOVED_FROM_STAGE:String = "removedFromStage";
		
		protected var target:DisplayObject;
		protected var removedDispatchers:Dictionary;
		protected var addedDispatchers:Dictionary;
		protected var onStage:Boolean;
		
		public function StageStatusNotifier(p_target:DisplayObject) {
			target = p_target;
			onStage = (p_target.stage != null);
			// find the top parent:
			var top:DisplayObject = target;
			while (top.parent) {
				top = top.parent;
			}
			setupListeners(top);
		}
		
		protected function setupListeners(p_addedDispatcher:DisplayObject=null):void {
			removedDispatchers = new Dictionary(true);
			addedDispatchers = new Dictionary(true);
			
			// set up removed listeners:
			var ref:DisplayObject = target;
			while (ref) {
				removedDispatchers[ref] = true;
				ref.addEventListener(Event.REMOVED, handleChange, false, 0, true);
				ref = ref.parent;
			}
			
			// set up the added listener:
			if (p_addedDispatcher != null) {
				p_addedDispatcher.addEventListener(Event.ADDED, handleChange, false, 0, true);
				addedDispatchers[p_addedDispatcher] = true;
			}
		}
		
		protected function clearListeners():void {
			if (removedDispatchers == null) { return; }
			var evtDispatcher:Object;
			for (evtDispatcher in removedDispatchers) {
				evtDispatcher.removeEventListener(Event.REMOVED, handleChange);
			}
			for (evtDispatcher in addedDispatchers) {
				evtDispatcher.removeEventListener(Event.ADDED, handleChange);
			}
			removedDispatchers = addedDispatchers = null;
		}
		
		protected function handleChange(p_evt:Event):void {
			if (p_evt.target != p_evt.currentTarget) { return; }
			var evt:Event = null;
			var top:DisplayObject = null;
			
			if (p_evt.type == Event.ADDED && onStage == false && target.stage != null) {
				// added to stage:
				onStage = true;
				evt = new Event(ADDED_TO_STAGE);
			} else if (p_evt.type == Event.ADDED && onStage == false && target.stage == null) {
				// added to something not on stage, find new top parent:
				top = p_evt.target as DisplayObject;
				while (top.parent) {
					top = top.parent;
				}
			} else if (p_evt.type == Event.REMOVED) {
				// removed from something, update top:
				top = p_evt.target as DisplayObject;
				if (onStage == true) {
					// removed from stage.
					evt = new Event(REMOVED_FROM_STAGE);
					onStage = false;
				}
			}
			
			clearListeners();
			setupListeners(top);
			
			// dispatch event last:
			if (evt) {
				target.dispatchEvent(evt);
			}
		}
		
	}
	
}