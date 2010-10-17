package lib.social.facebook 
{
	import flash.events.EventDispatcher;
	import flash.external.ExternalInterface;

	
	/**
	 * facebook help
	 * @author Paulo Afonso @ http://www.view.pt
	 */
	public class FaceBook
	{
		static private var _isInited:Boolean;
		protected static var disp:EventDispatcher;
		static private var _isJsReady:Boolean = false;
		
		public function FaceBook(){}
		
		static private function init():Boolean
		{
			//trace("@ FaceBook.init()");
			if (_isInited) 
			{
				return true;
			}
			else
			{
				if (ExternalInterface.available)
				{
					if ( ExternalInterface.call("isFbReady") )
					{						
						ExternalInterface.addCallback("loginSucess", onLoginSucess);
						ExternalInterface.addCallback("loginFail", onLoginFail);
						ExternalInterface.addCallback("logout", onLogout);
						ExternalInterface.addCallback("loginStatus", onLoginStatus);
												
						_isInited = true;
						return true;
						
					} else return false;
				} 
				else
				{
					return false;
					throw new Error("ExternalInterface not available. Check param.allowScriptAccess");
				}
			}
		}
		/**
		 * verifica se o js está disponivel
		 */
		static public function get isReady():Boolean
		{
			//trace("@ FaceBook.isReady()");
			if (_isJsReady)
			{
				return init();
			}
			else if (ExternalInterface.available && ExternalInterface.call("isFbReady"))
			{
				_isJsReady = true;
				return init();
			} 
			else return false;
		}
		
		static private function onLogout():void
		{
			//trace("@ FaceBook.onLogout()");
			dispatchEvent(new FaceBookEvent(FaceBookEvent.ON_LOGOUT ));
		}
		
		static private function onLoginSucess(str:String):void
		{
			//trace("@ FaceBook.onLoginSuccess()");
			dispatchEvent(new FaceBookEvent(FaceBookEvent.ON_LOGIN_SUCCESS, str ));
		}
		
		static private function onLoginStatus(str:String):void
		{
			//trace("@ FaceBook.onLoginStatus()");
			dispatchEvent(new FaceBookEvent(FaceBookEvent.ON_LOGIN_STATUS, str ));
		}
		
		static private function onLoginFail():void
		{
			//trace("@ FaceBook.onLoginFail()");
			dispatchEvent(new FaceBookEvent(FaceBookEvent.ON_LOGIN_FAIL));
		}
		
		static public function doLogin():void
		{
			//trace("@ FaceBook.doLogin()");
			if ( init() ) ExternalInterface.call("fbLogin");
			else dispatchEvent(new FaceBookEvent(FaceBookEvent.NOT_READY));
		}
		
		static public function doLogout():void
		{
			//trace("@ FaceBook.doLogout()");
			if ( init() )
				ExternalInterface.call("fbLogout");
			else dispatchEvent(new FaceBookEvent(FaceBookEvent.NOT_READY));
		}
		
		static public function checkLogin():void
		{
			//trace("@ FaceBook.checkLogin()");
			if ( init() ) ExternalInterface.call("isLogged");
			else dispatchEvent(new FaceBookEvent(FaceBookEvent.NOT_READY));
		}
		
		
		/**
		 * ferramentas para os eventos
		 */
		public static function addEventListener(...p_args:Array):void {
   			if (disp == null) { disp = new EventDispatcher(); }
   			disp.addEventListener.apply(null, p_args);
   		}
  		public static function removeEventListener(...p_args:Array):void {
   			if (disp == null) { return; }
   			disp.removeEventListener.apply(null, p_args);
   		}
  		public static function dispatchEvent(...p_args:Array):void {
   			if (disp == null) { return; }
   			disp.dispatchEvent.apply(null, p_args);
   		}
	}

}