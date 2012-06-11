package lib.utils
{
	public class Time2
	{
		public function Time2()
		{
		}
		
		public static function secondsToMinutesSeconds(secs:Number):String
		{
			var s:Number = secs % 60;
			var m:Number = Math.floor( (secs % 3600 ) / 60 );
			var h:Number = Math.floor( secs / (60 * 60) );

			var hStr:String = h < 10 ? "0"+ h.toString() +":" : h.toString() +":";
			if (h == 0) hStr = "";
			var mStr:String = m < 10 ? "0"+ m.toString() +":" : m.toString() +":";
			var sStr:String = s < 10 ? "0"+ s.toString() : s.toString();
			
			return hStr + mStr + sStr;
		}
	}
}