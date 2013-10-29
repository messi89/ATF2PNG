package
{
	import flash.desktop.NativeApplication;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.utils.ByteArray;
	
	import overgen.atf2pngt.FileUtil;
	
	import starling.core.RenderSupport;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	
	
	/**
	 * ...
	 * @author Messi89 OverGen
	 */
	public class Main extends Sprite
	{
		private var img:Image;
		private var curFileName:String;
		private var files:Array;
		private var index:int;
		private var importDir:File;
		private var exportDir:File;
		
		public function Main() 
		{
			importDir = new File();
			importDir.addEventListener(Event.SELECT, onImportDirSelected);
			importDir.browseForDirectory("ATF2PngTransparency - Select your ATF folder");
		}
		
		private function onImportDirSelected(e:Event):void {
			exportDir = new File();
			exportDir.addEventListener(Event.SELECT, onExportDirSelected);
			exportDir.browseForDirectory("ATF2Png - Select your PNG out folder");
		}
		
		private function onExportDirSelected(e:Event):void {
			files = importDir.getDirectoryListing();
			for (var i:int=0; i<files.length; i++) {
				if (String(files[i].type).toLowerCase() != '.atf') {
					files.splice(i, 1);
					i--;
				}
			}
			index = 0;
			loadFile(index);
		}
		
		private function loadFile(n:int):void {
			var file:File = files[n];
			curFileName = file.name.split('.')[0];
			var atfData:ByteArray = FileUtil.readBinFile(file);
			var t:Texture = Texture.fromAtfData(atfData);
			if (img) {
				img.width = t.width;
				img.height = t.height;
				img.texture = t;
			} else {
				img = new Image(t);
				addChild(img);
			}
			Starling.juggler.delayCall(drawScreen, 2);
		}
		
		private function drawScreen():void
		{
			var bd:BitmapData = new BitmapData(img.width, img.height, true, 0x00000000);
			try {
				var support:RenderSupport = new RenderSupport();			
				RenderSupport.clear();		
				support.setOrthographicProjection(0, 0, stage.stageWidth, stage.stageHeight);
				support.applyBlendMode( true );				
				Starling.current.root.render(support, 1.0);
				support.finishQuadBatch();				
				
				Starling.context.drawToBitmapData(bd);
				Starling.context.present();							
				
				var file:File = exportDir.resolvePath(curFileName + '.png');
				FileUtil.savePNGFile(bd, file);
			} catch (e:Error) {
				trace('!', e);
			}
			index ++;
			if (index == files.length) {
				removeChildren();
				var tx:TextField = new TextField(300, 50, "The conversion is complete", "Arial", 30, 0, true);
				addChild(tx);
				//close the app after converting all atf textures
				NativeApplication.nativeApplication.exit();
			} else {
				loadFile(index);
			}
		}
	}
}