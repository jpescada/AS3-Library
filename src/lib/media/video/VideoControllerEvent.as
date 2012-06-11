package lib.media.video 
{
	import flash.events.Event;
	
	/**
	 * VideoControllerEvent
	 * @author Paulo Afonso
	 * @version 1.0
	 * @lastUpdate xx/xx/2009
	 */
	
	public class VideoControllerEvent extends Event 
	{
		static public const METADATA_LOADED:String = "_vce_onLoadedMetaData";
		static public const CUEPOINT_LOADED:String = "_vce_onLoadedCuePoint";
		static public const SIZE_CHANGED:String = "_vce_onVideoSizeChanged";
		static public const VIDEO_END:String = "_vce_onVideoEnd";
		static public const TIME_CHANGED:String = "_vce_onTimeChanged";
		static public const LOADED_CHANGED:String = "_vce_onVideoLoadedChanged";
		
		
		
		public function VideoControllerEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) 
		{ 
			super(type, bubbles, cancelable);
			
		} 
		
		public override function clone():Event 
		{ 
			return new VideoControllerEvent(type, bubbles, cancelable);
		} 
		
		public override function toString():String 
		{ 
			return formatToString("VideoControllerEvent", "type", "bubbles", "cancelable", "eventPhase"); 
		}
		
	}
	
}