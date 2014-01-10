package accordion 
{
	import flash.display.BlendMode;
	import caurina.transitions.Tweener;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	/**
	 * @author danielsun
	 */
	public class Item extends Sprite 
	{
		private var _itemText:String;
		private var _photoUrl:URLRequest;
		private var _id:uint;
		private var _itemBtnHeight:uint;
		private var _mask:Sprite;
		private var _itemButton:Sprite;
		private var _menuTxt:TextField;
		private var _menuFormat:TextFormat;
		private var _content:Sprite;
		private var _contentLoader:Loader;
		public static const TWEEN_FINISH:String = "tweenFinish";
		public static const TWEEN_START:String = "tweenStart";
		public static const READY:String = "ready";
		private var _isOpen:Boolean;
		private var _activeMenuFormat:TextFormat;

		public function Item(itemText:String, photoUrl:URLRequest, id:uint):void
		{
			//initial settings
			_isOpen = false;
			_itemText = itemText;
			_photoUrl = photoUrl;
			_id = id;
			_itemBtnHeight = 40;
			
			_content = new Sprite();
			_contentLoader = new Loader();
			_contentLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, completeHandler);
			
			try 
			{
				_contentLoader.load(_photoUrl);
			} 
			catch (error:Error) 
			{
				trace("Unable to load requested document.");
			}
		}

		private function completeHandler(event:Event):void
		{
			create();
		}

		private function create():void
		{
			
			// create a sprite mask to hide the content
			_mask = new Sprite();
			_mask.graphics.beginFill(0x000000, 1);
			_mask.graphics.drawRect(0, 0, 180, _itemBtnHeight);
			_mask.graphics.endFill();
			addChild(_contentLoader);
			addChild(_mask);
			_contentLoader.y = -100;
			_contentLoader.mask = _mask;


			_itemButton = new Sprite();
			_itemButton.graphics.beginFill(0x666666, 1);
			_itemButton.graphics.drawRect(0, 0, 180, 40);
			_itemButton.graphics.endFill();
			_itemButton.blendMode= BlendMode.MULTIPLY;
			addChild(_itemButton);
			
			
			//text field formatting
			_menuFormat = new TextFormat();
			_menuFormat.font = new Universal().fontName;//class name of font in parent library
			_menuFormat.size = 21;
			_menuFormat.letterSpacing = -2.8;
			_menuFormat.color = 0xCCCCCC;
			_menuFormat.bold = true;

			//text field formatting
			_activeMenuFormat = new TextFormat();
			_activeMenuFormat.font = new Universal().fontName;//class name of font in parent library
			_activeMenuFormat.size = 21;
			_activeMenuFormat.letterSpacing = -2.8;
			_activeMenuFormat.color = 0xFFFFFF;

			
			//text field constructing
			_menuTxt = new TextField();
			_menuTxt.type = TextFieldType.DYNAMIC;
			_menuTxt.autoSize = TextFieldAutoSize.LEFT;
			_menuTxt.embedFonts = true;
			_menuTxt.x = 0;
			_menuTxt.y = 5;
			_menuTxt.mouseEnabled = false;
			
			_menuTxt.htmlText = _itemText;
			
			_menuTxt.setTextFormat(_menuFormat);
			addChild(_menuTxt);//add the menus title text
			addInteractivity();
			
			if(this._id == 6)
			{
				trace('creating id1');
				this.dispatchEvent(new Event(Item.READY));
			}
		}

		private function addInteractivity():void
		{
			this._itemButton.addEventListener(MouseEvent.CLICK, clickHandler);
		}

		private function clickHandler(e:MouseEvent):void
		{
			// create a new dispatcher to handle external action
			this.dispatchEvent(new Event(Item.TWEEN_START));
			if (this._isOpen)
			{
				//collapse();
				//_isOpen = false;
			}
			else
			{
				expand();
			}
		}

		public function collapse():void
		{
			
			Tweener.addTween(_contentLoader, {time:1, y:-100});
			Tweener.addTween(_itemButton, {time:1, y:0});
			Tweener.addTween(_menuTxt, {time:1, y:5});
			Tweener.addTween(_mask, {time:1, height:40, onComplete:collapseHandler});
		}

		public function expand():void
		{
			trace('ITEM: expanding item!');
			Tweener.addTween(_contentLoader, {time:1, y:0});
			Tweener.addTween(_itemButton, {time:1, y:100});
			Tweener.addTween(_menuTxt, {time:1, y:105});
			Tweener.addTween(_mask, {time:1, height:140, onComplete:expandHandler});
		}

		private function expandHandler():void
		{
			dispatchEvent(new Event(Item.TWEEN_FINISH));
			_isOpen = true;
			_menuTxt.setTextFormat(_activeMenuFormat);
		}

		private function collapseHandler():void
		{
			//dispatchEvent(new Event(Item.TWEEN_FINISH));
			_isOpen = false;
			_menuTxt.setTextFormat(_menuFormat);
		}

		/*
		 * GETTERS & SETTERS
		 */
		public function get id():uint
		{
			return _id;
		}

		public function set id(id:uint):void
		{
			_id = id;
		}

		public function get photoUrl():URLRequest
		{
			return _photoUrl;
		}

		public function set photoUrl(photoUrl:URLRequest):void
		{
			_photoUrl = photoUrl;
		}

		public function get itemText():String
		{
			return _itemText;
		}

		public function set itemText(itemText:String):void
		{
			_itemText = itemText;
		}

		public function get isOpen():Boolean
		{
			return _isOpen;
		}

		public function set isOpen(isOpen:Boolean):void
		{
			_isOpen = isOpen;
		}
	}
}
