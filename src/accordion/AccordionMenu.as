package accordion 
{
	import caurina.transitions.Tweener;

	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author danielsun
	 */
	public class AccordionMenu extends Sprite 
	{
		private var _itemArray:Array;
		private var _itemList:Array;
		private var _padding:uint;
		private var _previousItemOpen:uint;
		public static const CALL_BACK:String = "callBack";
		public var itemOpen:String;

		public function AccordionMenu(itemArray:Array, padding:uint = 3)
		{
			_padding = padding;
			_itemArray = new Array();
			_itemArray = itemArray;
			/*
			_itemArray[0] = {name:"ANTROPIZZAZIONE", url:new URLRequest("img/1.jpg"), id:1};
			_itemArray[1] = {name:"AMBIENTE", url:new URLRequest("img/2.jpg"), id:2};
			_itemArray[2] = {name:"STORIA", url:new URLRequest("img/3.jpg"), id:3};
			_itemArray[3] = {name:"TRADIZIONI POPOLARI", url:new URLRequest("img/4.jpg"), id:4};
			_itemArray[4] = {name:"MONUMENTI", url:new URLRequest("img/5.jpg"), id:5};
			_itemArray[5] = {name:"APPUNTAMENTI", url:new URLRequest("img/6.jpg"), id:6};
			*/
			_itemList = [];
			
			create();
		}

		private function create():void
		{
			
			for(var i in _itemArray)
			{
				var item:Item = new Item(_itemArray[i].name, _itemArray[i].url, _itemArray[i].id);
				item.y = (i * (40 + _padding));
				trace(i);
				item.addEventListener(Item.TWEEN_START, startTweenItems);
				item.addEventListener(Item.TWEEN_FINISH, changeSection);
				addChild(item);
				
				_itemList.push(item);
				if(uint(i) == _itemArray.length - 1)
				{
					trace('i==', _itemArray.length);
					item.addEventListener(Item.READY, readyToSet);
				}
			}
		}

		private function readyToSet(e:Event):void
		{
			trace('ready: ' + (e.target.id));
			expandDefault(0);
		}

		private function expandDefault(j:uint):void
		{
			_itemList[j].expand();
			_previousItemOpen = j + 1;
			for(var n:uint = j + 1;n < _itemList.length; n++)
			{
				Tweener.addTween(_itemList[n], {time:1, y:(_itemList[n].y + 100)});
			}
		}

		private function startTweenItems(event:Event):void
		{
			if(event.target.id != _previousItemOpen)
			{
				for (var k:int = 0;k < _itemList.length; k++) 
				{
					/*
					 * se l'item id selezionata è = a quella precedentemente aperta
					 */
					if(_itemList[k].id == _previousItemOpen)
					{
						_itemList[k].collapse();
					
						/*
						 * inoltre se l'item apera viene anche dopo quella che ho cliccato
						 * deve anche rispostarsi in basso (Slide +100)
						 */
						if(_itemList[k].id > event.target.id)
						{
							Tweener.addTween(_itemList[k], {time:1, y:(_itemList[k].y + 100)});
						}
					}
					/*
					 * se l'item id selezionata è <= a quella cliccata e > di quella aperta deve spostarsi in alto 
					 * o meglio
					 * se l'item selezionata stà sopra quella cliccata (o è quella cliccata) e sotto quella aperta, deve spostarsi verso l'altro (Slide -100)
					 */
					if(_itemList[k].id <= event.target.id && _itemList[k].id > _previousItemOpen)
					{
						Tweener.addTween(_itemList[k], {time:1, y:(_itemList[k].y - 100)});
					}
				
				
					/*
					 * se l'item stà sotto quella cliccata e sopra quella precedentemente aperta
					 */
					if(_itemList[k].id > event.target.id && _itemList[k].id < _previousItemOpen)
					{
						Tweener.addTween(_itemList[k], {time:1, y:(_itemList[k].y + 100)});
					}
				}
			}
			
			_previousItemOpen = event.target.id;
		}

		private function changeSection(event:Event):void
		{
			itemOpen = _itemArray[event.target.id - 1].name;
			//trace('Switching to', _itemArray[event.target.id-1].name);
			this.dispatchEvent(new Event(AccordionMenu.CALL_BACK));
		}

		public function get padding():Number
		{
			return _padding;
		}

		public function set padding(padding:Number):void
		{
			_padding = padding;
		}

		public function get previousItemOpen():uint
		{
			return _previousItemOpen;
		}
	}
}
