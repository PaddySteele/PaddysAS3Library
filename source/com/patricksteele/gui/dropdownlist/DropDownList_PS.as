package com.patricksteele.gui.dropdownlist
{
	import com.greensock.TweenLite;
	import com.patricksteele.gui.scrollbar.ScrollBar_PS;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * Class defines a custom drop down list (combobox) object. Comprised of a header element and button and a collection of drop down 
	 * elements.
	 * 
	 * <p>Uses mcDdlHeaderElement_PS, mcDdlBtn_PS and mcDdlElement_PS which are linked MovieClips in the Fla Library. The ddl can
	 * be skinned by editing these linked MC's.</p>
	 * 
	 * <p>Uses a ScrollBar_PS object for scrolling the ddl elements when it is expanded should there be a large amount of ddl elements (ie.options).</p>
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 * @example The following example creates and sets up a ddl with 4 elements 
	 * <listing version="3.0">
	 * 	package 
	 * 	{ 
	 * 		import com.patricksteele.gui.dropdownlist.DropDownList_PS;
	 * 		import flash.display.Sprite;	
	 * 		import flash.text.TextFormat;
	 * 
	 * 		public class DdlExample extends Sprite 
	 * 		{ 
	 * 			private var _ddl:DropDownList_PS;
	 * 			private var _myTextFormat:TextFormat;
	 * 
	 * 			public function DdlExample()
	 * 			{
	 * 				// set up TextFormat
	 * 				public static var _font:Font = new EmbeddedFont(); // linked from fla library
	 *				public static var _myTextFormat:TextFormat = new TextFormat();
	 * 				_myTextFormat.font = _font.fontName;
	 * 				_myTextFormat.size = 12;
	 * 				_myTextFormat.align = TextFormatAlign.LEFT;
	 * 
	 * 				// create ddl				
	 * 				_ddl = new DropDownList_PS("Band names", _myTextFormat, true);
	 * 				_ddl.setTextCols(0x000000, 0xFFFFFF, 0XFFFFFF);
	 * 				addChild(_ddl);
	 * 
	 * 				// add elements to ddl 
	 * 				_ddl.addElement("Stone Roses", 1, 0xCC3366, 0X000000, 0xFFFFFF, 0xCC3366);
	 * 				_ddl.addElement("New Order", 2);
	 * 				_ddl.addElement("The La's", 3);
	 * 				_ddl.addElement("The Smiths", 4);
	 * 				
	 * 				_ddl.activate(true); // activate mouse behaviours for ddl
	 * 				_ddl.setCurrentElementByValue(3); // initially set value to 'The La's'
	 * 
	 * 				// add listener to listen for changes
	 * 				_ddl.addEventListener(DropDownList_PS.DDL_CHANGED, ddlChanged_handler, false, 0, true);
	 * 			}
	 * 
	 *			private function ddlChanged_handler(event:MouseEvent):void
	 * 			{
	 * 				 // DO SOMETHING !!    
	 * 			}
	 * 
	 * 		}
	 *	}
	 * </listing> 
	 */	
	public class DropDownList_PS extends Sprite
	{
		/**
		 * A name for this ddl. Will be displayed initially if no element is initially selected 
		 */		
		private var _ddlName:String;
		
		/**
		 * Linked mc from Fla Library that acts as the header cell for the drop down list. The linked mc has mouse over, off and down states 
		 */		
		private var _ddlHeaderElement:mcDdlHeaderElement_PS;
		
		/**
		 * Linked mc from Fla Library that acts as the expand button for the drop down list. The linked mc has mouse over, off and down states 
		 */	
		private var _ddlExpandBtn:mcDdlBtn_PS;
		
		/**
		 * An array to hold the elements in the drop down list. Elements are defined in the DdlElement_PS class
		 * which uses the linked mcDdlElement_PS mc from the fla library
		 */		
		private var _arrDdlElements:Array;
		
		/**
		 * The index of the ddl's currently selected element with respect to the _arrDdlElements Array
		 */		
		private var _selectedElementIndex:Number = -1;
		
		/**
		 * Sprite that contains all the display objects that are to be shown when the ddl is expanded. Includes _ddlElementContainer which
		 * will contain a DdlElement_PS for each ddl option. Also contains a scrollbar (ScrollBar_PS) for scrolling _ddlElementContainer
		 * if there are alot of ddl elements.
		 */		
		private var _expandedDdlContents:Sprite;
		
		/**
		 * Sprite to be used as a mask for showing and hiding the drop down elements contained in _ddlElementContainer
		 * when the ddl is expanded
		 */		
		private var _expandDdlMASK:Sprite;
		
		/**
		 * A sprite to hold all the drop down elements (ie. DdlElement_PS objects) in the ddl 
		 */		
		private var _ddlElementContainer:Sprite;
		
		/**
		 * The maximum number of elements that can be visible before an expanded drop down list requires a scroll bar.
		 */		
		private var _maxVisibleElements:Number = 4;
		
		/**
		 * When the ddl is expanded this mask is used when scrolling _ddlElementContainer if it contains more
		 * elements than _maxVisibleElements
		 */		
		private var _ddlElementsMASK:Sprite;
		
		/**
		 * When the ddl is expanded this scrollbar is used to scroll _ddlElementContainer if it contains more elements
		 * than _maxVisibleElements
		 */		
		private var _ddlElementsScrollBar:ScrollBar_PS;
		
		/**
		 * TextFormat for the text in the ddl's header element drop down elements 
		 */		
		private var _ddlTxtFormat:TextFormat;
		
		/**
		 * If the font from the _ddlTxtFormat should be embedded in TextFields
		 */		
		private var _ifEmbedFont:Boolean = true;
		
		/**
		 * TextField to display the label of the ddl's currently selected option element 
		 */		
		private var _tfHeading:TextField;
		
		/**
		 * Text colours for different states 
		 */		
		private var _txtColOff:uint = 0x000000;
		private var _txtColOver:uint = 0x000000;
		private var _txtColDown:uint = 0x000000;
		
		/**
		 * Padding between _tfHeading edges and the header elemnts edges
		 */		
		private var _txtPaddingTop:Number = 2;
		private var _txtPaddingBottom:Number = 2;
		private var _txtPaddingLeft:Number = 4;
		private var _txtPaddingRight:Number = 4;
		
		/**
		 * Width of the Drop Down List 
		 */		
		private var _ddlWidth:Number;
		
		/**
		 * The time it takes in msecs to expand the ddl's drop down elements 
		 */		
		private var _expandDdlTime:Number = 0.2;
		
		/**
		 * if the ddl is currently expanded showing all its drop down elements 
		 */		
		private var _ifExpanded:Boolean = false;
		
		/**
		 * If the ddl is currently active 
		 */		
		private var _active:Boolean = false;
		
		/**
		 * colors for the scrollbar if one is in use by the ddl 
		 */		
		private var _sbTrackCol:uint = 0xFFFFFF;
		private var _sbThumbDefaultCol:uint = 0x000000;
		private var _sbThumbOverCol:uint = 0x000000;
		private var _sbThumbDownCol:uint = 0x000000;
		private var _sbBtnDefaultCol:uint = 0x000000;
		private var _sbBtnOverCol:uint = 0x000000;
		private var _sbBtnDownCol:uint = 0x000000;			
		private var _sbBtnArrowCol:uint = 0xFFFFFF;
		
		
		/**
		 * used for dispatching a custom event to alert that the ddl's currently selected element has changed 
		 */		
		public static const DDL_CHANGED:String = "ddlchanged";
		
		/**
		 * Constructor
		 *  
		 * @param ddlName				Name for the ddl. Displayed in the header element if no child element currently selected
		 * @param txtFormat				TextFormat for the text used in the ddl elements
		 * @param ifEmbedFont			If the font from the above TextFormat should be embedded
		 * @param maxVisibleElements 	Maximum number of elements that can be visible before an expanded drop down list requires a scroll bar
		 */		
		public function DropDownList_PS(ddlName:String, txtFormat:TextFormat, ifEmbedFont:Boolean = true, maxVisibleElements:Number = 4)
		{
			super();
			
			_ddlName = ddlName;			
			_ddlTxtFormat = txtFormat;
			_ifEmbedFont = ifEmbedFont;
			_maxVisibleElements = maxVisibleElements;
			
			// init array
			_arrDdlElements = new Array();
			
			// create and add ddl header element
			_ddlHeaderElement = new mcDdlHeaderElement_PS();
			_ddlHeaderElement.mouseChildren = false;
			addChild(_ddlHeaderElement);
			
			// label for the header element. Will display the label of the currently selected element in the 
			// ddl OR _ddlName if no element is currently selected
			_tfHeading = new TextField();
			_tfHeading.selectable = false;			
			_tfHeading.multiline = false;
			_tfHeading.wordWrap = false;
			_tfHeading.border = false;
			_tfHeading.embedFonts = _ifEmbedFont;			
			_tfHeading.autoSize = TextFieldAutoSize.LEFT;
			_tfHeading.antiAliasType = AntiAliasType.ADVANCED;
			_tfHeading.defaultTextFormat = _ddlTxtFormat;
			_tfHeading.text = _ddlName;
			_tfHeading.textColor = _txtColOff;
			_tfHeading.mouseEnabled = false;
			addChild(_tfHeading);
			
			// create and add ddl expand btn
			_ddlExpandBtn = new mcDdlBtn_PS();
			_ddlExpandBtn.mouseChildren = false;		
			addChild(_ddlExpandBtn);
			
			// set initial sizing and positioning for header element
			_ddlWidth = _txtPaddingLeft + _tfHeading.width + _txtPaddingRight + _ddlExpandBtn.width;
			var headerHeight:Number = _txtPaddingTop + _tfHeading.height + _txtPaddingBottom;
			_ddlHeaderElement.width = _ddlWidth;
			_ddlHeaderElement.height = headerHeight;
			_tfHeading.x = _txtPaddingLeft; 
			_tfHeading.y = _txtPaddingTop;
			
			// set initial sizing and positioning for expand btn
			_ddlExpandBtn.height = headerHeight;
			_ddlExpandBtn.x = _ddlWidth - _ddlExpandBtn.width; 
			_ddlExpandBtn.y = 0;
			
			
			// create Sprite that will hold all contents to be displayed when the ddl is expanded
			_expandedDdlContents = new Sprite();
			addChild(_expandedDdlContents);
			_expandedDdlContents.x = 0; 
			_expandedDdlContents.y = headerHeight;
			
			
			// create and add container that will hold the ddl's drop down elements (ie. DdlElement_PS objects)
			_ddlElementContainer = new Sprite();
			_expandedDdlContents.addChild(_ddlElementContainer);
			
			// set up masking for the ddl elements in _ddlElementContainer - this will be resized as new elements are added. @see addElement
			_ddlElementsMASK = new Sprite();			
			_ddlElementsMASK.graphics.lineStyle();
			_ddlElementsMASK.graphics.beginFill(0x000000);
			_ddlElementsMASK.graphics.drawRect(0, 0, _ddlWidth, 10);
			_ddlElementsMASK.graphics.endFill();
			_expandedDdlContents.addChild(_ddlElementsMASK);
			_ddlElementsMASK.y = _ddlElementContainer.y;
			_ddlElementContainer.mask = _ddlElementsMASK;			
			_ddlElementsMASK.height = _ddlElementContainer.height;
			
			
			// set up masking for the content that is displayed when the ddl is expanded - this will include athe elements in _ddlElementContainer
			// as well as a scrollbar if one is being used - this will be resized so it is allways the same size as _ddlElementsMASK. @see addElement
			_expandDdlMASK = new Sprite();			
			_expandDdlMASK.graphics.lineStyle();
			_expandDdlMASK.graphics.beginFill(0x000000);
			_expandDdlMASK.graphics.drawRect(0, 0, _ddlWidth, 10);
			_expandDdlMASK.graphics.endFill();
			addChild(_expandDdlMASK);
			_expandDdlMASK.x = -2;
			_expandDdlMASK.y = _expandedDdlContents.y;
			_expandedDdlContents.mask = _expandDdlMASK;			
			_expandDdlMASK.height = 0;
		}
		
		
		/**
		 * Function sets the text colours for the labels for different states 
		 * 
		 * @param colOff
		 * @param colOver
		 * @param colDown
		 */		
		public function setTextCols(colOff:uint, colOver:uint, colDown:uint):void
		{
			_txtColOff = colOff;
			_txtColOver = colOver;
			_txtColDown = colDown;
			
			_tfHeading.textColor = _txtColOff;
		}
		
		
		/**
		 * Function sets the colours for the scrollbar if this ddl is to use one - ie when there are alot of elements in the expanded ddl 
		 * 
		 * @param trackCol
		 * @param thumbDefaultCol
		 * @param thumbOverCol
		 * @param thumbDownCol
		 * @param btnDefaultCol
		 * @param btnOverCol
		 * @param btnDownCol
		 * @param btnArrowCol
		 * 
		 */		
		public function setScrollBarCols(trackCol:uint, thumbDefaultCol:uint, thumbOverCol:uint, thumbDownCol:uint, btnDefaultCol:uint, btnOverCol:uint, btnDownCol:uint, btnArrowCol:uint):void
		{
			_sbTrackCol = trackCol;
			_sbThumbDefaultCol = thumbDefaultCol;
			_sbThumbOverCol = thumbOverCol;
			_sbThumbDownCol = thumbDownCol;
			_sbBtnDefaultCol = btnDefaultCol;
			_sbBtnOverCol = btnOverCol;
			_sbBtnDownCol = btnDownCol; 
			_sbBtnArrowCol = btnArrowCol;
		}
		
		
		/**
		 * Function adds a new child element to the ddl. A chld element is represented by a DdlElement_PS object.
		 *  
		 * @param label
		 * @param value
		 * @param txtColOff
		 * @param txtColOver
		 * @param txtColDown
		 * @param txtColSelected
		 * 
		 */		
		public function addElement(label:String, value:Number, txtColOff:uint = 0x000000, txtColOver:uint = 0x000000, txtColDown:uint = 0x000000, txtColSelected:uint = 0x000000):void
		{
			// create a new element
			var element:DdlElement_PS = new DdlElement_PS(label, value, _ddlTxtFormat, _ifEmbedFont, txtColOff, txtColOver, txtColDown, txtColSelected);
			_arrDdlElements.push(element);
			
			// add new element
			var ypos:Number = Math.floor(_ddlElementContainer.height);
			_ddlElementContainer.addChild(element);
			element.x = 0;
			element.y = ypos;
			
			// acitvate the newly added element if the ddl is already activated
			if(_active)
			{
				element.activate(true);
				element.addEventListener(MouseEvent.MOUSE_UP, elementSelected_handler, false, 0, true);
			}
			
			
			// adjust ddl element mask height if needed and if required set up scroll bar
			if(_arrDdlElements.length <= _maxVisibleElements)
			{
				_ddlElementsMASK.height = _ddlElementContainer.height;
			}
			else
			{
				// create scroll bar
				if(_arrDdlElements.length == _maxVisibleElements + 1)
				{
					_ddlElementsScrollBar = new ScrollBar_PS(_ddlElementContainer, _ddlElementsMASK, true, _ddlExpandBtn.width, _ddlExpandBtn.width, true, _ddlExpandBtn.width);
					_expandedDdlContents.addChild(_ddlElementsScrollBar);
					_ddlElementsScrollBar.styleTrack(_sbTrackCol);
					_ddlElementsScrollBar.styleArrowBtnsOffState({color:_sbBtnDefaultCol}, {color:0x000000, thickness:1}, 0, _sbBtnArrowCol);
					_ddlElementsScrollBar.styleArrowBtnsOverState({color:_sbBtnOverCol}, {color:0x000000, thickness:1}, 0, _sbBtnArrowCol);
					_ddlElementsScrollBar.styleArrowBtnsDownState({color:_sbBtnDownCol}, {color:0x000000, thickness:1}, 0, _sbBtnArrowCol);
					_ddlElementsScrollBar.styleThumbOffState({color:_sbThumbDefaultCol}, {color:0x000000, thickness:1});
					_ddlElementsScrollBar.styleThumbOverState({color:_sbThumbOverCol}, {color:0x000000, thickness:1});
					_ddlElementsScrollBar.styleThumbDownState({color:_sbThumbDownCol}, {color:0x000000, thickness:1});
					_ddlElementsScrollBar.x = _ddlElementsMASK.x + _ddlElementsMASK.width - _ddlElementsScrollBar.width;
					_ddlElementsScrollBar.y = _ddlElementsMASK.y;
				}
				
				if(_ddlElementsScrollBar != null)
				{
					_ddlElementsScrollBar.refresh();
				}
				
			}

			
			// if newly added element is wider than current ddl store new width and then adjust size of all ddl elements		
			var newDdlWidth:Number = element.width;			
			if(newDdlWidth > _ddlWidth - _ddlExpandBtn.width)
			{
				_ddlWidth = newDdlWidth + _ddlExpandBtn.width;
			}
			
			adjustDdlWidth();

		}
		
	
		/**
		 * Function adjusts the width of the ddl's header element and drop down elements making sure they are all
		 * the width as the currently widest element. 
		 * 
		 */		
		private function adjustDdlWidth():void
		{
			// adjust header element width and position
			_ddlHeaderElement.width = _ddlWidth;
			_ddlHeaderElement.width = _ddlWidth;
			_ddlExpandBtn.x =  _ddlWidth - _ddlExpandBtn.width;
			
			// make sure all drop down elements are correct width
			for(var i:Number = 0; i < _arrDdlElements.length; i++)
			{
				_arrDdlElements[i].adjustWidth(_ddlWidth);
			}
			
			// adjust widths of the masks used by the ddl			
			_ddlElementsMASK.width = _ddlWidth;
			_expandDdlMASK.width = _ddlWidth + 2;
			
			// make sure scroll bar is correctly positioned if one is being used
			if(_ddlElementsScrollBar != null)
			{
				_ddlElementsScrollBar.x = _ddlWidth - _ddlElementsScrollBar.width;
			}
			
		}
		
		
		
		/**
		 * Function activates/deactivates the mouse over, off and down interactivity for the ddl's header element and button.
		 * 
		 * <p>Also activates/deactivates the drop down elements to detect when a user clicks on them</p>
		 * 
		 * @param active
		 */		
		public function activate(active:Boolean):void
		{
			if(active)
			{
				if(!_active)
				{
					_ddlHeaderElement.addEventListener(MouseEvent.MOUSE_OVER, mouseOver_handler, false, 0, true);
					_ddlHeaderElement.addEventListener(MouseEvent.MOUSE_OUT, mouseOut_handler, false, 0, true);
					_ddlHeaderElement.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown_handler, false, 0, true);
					_ddlExpandBtn.addEventListener(MouseEvent.MOUSE_OVER, mouseOver_handler, false, 0, true);
					_ddlExpandBtn.addEventListener(MouseEvent.MOUSE_OUT, mouseOut_handler, false, 0, true);
					_ddlExpandBtn.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown_handler, false, 0, true);
					
					for(var i:Number = 0; i < _arrDdlElements.length; i++)
					{
						_arrDdlElements[i].activate(true);
						_arrDdlElements[i].addEventListener(MouseEvent.MOUSE_UP, elementSelected_handler, false, 0, true);
						
					}
				}
			}
			else
			{
				if(_active)
				{
					_ddlHeaderElement.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver_handler);
					_ddlHeaderElement.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut_handler);
					_ddlHeaderElement.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown_handler);
					_ddlExpandBtn.removeEventListener(MouseEvent.MOUSE_OVER, mouseOver_handler);
					_ddlExpandBtn.removeEventListener(MouseEvent.MOUSE_OUT, mouseOut_handler);
					_ddlExpandBtn.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDown_handler);
					
					for(var j:Number = 0; j < _arrDdlElements.length; j++)
					{
						_arrDdlElements[j].activate(false);
						_arrDdlElements[j].removeEventListener(MouseEvent.MOUSE_UP, elementSelected_handler);
					}
				}
			}
			
			_active = active;			
		}
		

		
		/**
		 * Function handles what happens when mouse moves over the ddls header element or button
		 * 
		 * @param event
		 */		
		private function mouseOver_handler(event:MouseEvent):void
		{
			_ddlHeaderElement.gotoAndStop("over");
			_ddlExpandBtn.gotoAndStop("over");
			_tfHeading.textColor = _txtColOver;			
		}
		
		/**
		 * Function handles what happens when mouse moves off the ddls header element or button
		 * 
		 * @param event
		 */	
		private function mouseOut_handler(event:MouseEvent):void
		{
			_ddlHeaderElement.gotoAndStop("off");
			_ddlExpandBtn.gotoAndStop("off");
			_tfHeading.textColor = _txtColOff;			
		}
		
		/**
		 * Function handles what happens when mouse presses down on the ddls header element or button
		 * 
		 * @param event
		 */	
		private function mouseDown_handler(event:MouseEvent):void
		{
			_ddlHeaderElement.gotoAndStop("down");
			_ddlExpandBtn.gotoAndStop("down");			
			_tfHeading.textColor = _txtColDown;
			
			if(!_ifExpanded)
			{
				
				expandDropDownElements(true); // show drop down elements
			}
			else
			{
				expandDropDownElements(false); // hide drop down elements
			}
		}
		
		
		/**
		 * Functionhandles what happens when a user selects one of the drop down elemnts by clicking on it. If the selected
		 * element is different to the previously selected element an event is dispatched.
		 *  
		 * @param event
		 * 
		 */		
		private function elementSelected_handler(event:MouseEvent):void
		{
			var targetElement:Number;
			
			for(var i:Number = 0; i < _arrDdlElements.length; i++)
			{
				if(_arrDdlElements[i] == event.target)
				{
					targetElement = i;
					_tfHeading.text = _arrDdlElements[i].getLabel();
					_arrDdlElements[i].setSelected(true);
				}
				else
				{
					_arrDdlElements[i].setSelected(false);
				}
			}
			
			if(_selectedElementIndex != targetElement)
			{
				_selectedElementIndex = targetElement;
				
				var ddlChangedEvent:Event = new Event(DropDownList_PS.DDL_CHANGED);
				dispatchEvent(ddlChangedEvent);
			}
			
		
			expandDropDownElements(false);
			
		}
		
		
		/**
		 * Function sets the current element the the elemnt in the specfied index of _arrDdlElements
		 * 
		 * @param index
		 */		
		public function setCurrentElementByIndex(index:Number):void
		{
			if(index < _arrDdlElements.length && index > -1)
			{
				for(var i:Number = 0; i < _arrDdlElements.length; i++)
				{
					if(i == index)
					{
						_tfHeading.text = _arrDdlElements[i].getLabel();
						_arrDdlElements[i].setSelected(true);
						_selectedElementIndex = i;
					}
					else
					{
						_arrDdlElements[i].setSelected(false);
					}
				}
			}
		}
		
		
		/**
		 * Function sets the current element the the elemnt with the specified value
		 * 
		 * @param index
		 */	
		public function setCurrentElementByValue(val:Object):void
		{
			for(var i:Number = 0; i < _arrDdlElements.length; i++)
			{
				if(_arrDdlElements[i].getValue() == val)
				{
					_tfHeading.text = _arrDdlElements[i].getLabel();
					_arrDdlElements[i].setSelected(true);
					_selectedElementIndex = i;
				}
				else
				{
					_arrDdlElements[i].setSelected(false);
				}
			}
		}
		
		
		
		/**
		 * Function expands or hides the ddl's drop down elements 
		 * @param show
		 * 
		 */		
		private function expandDropDownElements(show:Boolean):void
		{
			if(show)
			{
				TweenLite.to(_expandDdlMASK, _expandDdlTime, {height:_ddlElementsMASK.height});
			}
			else
			{
				TweenLite.to(_expandDdlMASK, _expandDdlTime/2, {height:0});
			}
			
			_ifExpanded = show;
			
			if(_ifExpanded) // if expanded listen for clicks outside ddl so we can close it
			{
				if(this.stage != null) // can only add this behaviour if ddl has been added to the stage!!!!
				{
					stage.addEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler, false, 0, true);
				}				
			}
			else
			{
				if(this.stage != null)
				{				
					stage.removeEventListener(MouseEvent.MOUSE_DOWN, stage_mouseDownHandler);
				}
			}
		}
		
		
		/**
		 * Function is called if user presses mouse down on the stage when the ddl is expanded.  
		 * Checks if outside of the ddl and if so causes the ddl to retract.
		 *  
		 * @param event
		 */		
		private function stage_mouseDownHandler(event:MouseEvent = null):void
		{
			var clickedOutside:Boolean = true;

			if(event.target == _ddlHeaderElement)
			{
				clickedOutside = false;
			}
			
			if(event.target == _ddlExpandBtn)
			{
				clickedOutside = false;
			}
			
			if(_ddlElementsScrollBar != null)
			{
				if(event.target.parent == _ddlElementsScrollBar)
				{
					clickedOutside = false;
				}
			}
			
			
			for(var i:Number = 0; i < _arrDdlElements.length; i++)
			{
				if(event.target == _arrDdlElements[i])
				{
					clickedOutside = false;
				}
			}
			
			// if mouse pressed down outside of stage close ddl
			if(clickedOutside) 
			{
				expandDropDownElements(false);
			}
		}
		
		
		
		/**
		 * Function returns the value of the currently selected element 
		 * 
		 * @return 
		 */		
		public function getCurrentValue():Object
		{
			if(_selectedElementIndex > -1)
			{
				return _arrDdlElements[_selectedElementIndex].getValue();
			}
			else
			{
				return null;
			}
		}
		
		
		/**
		 * Function returns the label of the currently selected element 
		 * 
		 * @return 
		 */		
		public function getCurrentLabel():String
		{
			if(_selectedElementIndex > -1)
			{
				return _arrDdlElements[_selectedElementIndex].getLabel();
			}
			else
			{
				return "";
			}
		}
		
		
		
		
	}
}