package lib.utils
{	
	/**
	 * 
	 * @author Dominic Gelineau
	 * 
	 * This will load the Symbols from external SWF.
	 */
	public class SharedAssetsLibrary
	{
		public static var instance:SharedAssetsLibrary;		
		
		/*
		 * this is how you would embed a MovieClip from an swf Library exported for ActionScript with class name BackgroundAsset
		
		[Embed(source="../../../swf/Background.swf", symbol="BackgroundAssets")]
		public var BackgroundAssets:Class;
		
		*Now to use this in a view first import this class and than use it like this
		
		var BackgroundAssets:Class = SharedAssetsLibrary.getInstance().getAsset("BackgroundAssets");
		var	assets:* = new BackgroundAssets();
		addChild(Sprite(assets));
		*/
		
		
		public function getAsset(newSymbol:String):Class
		{
			return instance[newSymbol];
		}		
		
		public static function getInstance():SharedAssetsLibrary
		{
			if (instance == null) instance = new SharedAssetsLibrary();
			return instance;
		}	
	}	
}