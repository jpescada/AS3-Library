package lib.stats
{

	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.external.ExternalInterface;

	/**
	 * GoogleAnalytics
	 * Simple way to track info
	 * 
	 * how to use
	 * import lib.net.GoogleAnalytics;
	 * GoogleAnalytics.track("EN/Sobre nós/Empresa");
	 * 
	 * @version 1 
	 * @author (View 2009) Paulo Afonso 
	 * 
	 */
	
	public class GoogleAnalytics 
	{
		
		public function GoogleAnalytics() 
		{
			
		}
		static public function track(path:String):void
		{
			
			try
			{
				//navigateToURL(new URLRequest("javascript:pageTracker._trackPageview('" + path + "','_self');"));
				ExternalInterface.call("pageTracker._trackPageview", path);
				trace("@ GoogleAnalytics.track() | path: "+ path);
			}
			catch (err:Error)
			{
				trace("@ GoogleAnalytics.track() ERROR | path: "+ path +" | error: "+ err);
			}
		}
	}
	
}
