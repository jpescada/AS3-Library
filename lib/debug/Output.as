package lib.debug
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * 		
	 * 		@author Joao Pescada | VIEW. [joao.pescada@view.pt | (+351) 214818500 | www.view.pt] 	
	 * 		@version 1.0.0
	 * 
	 */
	public class Output extends Sprite
	{
		private var debug_txt:TextField;
		private var _error:String;
		 
		public function Output(target:DisplayObjectContainer, error:String)
		{
			//TODO: Convert this to a functional class
			debug_txt = target.getChildByName("debug_txt") as TextField;
			_error = error;
			//trace("@ Output()", debug_txt, target, error, target.numChildren);
			if (debug_txt == null)
			{
				var fmt:TextFormat = new TextFormat();
				fmt.font = "_typewriter";
				fmt.size = 11;
				debug_txt = new TextField();
				debug_txt.textColor = 0xFFFFFF;
				debug_txt.background = true;
				debug_txt.backgroundColor = 0x000000;
				debug_txt.autoSize = TextFieldAutoSize.LEFT;
				debug_txt.defaultTextFormat = fmt;
				debug_txt.addEventListener(Event.ADDED_TO_STAGE, handleAdded)
				target.addChildAt(debug_txt, target.numChildren);
			}
			
			debug_txt.text = _error;
			debug_txt.x = 10;
			debug_txt.y = 10;
		}
		
		private function handleAdded(evt:Event):void{ /*trace("\t--OUTPUT ADDED", debug_txt.text, debug_txt.textWidth);*/ }
		
		public function update(txt:String):void
		{
			debug_txt.text = txt;
		}
	}
}