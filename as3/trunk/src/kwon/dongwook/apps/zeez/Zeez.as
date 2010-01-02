package kwon.dongwook.apps.zeez {
	
	import __AS3__.vec.Vector;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import kwon.dongwook.apps.zeez.models.Character;
	import kwon.dongwook.apps.zeez.models.Recognizer;
	import kwon.dongwook.apps.zeez.models.Result;
	import kwon.dongwook.apps.zeez.models.Stroke;
	import kwon.dongwook.events.DynamicEvent;
	
	[Event(name="ready", type="flash.events.Event")]
	[Event(name="error", type="flash.events.ErrorEvent")]
	public class Zeez extends EventDispatcher {
		
		public static const READY:String = "ready";
		public static const ERROR:String = ErrorEvent.ERROR;
		
		private var _recognizer:Recognizer;
		private var _loader:DataLoader;
		
		
		/**
		 * It rescales area of strokes for better results. Basically what it tries to do is removing margin around strokes
		 * which means your training data must not include margin around character.
		 * So if you're planning using other model data like Zinnia-Tomoe data, you must set this false.
		 * 
		 */
		public var reScale:Boolean = true;
		
		public var useFreemanChain:Boolean = true;
		
		public function Zeez() {
			_loader = new DataLoader();
			_loader.addEventListener(DataLoader.COMPLETE, completeEventHandler);
		}
		
		private function completeEventHandler(event:DynamicEvent):void {
			_recognizer = Recognizer(event.data.recognizer);
			dispatchEvent( ((_recognizer.cases == null) ? new ErrorEvent(ErrorEvent.ERROR):new Event(READY)) );
			_loader.removeEventListener(DataLoader.COMPLETE, completeEventHandler);
		}
		
		/**
		 * 
		 * Use this method as start point after register your listener 
		 */
		public function start():void {
			_loader.load();
		}
		
		/**
		 * It will return Vector of Result class which has character and its score
		 *  
		 * 
		 * @param char see Character class
		 * @param candidateCount
		 * @return 
		 * 
		 */
		public function classify(char:Character, candidateCount:uint = 10):Vector.<Result> {
			var cloned:Character = char.clone();
			if (useFreemanChain)
				cloned.applyFreemanChain();
			if (reScale)
				cloned.rescaleArea();
			return _recognizer.classify(cloned, candidateCount);
		}
		
	}
}