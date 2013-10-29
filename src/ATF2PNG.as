package
{
	import flash.display.Sprite;
	import flash.display3D.Context3DProfile;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import starling.core.Starling;
	
	/**
	 * ...
	 * @author Messi89 OverGen
	 */
	
	[SWF(width="2048", height="2048", frameRate="60")]
	public class ATF2PNG extends Sprite
	{
		public static var isDebug:Boolean = true;		
		private var _starling:Starling;
		
		public function ATF2PNG()
		{
			
			if (stage) 
			{
				init(null);
				
			} 
			else 
			{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
		}
		
		private function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			Starling.multitouchEnabled = false;
			
			var viewPort:Rectangle = new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);
			_starling = new Starling(Main, stage, viewPort,null,Context3DRenderMode.AUTO, Context3DProfile.BASELINE);
			_starling.simulateMultitouch = false;
			_starling.enableErrorChecking = isDebug;
			_starling.showStats = isDebug;
			_starling.stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
		}
		
		private function onContextCreated(e:flash.events.Event):void
		{
			_starling.start();
		}
	}
}