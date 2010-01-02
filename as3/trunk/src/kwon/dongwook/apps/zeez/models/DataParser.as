package kwon.dongwook.apps.zeez.models {
	
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.errors.EOFError;
	
	public class DataParser {
		
		private const FILESIZE_CHECKSUM:uint = 0xef71821;
		private const DICTIONARY_VERSION:int = 1;
		
		public function parse(studyFile:ByteArray):Recognizer {
			var recognizer:Recognizer = new Recognizer();
			studyFile.endian = Endian.LITTLE_ENDIAN;
			try { 
				var fileSize:uint = int(studyFile.readUnsignedInt() ^ FILESIZE_CHECKSUM);
				if (fileSize != studyFile.length)
					trace("Error: file size is wrong");
				var version:uint = studyFile.readUnsignedInt();
				if (version != DICTIONARY_VERSION)
					trace("Incompatiable version of file");
				
				var length:uint = studyFile.readUnsignedInt();
				var cases:Vector.<Case> = new Vector.<Case>(length, true);
				for (var i:int = 0; i < length; i++) {
					var study:Case = new Case();
					study.character = studyFile.readMultiByte(16, "utf-8");
					study.bias = studyFile.readFloat();
					var features:Vector.<Feature> = new Vector.<Feature>();
					var index:int = -1;
					while ((index = studyFile.readInt()) != -1) {
						var feature:Feature = new Feature(index);
						feature.value = studyFile.readFloat();
						features.push(feature);
					}
					study.features = features;
					cases[i] = study;
					studyFile.readInt();
				}
				recognizer.cases = cases;
			} catch(error:EOFError) {
				trace("EOF Error : " + error);
			} finally {
				return recognizer;
			}
		}
		
	}
}