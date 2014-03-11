package com.company.client.mvcproject.views
{
	import com.company.client.mvcproject.enums.ApplicationState;
	import com.company.client.mvcproject.events.CustomEvent;
	import com.company.client.mvcproject.model.IModel;
	import com.company.client.mvcproject.model.Page;
	import com.company.client.mvcproject.utils.ApplicationFonts;
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.easing.*;
	import com.patricksteele.utils.TextFieldUtils;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.text.TextField;
	
	/**
	 * The class defines a concrete Leaf Component view in the Composite Pattern
	 * 
	 * <p>Class is responsible for the display of ... ***THIS CLASS SHOULD ACT AS A TEMPLATE FOR ANY LEAF VIEW. TO
	 * CREATE A NEW VIEW COPY AND EDIT THIS CLASS***</p>
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 */
	public class LeafView extends ComponentView
	{
		/**
		 * if the view has been built yet
		 */		
		private var _ifBuilt:Boolean = false;
		
		/**
		 * If this view is currently active. ie. if it is currently on the display list (ie.added to root view and displayed on screen)
		 */		
		private var _isActive:Boolean = false;
		
		/**
		 * if the view's interactive elements such as buttons are currently enabled
		 */		
		private var _isEnabled:Boolean = false;
		
	
		

/***************************************************************************************
 * Variables below are the display objects that are added to this view to build its GUI
 * 
 ****************************************************************************************/
		
		/**
		 * page heading textfield 
		 */		
		private var _tfHeading:TextField;
		
		/**
		 * page content textfield 
		 */		
		private var _tfContent:TextField;
		

/*************************************************************************************
 * Variables below are unique to this view
 * 
 *************************************************************************************/

		
		/**
		 * CONSTRUCTOR
		 * 
		 * @param aModel Reference to Model in MVC Pattern
		 * @param aController Reference to Controller in MVC Pattern. (Default of <code>null</code> as not all component views need to handle user input)
		 */		
		public function LeafView(aModel:IModel, aController:Object = null)
		{
			super(aModel, aController);
			
			// call updateView() without any parameters to show the view in is default state
			//updateView();
		}


		
		/**
		 * Function updates this view based on changes in the Model
		 * 
		 * <p>As the this class is a Leaf Component View it does not have any children so 
		 * unlike a Composite Component View the overriden <code>updateView()</code> does not have to
		 * call it's superclass method.</p>
		 * 
		 * @param event Has a default of null allowing <code>updateView()</code> to be called without passing
		 * a CustomEvent parameter. This can be useful when initially drawing the user interface in its default state.
		 * 
		 * @see ComponentView#updateView()
		 * 
		 */		
		override public function updateView(event:CustomEvent = null):void
		{
			if(event != null)
			{
				switch(event.type)
				{
					// WHAT TO DO WHEN THE APPLCATION STARTS
					case CustomEvent.START_APPLICATION: 
						if(!_ifBuilt)
						{
							buildView(); // build view if not already built
						}
						refreshViewData(); // populates view with latest data from model
						showView(true); // add view to the display list
						break;
					
					
					// IF WE WANT TO MAKE SURE FLUID LAYOUT IS MAINTAINED FOR THIS VIEW WHEN STAGE RESIZES
					case CustomEvent.STAGE_RESIZED:
						if(_isActive)
						{
							positionAndSizeView(); // only need to do this if view is currently active (ie. currently added to display list)
						}
						break;
					
					
					// AN EXAMPLE OF WHAT TO DO IF WE WANT TO REFRESH THIS VIEW WITH NEW CONTENT
					case CustomEvent.PAGE_CHANGED:
						if(_isActive)
						{
							///////// WITH A TRANSITION eg. fade out and back in ///////////////
							
							enableView(false); // temporarily disable the view's interactive functionality
							
							// create a TimeLineLite object for sequencing our transitions
							var transitionTimeline:TimelineLite = new TimelineLite();
							
							// fade out this view. Once faded call refreshViewData() to refresh view with latest data from model
							transitionTimeline.append(new TweenLite(this, 0.2, {alpha:0, ease:Cubic.easeOut, onComplete:refreshViewData}));
							
							// fade this view back in and on complete re-enable the view's interactive functionality
							transitionTimeline.append(new TweenLite(this, 0.2, {alpha:1, ease:Cubic.easeOut, onComplete:enableView}));

							
							///////// OR WITHOUT A TRANSITION //////////////
							//refreshViewData(); // populates this view with latest data from model

						}
						break;
					
					
					
					// AN EXAMPLE OF WHAT TO DO WHEN WE NEED TO ADD OR REMOVE THE VIEW FROM THE DISPLAY LIST
					// DUE TO A CHANGE IN THE APPLICATIONS STATE
					case CustomEvent.STATE_CHANGED:						
						
						if(_model.getApplicationState() == ApplicationState.STATEA)
						{
							if(!_ifBuilt)
							{
								buildView(); // build view if not already built
							}
							refreshViewData(); // populates view with latest data from model
							showView(true); // add view to the display list
						}
						else
						{
							if(_isActive) // if this view is active ie. currently added to the display list
							{
								hideView(true); // remove view from the display list
							}
						}
						break;
					

					default:
						break;
				}
			}
		}
		
		
		/**
		 * Function builds the view's GUI.
		 * 
		 */		
		private function buildView():void
		{
			// build a textfield to display the page heading
			_tfHeading = TextFieldUtils.getStandardTextField(true, false, false, false, true, "left", "advanced");
			_tfHeading.defaultTextFormat = ApplicationFonts.getStandardTextFormat();
			addChild(_tfHeading);
			
			
			// build a textfield to display the page content
			_tfContent = TextFieldUtils.getStandardTextField(true, false, false, false, true, "left", "advanced");
			_tfContent.defaultTextFormat = ApplicationFonts.getStandardTextFormat();
			addChild(_tfContent);
								
			
			positionAndSizeView(); // make sure the view elements are correctly positioned
			
			// so view is initially invisible when added to display list
			this.visible = false;
			
			_ifBuilt = true;
		}
			
		
		
		
		
		/**
		 * Function sets the view's variable content with up-to-date data from the Model 
		 * 
		 */		
		private function refreshViewData():void
		{
			// get data from the model
			var currentPage:Page = _model.getPages()[_model.getCurrentPageIndex()];
			
			// need to reset defaultTextFormat due to some weird Flash bug
			_tfHeading.defaultTextFormat = ApplicationFonts.getStandardTextFormat();
			_tfHeading.htmlText = currentPage.getPageHeading();
			
			// need to reset defaultTextFormat due to some weird Flash bug
			_tfContent.defaultTextFormat = ApplicationFonts.getStandardTextFormat();
			_tfContent.htmlText = currentPage.getPageContent();
			
			
			positionAndSizeView(); // make sure the view elements are correctly positioned
		}
		
		
		/**
		 * Function positions and if necessary resizes the view's child display objects. Called initially when the view 
		 * is first built and also when its contents are updated.
		 * 
		 * <p>Useful for repositioning any display items in the view that may be affected when the view is updated
		 * with up-to-date data from the Model</p>
		 * 
		 * <p>This function is also used if we need to creat a fluid layout for our gui by altering positions and sizing 
		 * of the view and its children if the stage size has changed</p>
		 */		
		private function positionAndSizeView():void
		{
			_tfHeading.x = (_model.getSwfDimensions().x - _tfHeading.width)/2;
			_tfHeading.y = 180;
			
			_tfContent.x = (_model.getSwfDimensions().x - _tfContent.width)/2;
			_tfContent.y = _tfHeading.y + _tfHeading.height + 10;
			
		}
		
		
				
		/**
		 * Function shows this view by adding it to its root composite view and hence the display list.
		 * 
		 * @param useTransition	If a transition such as a fade should be used to make the view visible once
		 *  it has been added to the display list
		 * 
		 * @see RootCompositeView
		 */		
		private function showView(useTransition:Boolean = false):void
		{
			if(!_isActive)
			{
				_isActive = true;
				
				// add this view to the root composite view and hence the display list
				if(_parentNode != null)
				{
					if(_parentNode.contains(this) == false)
					{
						_parentNode.addChild(this);
					}
				}
			}
			
			if(useTransition) // transition the view in
			{
				this.alpha = 0;
				this.visible = true;
				
				// fade in view
				TweenLite.to(this, 0.4, {alpha:1, onComplete:enableView});
			}
			else // make view visible without a transition
			{
				this.alpha = 1;
				this.visible = true;
				enableView();
			}
		}
		
		
		/**
		 * Function enables or disables any user interactivity for this view 
		 * 
		 */		
		private function enableView(enable:Boolean = true):void
		{
			if(enable == true)
			{
				if(_isEnabled == false)
				{
					// add listeners if not already added
					
					_isEnabled = true;
				}
			}
			else
			{
				if(_isEnabled == true)
				{
					// remove listeners if present
					
					_isEnabled = false;
				}
			}
		}
		
				
		
		/**
		 * Function handles the hiding of this view
		 * 
		 * @param useTransition	If a transition such as a fade should be used to hide the view before it is removed
		 * from the display list 
		 * 
		 * @see RootCompositeView
		 */		
		private function hideView(useTransition:Boolean = false):void
		{
			enableView(false); // disable the view's interactive functionality
			
			_isActive = false;
			
			if(useTransition) // transition the view out
			{
				// fade out view
				TweenLite.to(this, 0.2, {alpha:0, ease:Cubic.easeOut, onComplete:cleanUpView});
			}
			else // hide view without a transition
			{
				cleanUpView();
			}
		}
				
		/**
		 * Function cleans up the view by removing it from its root composite view and hence the 
		 * display list.
		 */
		private function cleanUpView():void
		{
			this.visible = false;
			this.alpha = 1;
			
			// kill off any running tweens on this view
			TweenLite.killTweensOf(this);
			
						
			// remove this view from the root composite view and hence the display list
			if(_parentNode != null)
			{
				if(_parentNode.contains(this) == true)
				{
					_parentNode.removeChild(this);
				}
			}
			
			// if we want to unbuild the view - ie. if we probably won't need it again. 
			// If we'll need it again soon probably best not to do this
			//unbuildView();
		}
		
		
		
		/**
		 * Function unbuilds the view. Handy if we want to free up stuff for the garbage collector 
		 * 
		 */		
		private function unbuildView():void
		{
			_ifBuilt = false;
			
			/*
			// clear children of a displayObject called 'aSprite'
			while(aSprite.numChildren > 0) 
			{
				aSprite.removeChildAt(0);
			}
			*/
			
			/*
			// empty an array called arrExample
			while(arrExample.length > 0) 
			{
				arrExample.pop(); //remove the last item:
			}
			*/
			
			/*
			// clear graphics from a Sprite called 'aSprite'
			aSprite.graphics.clear();
			*/
			
			/*
			// clean memory
			removeChild(obj);
			obj = null;
			*/
			
			// if we wanted to completely remove this view from the root composite view and hence the Composite Pattern
			//_parentNode.remove(this);
		}
		
		

		
		
/*********************************************************************************************************
 * FUNCTIONS BELOW HANDLE ANY USER INTERACTION WITH AN INSTANCE OF THIS VIEW.
 * 
 * IF THE USER INTERACTION UPDATES THE MODEL THIS WILL USUALLY
 * BE DONE BY DELEGATING TO THIS VIEWS CONTROLLER - (STRATEGY PATTERN)
 *********************************************************************************************************/

		
		/**
		 * Function delegates to it's controller (Strategy Pattern) to handle user interaction.
		 * 
		 * @param event
		 */		
		private function userInputHandler(event:Event):void
		{
			_controller.userActionHandler(1);
		}

		
		
		
		
	
		
		
/*********************************************************************************************************
 * FUNCTIONS BELOW ARE HELPER FUNCTIONS
 *********************************************************************************************************/

		/**
		 * Function shows or hides a display object by fading using TweenLite 
		 * 
		 * @param displayObj The GUI element to be shown or hidden
		 * @param ifShow If the displayObj should be shown <code>true</code> or hidden <code>false</code>
		 * 
		 */		
		private function showViewItem(displayObj:DisplayObject, ifShow:Boolean):void
		{
			if(ifShow)
			{
				displayObj.visible = true;
				TweenLite.to(displayObj, 0.6, {alpha: 1, ease: Quint.easeOut});
			}
			else
			{
				TweenLite.to(displayObj, 0.6, {alpha: 0, ease: Quint.easeOut, onComplete: function():void{displayObj.visible = false;}});
			}
		}

		
	}
}