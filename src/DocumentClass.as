package  
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.net.URLRequest;

	import accordion.AccordionMenu;

	/**
	 * @author danielsun (danielsun@gmail.com)
	 */
	public class DocumentClass extends MovieClip 
	{
		private var newAccord:AccordionMenu;
		private var _itemArray:Array;

		public function DocumentClass()
		{
			
			_itemArray = new Array();
			_itemArray[0] = {name:"ANTROPIZZAZIONE", url:new URLRequest("img/1.jpg"), id:1};
			_itemArray[1] = {name:"AMBIENTE", url:new URLRequest("img/2.jpg"), id:2};
			_itemArray[2] = {name:"STORIA", url:new URLRequest("img/3.jpg"), id:3};
			_itemArray[3] = {name:"TRADIZIONI POPOLARI", url:new URLRequest("img/4.jpg"), id:4};
			_itemArray[4] = {name:"MONUMENTI", url:new URLRequest("img/5.jpg"), id:5};
			_itemArray[5] = {name:"APPUNTAMENTI", url:new URLRequest("img/6.jpg"), id:6};
			
			
			newAccord = new AccordionMenu(_itemArray, 5);
			addChild(newAccord);
			newAccord.addEventListener(AccordionMenu.CALL_BACK, launchSection);
		}

		private function launchSection(event:Event):void
		{
			trace('Switching to: ', newAccord.itemOpen);
		}
	}
}
