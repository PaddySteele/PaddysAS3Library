package com.company.client.mvcproject.views
{
	import com.company.client.mvcproject.events.CustomEvent;
	
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	
	/**
	 * The ABSTRACT Component class (should be subclassed and not instantiated) in a Composite Pattern which
	 * is the abstraction for both Leaf and Composite Components.
	 * 
	 * <p>Declares the interface for accessing and managing its child components. And implements default behaviour
	 * where necessary.</p>
	 * 
	 * <p>OPTIONAL - Defines an interface for accessing a Components parent in the recursive structure and implements
	 * it if thats appropriate.</p>
	 * 
	 * <p>Extends Sprite as most views will draw on the stage.</p>
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 */	
	public class ComponentView extends Sprite
	{
		/**
		 * holds reference to Model in MVC Pattern 
		 */		
		protected var _model:Object;
		
		/**
		 * holds reference to Controller in MVC Pattern
		 */		
		protected var _controller:Object;
		
		/**
		 * need ref to parent so can remove nodes safely via the parent 
		 */		
		protected var _parentNode:CompositeView = null;
		
		/**
		 * a name for this View 
		 */		
		private var _name:String;
		
		
		/**
		 * CONSTRUCTOR
		 * @param aModel
		 * @param aController Default value of null as not all views handle user input
		 * 
		 */	
		public function ComponentView(aModel:Object = null, aController:Object = null)
		{
			_model = aModel;
			_controller = aController;
		}
			
		
		
		/**
		 * An operation() method in the Composite Pattern. It is defined as an ABSTRACT method 
		 * without implementation and must be overriden in it's subclasses. 
		 * 
		 * <p>This method is the listener function that intercepts update notification from the Model 
		 * that its current state has changed. It is left up to the Leaf and Composite subclasses to
		 * provide an implementation for it in order to update their user interfaces.</p>
		 * 
		 * @param event Has a default of null allowing method to be called without passing event parameter. This
		 * 	can be useful when initially drawing a user interface in its default state
		 * 
		 */		
		public function updateView(event:CustomEvent = null):void 
		{
		}
		
		
		
		
		
		/**
		 * Default implementation is designed for leaf nodes and will raise an exception by throwing
		 * an IllegalOperationError. This is the case as leaf nodes cannot have children and should not
		 * implement operations that deal with child nodes.
		 * 
		 * <p>This function is overriden in the CompositeView class</p>
		 * 
		 * @param c	The ComponentView to be added to a CompositeView
		 * 
		 * @see CompositeView#add()
		 */		
		public function add(c:ComponentView):void 
		{
			throw new IllegalOperationError("add operation not supported");
		}
		
		
		
		/**
		 * Default implementation is designed for leaf nodes and will raise an exception by throwing
		 * an IllegalOperationError. This is the case as leaf nodes cannot have children and should not
		 * implement operations that deal with child nodes.
		 * 
		 * <p>This function is overriden in the CompositeView class</p>
		 * 
		 * @param c	The ComponentView to be removed from a CompositeView
		 * 
		 * @see CompositeView#remove()
		 */		
		public function remove(c:ComponentView):void 
		{
			throw new IllegalOperationError("remove operation not supported");
		}
		

		/**
		 * Default implementation is designed for leaf nodes and will raise an exception by throwing
		 * an IllegalOperationError. This is the case as leaf nodes cannot have children and should not
		 * implement operations that deal with child nodes.
		 * 
		 * <p>This function is overriden in the CompositeView class where it allows access to the children
		 * of the composite node</p>
		 * 
		 * @param n Position of child object to be returned
		 * 
		 * @return Returns child ComponentView by the position indicated by the parameter n
		 * 
		 * @see CompositeView#getChild()
		 */	
		public function getChild(n:int):ComponentView 
		{ 
			throw new IllegalOperationError("getChild operation not supported");
			return null;
		}
		
		
		
		/**
		 *  Function returns the Parent CompositeView for this ComponentView
		 * @return 
		 * 
		 */		
		public function getParent():CompositeView
		{
			return this._parentNode;
		}
		
		
		
		/**
		 * Declared internal to prohibit setting from outside of package as the parent link should only be set in 
		 * the add() method implementation in the CompositeView class
		 * 
		 * @param compositeNode
		 * @private
		 */		
		internal function setParent(compositeNode:CompositeView):void
		{
			this._parentNode = compositeNode;
		}

		
		
		/**
		 * Removes the parent reference for a component/leaf
		 */		
		internal function removeParentRef():void
		{
			this._parentNode = null;
		}
		

		/**
		 * Overriden in the extended Composite class. Not overridden in an extended Component/Leaf Class.
		 * 
		 * @return Returns a composite object if extended class is indeed a composite. Returns null if extended
		 * class is a Component.
		 * 
		 * @private
		 */		
		internal function getComposite():CompositeView
		{
			return null;
		}
				
	}
}