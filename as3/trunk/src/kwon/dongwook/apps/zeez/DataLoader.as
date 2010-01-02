package kwon.dongwook.apps.zeez {
	
	import deng.fzip.FZip;
	import deng.fzip.FZipEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLVariables;
	
	import kwon.dongwook.apps.zeez.models.DataParser;
	import kwon.dongwook.apps.zeez.models.Recognizer;
	import kwon.dongwook.events.DynamicEvent;
	import kwon.dongwook.utils.StringUtil;
	
	public class DataLoader extends EventDispatcher {
		
		private const CONFIG_FILE:String = "data/config.txt";

		public static const COMPLETE:String = "complete";
		[Event(name="complete", type="kwon.dongwook.events.DynamicEvent")]
				
		private var _loader:URLLoader;
		private var _config:Config;
		private var _zipLoader:FZip;
		private var _recognizer:Recognizer;
		
		public function DataLoader() {
			_config = new Config();
			_loader = new URLLoader();
			_loader.addEventListener(Event.COMPLETE, function(e:Event):void {
				setConfig(new URLVariables(_loader.data));
				loadStudyModel();
			}, false, 0, true);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, errorEventHandler, false, 0, true);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorEventHandler, false, 0, true);
		}
		
		public function load():void {
			_loader.load(new URLRequest(CONFIG_FILE));
		}
		
		private function setConfig(vars:URLVariables):void {
			_config.modelPath = StringUtil.trim(vars.model);
		}
		
		private function loadStudyModel():void {
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, errorEventHandler);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorEventHandler);
			_loader.close();
			_zipLoader = new FZip();
			_zipLoader.addEventListener(FZipEvent.FILE_LOADED, fileLoadedEventHandler);
			_zipLoader.addEventListener(Event.COMPLETE, completeEventHandler);
			_zipLoader.addEventListener(IOErrorEvent.IO_ERROR, errorDataFileLoadEventHandler);
			_zipLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, errorDataFileLoadEventHandler);
			_zipLoader.load(new URLRequest(_config.modelPath));
		}
		
		private function fileLoadedEventHandler(event:FZipEvent):void {
			var parser:DataParser = new DataParser();
			_recognizer = parser.parse(event.target.getFileAt(0).content);
		}
		
		private function completeEventHandler(event:Event):void {
			var e:DynamicEvent = new DynamicEvent(COMPLETE);
			e.data = {recognizer:_recognizer};
			dispatchEvent(e);
			close();	
		}
		
		private function close():void {
			_zipLoader.removeEventListener(FZipEvent.FILE_LOADED, fileLoadedEventHandler);
			_zipLoader.removeEventListener(Event.COMPLETE, completeEventHandler);
			_zipLoader.removeEventListener(IOErrorEvent.IO_ERROR, errorDataFileLoadEventHandler);
			_zipLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, errorDataFileLoadEventHandler);
			_zipLoader.close();
		}
		
		private function errorDataFileLoadEventHandler(e:Event):void {
			trace("Get File Error:" + e);
		}
		
		private function errorEventHandler(e:Event):void {
			loadStudyModel();
		}

	}
}