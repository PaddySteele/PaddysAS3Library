package com.patricksteele.gui
{
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * Class defines a data row for displaying information. A collection of DataRows can then be used to construct a data list/data grid like table. 
	 * 
	 * <p>Once the DataRow is created data items can be added to it for display. Data items can be textual or graphical (ie. anything
	 * of type: DisplayObject).</p>
	 * 
	 * <p>The DataRow can be styled for 3 different state - default(ie. mouse off), mouse over and selected.</p>
	 * 
	 * @author Patrick Steele (http://www.patricksteele.com)
	 * 
	 * @example The following example creates a data list with a header data row and 2 normal data rows all with 2 columns each
	 * <listing version="3.0">
	 * 	package 
	 * 	{ 
	 * 		import com.patricksteele.gui.DataRow;	
	 * 		import flash.display.Sprite;	
	 * 		import flash.events.MouseEvent;
	 * 		import flash.text.Font;
	 * 		import flash.text.TextFormat;
	 * 		import flash.text.TextFormatAlign; 
	 * 
	 * 		public class DataRowExample extends Sprite 
	 * 		{
	 * 			public function DataRowExample()
	 * 			{
	 * 				// set up a TextFormat
	 * 				var _font:Font = new VerdanaFont();//EmbeddedFont(); // linked from fla library
	 * 				var _myTextFormat:TextFormat = new TextFormat();
	 * 				_myTextFormat.font = _font.fontName;
	 * 				_myTextFormat.size = 12;
	 * 				_myTextFormat.align = TextFormatAlign.LEFT;
	 * 
	 * 				// CREATE A HEADER DATA ROW WITH A BLACK BACKGROUND AND WHITE TEXT
	 * 				var headerRow:DataRow = new DataRow(0, 400, 25, 0x000000, 0xFFFFFF, _myTextFormat);			
	 * 				headerRow.addDataItem("Name", 150, "left"); // add text data item to the header data row **need to make sure 2nd parameter is wide enough for the text (1st parameter)
	 * 				headerRow.addDataItem("Band", 150, "left");	// add text data item to the header data row
	 * 				addChild(headerRow); // add the header data row for display on screen
	 * 
	 *				var arrDataRows:Array = new Array();// array to hold ref to data rows in data list
	 * 
	 * 				// CREATE MORE DATA ROWS TO BUILD UP A DATA LIST
	 * 				var datarowA:DataRow = new DataRow(1, 400, 25, 0xCCCCCC, 0x000000, _myTextFormat);
	 * 				datarowA.setOverStyle(0x999999, 0xFFFFFF);
	 * 				datarowA.setSelectedStyle(0x666666, 0xFFFFFF);
	 * 				datarowA.addDataItem("Ian Brown", 150, "left");
	 * 				datarowA.addDataItem("Stone Roses", 150, "left");
	 * 				arrDataRows.push(datarowA);
	 * 
	 * 				var datarowB:DataRow = new DataRow(1, 400, 25, 0xCCCCCC, 0x000000, _myTextFormat);
	 * 				datarowB.setOverStyle(0x999999, 0xFFFFFF);
	 * 				datarowB.setSelectedStyle(0x666666, 0xFFFFFF);
	 * 				datarowB.addDataItem("Shaun Ryder", 150, "left");
	 * 				datarowB.addDataItem("Happy Mondays", 150, "left");
	 * 				arrDataRows.push(datarowB);
	 * 
	 * 				// ADD, POSITION AND ACTIVATE MOUSE BEHAVIOURS FOR THE DATA ROWS
	 * 				var yPos:Number = headerRow.y + headerRow.height;
	 * 				for(var i:Number = 0; i < arrDataRows.length; i++)
	 * 				{
	 * 					arrDataRows[i].y = yPos// set data row y pos
	 * 					yPos = yPos + arrDataRows[i].height;
	 * 					addChild(arrDataRows[i]);
	 * 
	 * 					// add eventlisteners to detect mouse roll on, off and click for the data rows
	 * 					arrDataRows[i].addEventListener(MouseEvent.MOUSE_OVER, dataRow_mouseOverHandler, false, 0, true);
	 * 					arrDataRows[i].addEventListener(MouseEvent.MOUSE_OUT, dataRow_mouseOutHandler, false, 0, true);
	 * 					arrDataRows[i].addEventListener(MouseEvent.CLICK, dataRow_clickHandler, false, 0, true);
	 * 				}
	 * 			}
	 * 
	 * 			private function dataRow_mouseOverHandler(event:MouseEvent):void
	 * 			{
	 *				var datarow:DataRow = DataRow(event.target);// get target data row
	 * 
	 * 				// only change state if not selected. As we dont want rollover to be active if data row is in selected state
	 * 				if(datarow.getState() != DataRow.SELECTED)
	 * 				{
	 * 					DataRow(event.target).setRowState(DataRow.OVER);
	 * 				}
	 * 			} 
	 * 
	 * 			private function dataRow_mouseOutHandler(event:MouseEvent):void
	 * 			{
	 *				var datarow:DataRow = DataRow(event.target);// get target data row
	 * 
	 * 				// only change state if not selected. As we dont want rolloff to be active if data row is in selected state
	 * 				if(datarow.getState() != DataRow.SELECTED)
	 * 				{
	 * 					DataRow(event.target).setRowState(DataRow.DEFAULT);
	 * 				}
	 * 			} 
	 *  
	 * 			private function dataRow_clickHandler(event:MouseEvent):void
	 * 			{
	 * 				var datarow:DataRow = DataRow(event.target);// get target data row
	 * 
	 * 				if(datarow.getState() != DataRow.SELECTED) // if not selected select
	 * 				{
	 * 					DataRow(event.target).setRowState(DataRow.SELECTED);
	 * 				}
	 * 				else  // if already selected de-select
	 * 				{
	 * 					DataRow(event.target).setRowState(DataRow.DEFAULT);
	 * 				}
	 * 			}
	 * 		}
	 * }
	 * </listing>
	 * 
	 */	
	public class DataRow extends Sprite
	{
		/**
		 * an unique id for this data row.
		 */		
		private var _dataRowID:Number;
		
		/**
		 * an Array to hold all the data items to be displayed on the data row. Data items can be textfields or graphical items 
		 */		
		private var _arrDataItems:Array;
		
		/**
		 * the data rows background
		 */		
		private var _dataRowBg:Sprite;
		
		/**
		 * the dimensions of the data row
		 */		
		private var _dataRowWidth:Number;
		private var _dataRowHeight:Number;
		
		/**
		 * left and right padding of any data items from the edges of the data row 
		 */		
		private var _dataRowPadding:Number = 5;
		
		/**
		 * constants for specifing the different states for a data row 
		 */		
		public static const DEFAULT:String = "default";
		public static const OVER:String = "over"; 
		public static const SELECTED:String = "selected";
		
		/**
		 * the current state of the data row 
		 */			
		private var _currentState:String = DEFAULT;
		
		/**
		 * the colours used for the data rows background when the data row is in its different states
		 */		
		private var _dataRowBgColDefault:uint;
		private var _dataRowBgColOver:uint;
		private var _dataRowBgColSelected:uint;
		
		/**
		 * the text colours used for any text based data items on the data row when the data row is in its different states 
		 */		
		private var _dataItemTxtColDefault:uint;
		private var _dataItemTxtColOver:uint;
		private var _dataItemTxtColSelected:uint;
		
		/**
		 * a TextFormat for formatting the text in any text based data items added to the data row 
		 */		
		private var _dataRowTxtFormat:TextFormat;	
		
		/**
		 * speed at which colour tints will be performed on mouse on, off and click 
		 */		
		private var _transitionSpeed:Number = 0.1;
		
		
		/**
		 * Constructor
		 * 
		 * @param id			An unique id for this data row
		 * @param rowWidth		Width of the data row
		 * @param rowHeight		Height of the data row
		 * @param rowBgCol		Default bg colour
		 * @param rowTxtCol		Default Text Colour
		 * @param txtFormat		Text format for formatting any textual data items
		 * @param rowLRPadding
		 * 
		 */		
		public function DataRow(id:Number, rowWidth:Number, rowHeight:Number, rowBgCol:uint, rowTxtCol:uint, txtFormat:TextFormat, rowLRPadding:Number = 5)
		{
			super();
			
			// data row id
			_dataRowID = id;
			
			// data row dimensions
			_dataRowWidth = rowWidth;
			_dataRowHeight = rowHeight;
			_dataRowPadding = rowLRPadding;
			
			// set default datarow bg colour.
			_dataRowBgColDefault = rowBgCol;
			
			// set the default data item text colour
			_dataItemTxtColDefault = rowTxtCol;
			
			// Initially the over and selected colours will be the same as the default colours.
			// To change these see the setOverStyle() and setSelectedStyle() functions below.
			_dataRowBgColOver = rowBgCol;			
			_dataRowBgColSelected = rowBgCol;
			_dataItemTxtColOver = rowTxtCol;
			_dataItemTxtColSelected = rowTxtCol;
			
			// the TextFormat object used to format any textual data items on the data row
			_dataRowTxtFormat = txtFormat;
			
			_arrDataItems = new Array();
			
			// create data row background
			_dataRowBg = new Sprite();
			_dataRowBg.graphics.lineStyle();
			_dataRowBg.graphics.beginFill(_dataRowBgColDefault);
			_dataRowBg.graphics.drawRect(0, 0, _dataRowWidth, _dataRowHeight);
			_dataRowBg.graphics.endFill();			
			addChild(_dataRowBg);
			
			_dataRowBg.mouseEnabled = false;
			this.mouseChildren = false;
		}
		
		
		/**
		 * This function allows us to use a graphical fill for the rows default background state instead of a flat colour.
		 * 
		 * @param graphicalFill	A display object to be used as a graphical fill for the data rows backgound
		 */		
		public function setDefaultGraphicalFill(graphicalFill:DisplayObject):void
		{
			// create a BitmapData obj to act as our bitmap fill
			var filldata:BitmapData = new BitmapData(graphicalFill.width, graphicalFill.height, false);
			filldata.draw(graphicalFill);			
			
			// clear the current contents of the data rows backgound
			_dataRowBg.graphics.clear();
			
			// create new fill using the created BitmapData
			_dataRowBg.graphics.lineStyle();
			_dataRowBg.graphics.beginBitmapFill(filldata);
			_dataRowBg.graphics.drawRect(0, 0, _dataRowWidth, _dataRowHeight);
			_dataRowBg.graphics.endFill();			
		}
		
		
		/**
		 * Function sets the data rows styling for when the mouse is over it  
		 * 
		 * @param rowBgColOver		Bg colour for data row when mouse rolls over it
		 * @param itemTxtColOver	Textcolour for data items when mouse rolls over the data row
		 */		
		public function setOverStyle(rowBgColOver:uint, itemTxtColOver:uint):void
		{
			_dataRowBgColOver = rowBgColOver;
			_dataItemTxtColOver = itemTxtColOver;		
		}
		
		
		/**
		 * Function sets the data rows styling for when it is selected ie. when the mouse has clicked on it
		 * 
		 * @param rowBgColSelected		Bg colour for data row for when it is selected
		 * @param itemTxtColSelected	Textcolour for data items when data row is selected
		 */		
		public function setSelectedStyle(rowBgColSelected:uint, itemTxtColSelected:uint):void
		{
			_dataRowBgColSelected = rowBgColSelected;
			_dataItemTxtColSelected = itemTxtColSelected;
		}
		
		
		/**
		 * Function adds a standard text based data item to the data row for display 
		 * 
		 * @param strItem		The text to be displayed
		 * @param itemWidth		The width of the textfield. Allows controll over spacing of data items in the data row. Try and make sure
		 * 						 it is wide enough for recieved strItem text
		 * 
		 * @param align			The alignment for the text. Default = center.
		 * @param ifTfBg		If the textfield should have a background. Default = false
		 * @param tfBgCol		Colour of the textfields background when ifBg = true
		 */		
		public function addDataItem(strItem:String, itemWidth:Number, align:String = "center", ifTfBg:Boolean = false, tfBgCol:uint = 0x000000):void
		{
			// set text format alignment
			_dataRowTxtFormat.align = align;
			
			// create text field
			var dataItemTF:TextField = new TextField();//TextFieldUtils.getStandardTextField(false,false,false,false,true, "none");
			dataItemTF.selectable = false;			
			dataItemTF.multiline = false;
			dataItemTF.wordWrap = false;
			dataItemTF.border = false;
			dataItemTF.embedFonts = true;			
			dataItemTF.autoSize = TextFieldAutoSize.LEFT;
			dataItemTF.antiAliasType = AntiAliasType.ADVANCED;
			dataItemTF.defaultTextFormat = _dataRowTxtFormat;	
			
			// need to get what height the text field will be and then reset autosize. Don't ask why!! (ie. pain in the butt flash bug)
			dataItemTF.text = "heightTest";
			var tfHeight:Number = dataItemTF.height;			
			dataItemTF.autoSize = TextFieldAutoSize.NONE;			
			
			dataItemTF.width = itemWidth;
			dataItemTF.height = tfHeight;
			dataItemTF.textColor = _dataItemTxtColDefault;
			dataItemTF.text = strItem;
			
			if(ifTfBg)
			{
				dataItemTF.background = true;
				dataItemTF.backgroundColor = tfBgCol;
			}
			
			dataItemTF.mouseEnabled = false;
			
			// add data item to array for future referencing
			_arrDataItems.push(dataItemTF);
			
			// add data item to the data row for display
			addChild(dataItemTF);
			
			// call function to reposition all data items in the data row now that a new data item has been added
			positionDataItems();
		}
		
		
		/**
		 * Function adds an icon graphic to the data row for display. The icon can be any type of Display Object
		 * 
		 * @param icon		The graphical display object to add to the data row as a data item
		 * @param itemWidth	The width the graphical data item will take up including spacing
		 * @param align		Alignment of the img withiin the itemWidth
		 * 
		 */		
		public function addGraphicalDataItem(icon:DisplayObject, itemWidth:Number, align:String = "center"):void
		{
			// scale the icon height if too tall for row. Leave a 1 px padding above and below
			var availableHeight:Number = _dataRowHeight - 2;
			if(icon.height > availableHeight)
			{
				var ratio:Number = availableHeight/icon.height;				
				icon.height = availableHeight;
				icon.width = icon.width * ratio;
			}
			
			
			// scale the icon width if wider then the specified width for the data item
			if(icon.width > itemWidth)
			{
				icon.width = itemWidth;
			}
			
			
			// determine padding for the icon
			var iconPadding:Number = itemWidth - icon.width;
			
			// depending on the determined icon padding and specifed alignment for the item decide if we need to add spacers
			// to the datarow in order to pad out the graphical data items width to itemWidth
			if(iconPadding > 0)
			{
				switch(align)
				{
					case "right":
						addSpacerItem(iconPadding);
						break;
					
					case "center":
						addSpacerItem(iconPadding/2);
						break;
					
					default:
				}
			}
			
			// add icon to data items array for future referencing
			_arrDataItems.push(icon);
			
			// add icon to the data row for display
			addChild(icon);
			
			
			// depending on the determined icon padding and specifed alignment for the item decide if we need to add spacers
			// to the datarow in order to pad out the graphical data items width to itemWidth
			if(iconPadding > 0)
			{
				switch(align)
				{
					case "left":
						addSpacerItem(iconPadding);
						break;
					
					case "center":
						addSpacerItem(iconPadding/2);
						break;
					
					default:
				}
			}
			
			
			// call function to reposition all data items in the data row now that a new graphical data item has been added
			positionDataItems();
		}
		
		
		/**
		 * Function adds a transparent Sprite to the data row to act as a spacer. Used by the <code>addGraphicalDataItem</code> function
		 * when the icon width is less than the wanted width and needs padding
		 *  
		 * @param spacerWidth
		 * 
		 */		
		private function addSpacerItem(spacerWidth:Number):void
		{
			var spacer:Sprite = new Sprite();
			spacer.graphics.lineStyle();
			spacer.graphics.beginFill(0xFFFFFF, 0);
			spacer.graphics.drawRect(0, 0, spacerWidth, _dataRowHeight);
			spacer.graphics.endFill();
			spacer.name = "spacer";
			spacer.mouseChildren = false;
			spacer.mouseEnabled = false;
			
			// add spacer to data items array for future referencing
			_arrDataItems.push(spacer);
			
			// add spacer item to the data row for display
			addChild(spacer);
		}
		
		
		
		
		/**
		 * Function evenly positions the data items on the data row. Called each time a new data item is added to the data row.
		 */		
		private function positionDataItems():void
		{
			var widthAvailable:Number = _dataRowWidth - _dataRowPadding*2;
			
			var widthNeeded:Number = 0;
			var numOfSpacers:Number = 0;
			
			for(var i:Number = 0; i < _arrDataItems.length; i++)
			{
				if(_arrDataItems[i].name == "spacer")
				{
					numOfSpacers++;
				}
				
				widthNeeded = widthNeeded + _arrDataItems[i].width;
			}
			
			var interItemPadding:Number = 0;
			var numOfPads:Number = _arrDataItems.length - numOfSpacers - 1;
			if(numOfPads > 0)
			{			
				interItemPadding = (widthAvailable - widthNeeded) / numOfPads;
			}
			
			var xPos:Number = _dataRowPadding;
			
			for(var j:Number = 0; j < _arrDataItems.length; j++)
			{
				_arrDataItems[j].y = (_dataRowHeight - _arrDataItems[j].height)/2;
				_arrDataItems[j].x = xPos;
				
				if(_arrDataItems[j].name == "spacer" || numOfPads == 0)
				{
					xPos = xPos + _arrDataItems[j].width;
				}
				else
				{
					xPos = xPos + _arrDataItems[j].width + interItemPadding;
					numOfPads--;
				}
			}		
		}
		
		
		
		/**
		 * Function allows us to changes the appearance of the data row. Useful for setting mouse roll on, roll off, and selected states
		 * 
		 * @param state		Either 'off', 'over', or 'selected'
		 */		
		public function setRowState(rowState:String):void
		{
			switch(rowState)
			{
				case DEFAULT:
					if(_currentState != DEFAULT)
					{
						_currentState = DEFAULT;
						_transitionSpeed = 0.1;
						TweenMax.to(_dataRowBg, _transitionSpeed, {removeTint:true});	
						setDataRowTextCols(_dataItemTxtColDefault);
					}
					break;
				
				case OVER:
					if(_currentState != OVER)
					{
						_currentState = OVER;
						_transitionSpeed = 0.3;
						TweenMax.to(_dataRowBg, _transitionSpeed, {tint:_dataRowBgColOver});
						setDataRowTextCols(_dataItemTxtColOver);
					}
					break;
				
				case SELECTED:
					if(_currentState != SELECTED)
					{
						_currentState = SELECTED;
						_transitionSpeed = 0.4;
						TweenMax.to(_dataRowBg, _transitionSpeed, {tint:_dataRowBgColSelected});
						setDataRowTextCols(_dataItemTxtColSelected);
					}
					break;
				
				default:
			}
		}
		
		
		/**
		 * Function sets the text colour for all textual data itmes in the data row
		 * 
		 * @param txtCol
		 */		
		private function setDataRowTextCols(txtCol:uint):void
		{
			// set text cols for all textual data items in the data row
			for(var i:Number = 0; i < _arrDataItems.length; i ++)
			{
				if(_arrDataItems[i] is TextField)
				{
					_arrDataItems[i].textColor = txtCol;
				}
			}
		}
		
		
		/**
		 * Function returns the unique row id for this data row.
		 * 
		 * @return 
		 */		
		public function getId():Number
		{
			return _dataRowID;
		}
		
		/**
		 * Function returns the current state of the data row
		 * 
		 * @return 
		 */		
		public function getState():String
		{
			return _currentState;
		}
		
	}
}