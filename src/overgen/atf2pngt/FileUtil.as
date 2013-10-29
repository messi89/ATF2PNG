package overgen.atf2pngt
{
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.PNGEncoderOptions;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	import flash.utils.Endian;

	/**
	 * ...
	 * @author Messi89 OverGen
	 */
	public class FileUtil 
	{
		
		public function FileUtil() 
		{
			
		}
		
		public static function savePNGFile(data:BitmapData, file:File):void
		{
			saveImageFile(data, file, new PNGEncoderOptions());
		}
		
		public static function saveJPEGFile(data:BitmapData, file:File):void
		{
			saveImageFile(data, file, new JPEGEncoderOptions(80));
		}
		
		public static function saveImageFile(data:BitmapData, file:File, compressor:Object):void
		{
			if (data == null || file == null || compressor == null) return;
			
			var bytes:ByteArray = data.encode(data.rect, compressor);
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.WRITE);
			fs.writeBytes(bytes);
			fs.close();
			bytes.clear();
		}		

		
		public static function readBinFile(file:File):ByteArray
		{
			if (!file.exists)
			{
				return null;
			}
			
			var bytes:ByteArray = new ByteArray();
			bytes.endian  = Endian.LITTLE_ENDIAN;
			var fs:FileStream = new FileStream();
			fs.open(file, FileMode.READ);
			fs.readBytes(bytes);
			fs.close();
			return bytes;
		}
		
	}

}