package lib.social.facebook 
{
	import flash.events.Event;
	
	
	/**
	 * ...
	 * @author Paulo Afonso @ http://www.view.pt
	 */
	public class FaceBookEvent extends Event
	{
		static public const ON_LOGIN_SUCCESS:String = "ON_LOGIN_SUCESS";
		static public const ON_LOGIN_FAIL:String = "ON_LOGIN_FAIL";
		static public const ON_LOGOUT:String = "ON_LOGOUT";
		static public const ON_LOGIN_STATUS:String = "ON_LOGIN_STATUS";
		static public const NOT_READY:String = "NOT_READY";
		
		protected var _result:String;
		
		public function FaceBookEvent(type:String, result:String ="", bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			_result = result;
		} 
		public function get result():String
		{ 
			return _result; 
		}
		
		public override function clone():Event 
		{ 
			return new FaceBookEvent(type, _result, bubbles, cancelable);
		} 
		
	
		
	}

}