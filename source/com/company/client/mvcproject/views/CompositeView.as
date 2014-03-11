package com.company.client.mvcproject.views
{
	import com.company.client.mvcproject.events.CustomEvent;
	
	import flash.events.Event;
	
	 /**
	 * Represents a Composite Component (Component having children) in a Composite Pattern.
	 * 
	 * CompositeView is the abstract Composite class. It extends ComponentView (the abstract Component class) and
	 * overrides the methods that deal with handling child views. 
	 * 
	 * Defines the structure to hold references to child components (via an Array) and implements the methods that
	 * act on the child nodes. Child nodes/components can be Leaf Components or other Composite Components.
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 */	
	public class CompositeView extends ComponentView
	{
		/**
		 * Array that holds references to child nodes. Child nodes may be leafs Leaf Components or other Composite Components 
		 */
		private var _arrChildren:Array;
		
		/**
		 * CONSTRUCTOR
		 * @param aModel Reference to Model in MVC Pattern
		 * @param aController Reference to Controller in MVC Pattern. (Default of null as not all component views need to handle user input)
		 * 
		 */	
		public function CompositeView(aModel:Object = null, aController:Object=null)
		{
			super(aModel, aController);
			_arrChildren = new Array();
		}
		
		
		
		
		/**
		 * This method overrides the <code>updateView()</code> method in the ComponentView class and is the listener 
		 * function that intercepts update notifications from the Model that its current state has canged.
		 * 
		 * <p>Calls the <code>updateView()</code> method in all its children. So calling the <code>updateView()</code>
		 * method in the root node of the composite view structure will cascade down and transverse the component tree updating 
		 * all views.</p>
		 *  
		 * @param event Has a default of null allowing <code>updateView()</code> to be called without passing
		 * an Event parameter. This is useful when initially drawing the user interface in its default state.
		 * 
		 * @see ComponentView#updateView()
		 * 
		 */	
		override public function updateView(event:CustomEvent = null):void 
		{
			for each (var c:ComponentView in _arrChildren) 
			{
				// ensures updateView method call recursively tranverses all child nodes in the tree
				// structure of the Composite Pattern
				c.updateView(event); 
			}
		}
		
		

		
		
		/**
		 * This method overrides the <code>add()</code> method in the ComponentView class and allows a component to be 
		 * added to the composite node by adding a reference to the component to the _arrChildren Array.
		 * 
		 * @param c The component to be added to the composite structure
		 * 
		 * @see ComponentView#add()
		 */		
		override public function add(c:ComponentView):void 
		{
			_arrChildren.push(c);
			c.setParent(this);
		}
		
		
		/**
		 * Based on the passed ComponentView instance the <code>remove()</code> method has to deal with
		 * 2 scenarios.
		 * 
		 * <p>a) what to do when the component to delete is the current object.</p>
		 * 
		 * <p>b) what to do if it isnt. ie. the component to be removed is a child of the current object.</p>
		 * 
		 * @param c
		 * 
		 * @private
		 */		
		override public function remove(c:ComponentView):void
		{
			if(c === this)
			{
				// recursively remove all child components
				for(var i:int = 0; i < _arrChildren.length; i++)
				{
					safeRemove(_arrChildren[i]); // remove children
				}  // end for	
				this._arrChildren = []; // remove references to children
				this.removeParentRef(); // remove parent ref
				
			}
			else
			{
				// look for child to be removed
				for(var j:int = 0; j < _arrChildren.length; j++)
				{
					if(_arrChildren[j] == c)
					{
						safeRemove(_arrChildren[j]); // remove child
						_arrChildren.splice(j,1); // remove reference
					}
				} // end for		
			} // end if/else
		}
		
		
		
		
		/**
		 * This function overrides the <code>getChild()</code> method in the ComponentView class and allows 
		 * access to the children of the composite node.
		 * 
		 * @param n Position of child object to be returned.
		 * 
		 * @return Returns child object by the position indicated by the parameter n or <code>null</code> if no children exist.
		 *  
		 * @see ComponentView#getChild()
		 */	
		override public function getChild(n:int):ComponentView
		{
			if((n > 0) && (n < _arrChildren.length))
			{
				return _arrChildren[n-1];						
			}
			else
			{
				return null;
			}
		}
		


		/**
		 * Returns this Composite View
		 * 
		 * @return CompositeView
		 *
		 * @see ComponentView#getComposite()
		 */		
		override internal function getComposite():CompositeView
		{
			return this;
		}
		

		

		/**
		 * Function safely removes child components. Checks to see if passed component is a composite and 
		 * if so calls its remove method. If the passed component is not a composite (it's a leaf node), 
		 * it removes its parent reference
		 * 
		 * @param c
		 * 
		 * @private
		 */		
		private function safeRemove(c:ComponentView):void
		{
			if(c.getComposite())
			{
				c.remove(c); // composite
			}
			else
			{
				c.removeParentRef();
			}
		}
		
		
	}
}