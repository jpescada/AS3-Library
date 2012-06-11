package lib.motion
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.BlurFilter;
	import flash.utils.Dictionary; 
	
	/**
	 * 
	 * @author	João Pescada | VIEW. [joao.pescada@view.pt | (+351) 214818500 | www.view.pt]
	 * @date	09/10/06
	 * @version	1.02.01
	 * @log		Added _target property and methods for MOUSE_LEAVE and MOUSE_MOVE.
	 * 
	 * @author	Fuori Dal Cerchio
	 * @date	08/12/15
	 * @version	1.01.01
	 * @url		http://www.fuoridalcerchio.net/wordpress/2008/12/15/as3parallaxbox-2/
	 * 
	 */	
	dynamic public class Parallax extends MovieClip 
	{
		
		// private properties
		private var theObjects:Array; 
		private var theMode:Number;
		private var theState:Number; 
		private var theStarts:Dictionary; 
		
		// user definable properties
		private var _blurred:Boolean = false;
		private var _xrate:Number = 1; 
		private var _yrate:Number = 1; 
		private var _autodetect:Boolean = false; 
		
		// public constants for parallax movement
		public static const HORIZONTAL:Number = 1; 
		public static const VERTICAL:Number = 2; 
		public static const BOTH:Number = 3; 
		
		// debug mode (use it to trace errors)
		public static const DEBUG:Boolean = false;
		private var _target:MovieClip;
		private var _isActive:Boolean = false;
		
		public function Parallax(target:MovieClip) 
		{
			_target = target;
			theObjects = new Array(); 
			theStarts = new Dictionary(); 
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true); 
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			if (DEBUG) 
			{
				trace("init ok"); 
			}
			theState = 0; 
		}
		
		public function set mode (v:Number):void 
		{
			theMode = v; 
			if (DEBUG) 
			{
				trace("mode selected: " + v); 
			}
		}
		
		public function set xrate (m:Number):void 
		{
			_xrate = m; 
		}
		
		public function set yrate (m:Number):void 
		{
			_yrate = m; 
		}		
		
		public function set blurred (m:Boolean):void 
		{
			_blurred = m; 
		}
		
		public function set autowing (m:Boolean):void 
		{
			_autodetect = m; 
		}
		
		public function addItem(s:String, wingx:Number, wingy:Number, pixelHinting:Boolean = false):void 
		{
			var clip:MovieClip = _target.getChildByName(s) as MovieClip; 
			theObjects.push( { movie: clip, wingx: wingx, wingy: wingy, startx: clip.x, starty:clip.y, pixelhinting: pixelHinting } ); 
			if (DEBUG) 
			{
				trace("object added to render list: " + clip); 
			}
		}
		
		public function start():void 
		{
			_isActive = true;
			addEventListener(Event.ENTER_FRAME, onFrame, false, 0, true);
			//_target.stage.addEventListener(Event.MOUSE_LEAVE, onLeave, false, 0, true);			
		}
		
		public function pause():void 
		{
			_isActive = false;
			removeEventListener(Event.ENTER_FRAME, onFrame);
			//if ( _target.stage.hasEventListener(Event.MOUSE_LEAVE) ) _target.stage.removeEventListener(Event.MOUSE_LEAVE, onLeave);
			//if ( _target.stage.hasEventListener(MouseEvent.MOUSE_MOVE) ) _target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
		}
		
		private function onLeave(e:Event):void
		{
			if (DEBUG) trace("MOUSE LEAVE")
			pause();
			_target.stage.removeEventListener(Event.MOUSE_LEAVE, onLeave);
			_target.stage.addEventListener(MouseEvent.MOUSE_MOVE, onMove, false, 0, true);			
		}
		
		private function onMove(e:MouseEvent):void
		{
			_target.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMove);
			start();
		}
		
		private function onFrame(e:Event):void 
		{
			if (DEBUG) trace("onFrame", "stageW:", _target.stage.stageWidth, "stageH:", _target.stage.stageHeight, "mouseX:", _target.mouseX, "mouseY:", _target.mouseY);
			var targetMouseX:Number = _target.mouseX;
			if (_target.mouseX < 0) targetMouseX = 0;
			if (_target.mouseX > _target.stage.stageWidth) targetMouseX = _target.stage.stageWidth;
			if (DEBUG) trace("\t", "targetMouseX:", targetMouseX);

			var targetMouseY:Number = _target.mouseY;			
			if (_target.mouseY < 0) targetMouseY = 0;
			if (_target.mouseY > _target.stage.stageHeight) targetMouseY = _target.stage.stageHeight;
			if (DEBUG) trace("\t", "targetMouseY:", targetMouseY);
			
			var xP:Number = - (100 / (_target.stage.stageWidth * .5) * targetMouseX); 
			var yP:Number = - (100 / (_target.stage.stageHeight * .5) * targetMouseY); 	
			
			var hwing:Number;  
			var vwing:Number;
			
			for (var m:int = 0; m < theObjects.length; m++) 
			{
				var clip:MovieClip = theObjects[m].movie; 
				
				hwing = theObjects[m].wingx; 
				vwing = theObjects[m].wingy; 
				
				if (_autodetect == true) 
				{
					//hwing = (clip.width * .5) - (stage.stageWidth * .5); 
				}
				
				if (theMode == 1 || theMode == 3) 
				{
					var targetx:Number = theObjects[m].startx + ((hwing / 100) * xP); 
					var xdiff:Number = clip.x - targetx; 
					var xamount:Number = (xdiff / _xrate); 
					var xblur:Number = Math.abs(xamount) * 1.2; 
					clip.x -= xdiff / _xrate ; 
					
					if (theObjects[m].pixelhinting) 
					{
						clip.x = Math.floor(clip.x); 
					}					
				}
				
				if (theMode == 2 || theMode == 3) 
				{
					var targety:Number = theObjects[m].starty + ((vwing / 100) * yP); 
					var ydiff:Number = clip.y - targety; 
					var yamount:Number = (ydiff / _yrate); 
					var yblur:Number = Math.abs(yamount) * 1.2; 
					clip.y -= ydiff / _yrate ; 	
					if (theObjects[m].pixelhinting) {
						clip.y = Math.floor(clip.y); 
					}	
				}
				
				if ((Math.floor(xblur) >= 1 || Math.floor(yblur) >= 1) && _blurred == true) 
				{
					clip.filters = new Array( new BlurFilter(xblur, yblur, 1) ); 
				}						
				
			}
		}
		
	}
	
}