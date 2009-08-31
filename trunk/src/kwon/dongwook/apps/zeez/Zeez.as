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
	
	public class Zeez extends EventDispatcher {
		
		public static const READY:String = "ready";
		[Event(name="ready", type="flash.events.Event")]
		
		public static const ERROR:String = ErrorEvent.ERROR;
		[Event(name="error", type="flash.events.ErrorEvent")]

		
		private var _recognizer:Recognizer;
		private var _loader:DataLoader;
		
		
		/**
		 * It rescales area of strokes for better results. Basically what it tries to do is removing margin around strokes
		 * which means your training data must not include margin around character.
		 * So if you're planning using other model data like Zinnia-Tomoe data, you must set this false.
		 * 
		 */
		public var reScale:Boolean = true;
		
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
			if (reScale)
				char = scaleArea(char);
			return _recognizer.classify(char, candidateCount);
		}
		
		private function scaleArea(char:Character):Character {
			var strokes:Vector.<Stroke> = char.strokes;
			var matrix:Matrix = getTransformMatrix(char);
			strokes.forEach(function(stroke:Stroke, strokeIndex:int, vector:Vector.<Stroke>):void {
				stroke.dots.forEach(function(dot:Point, dotIndex:int, points:Vector.<Point>):void {
					points[dotIndex] = matrix.transformPoint(dot);
				}, this);
			}, this);
			return char;
		}
		
		private function getTransformMatrix(char:Character):Matrix {
			var strokes:Vector.<Stroke> = char.strokes;
			var xs:Vector.<Point> = new Vector.<Point>();
			var ys:Vector.<Point> = new Vector.<Point>();
			
			strokes.forEach(function(stroke:Stroke, strokeIndex:int, vector:Vector.<Stroke>):void {
				xs = xs.concat(stroke.dots);
				ys = ys.concat(stroke.dots);
			}, this);
			
			xs.sort(function(p1:Point, p2:Point):Number {
				return p2.x - p1.x;
			});
			ys.sort(function(p1:Point, p2:Point):Number {
				return p2.y - p1.y;
			});
			
			var border:uint = 1;
			var margin:uint = border * 2;
						
			var ox:Number = xs[xs.length-1].x;
			var oy:Number = ys[ys.length-1].y;
			var dx:Number = Math.abs(xs[0].x - ox + margin);
			var dy:Number = Math.abs(ys[0].y - oy + margin);
			var sx:Number = (char.width - margin) / dx;
			var sy:Number = (char.height - margin) / dy;
			
			var scaleFactor:Number = 1;
			if ( (sx - sy) >= 0 ) {
				scaleFactor = sy;
				ox -= (((char.width - margin - (dx*scaleFactor))/2)/scaleFactor);
				oy -= (border/scaleFactor);
			} else {
				scaleFactor = sx;
				oy -= (((char.height - margin - (dy*scaleFactor))/2)/scaleFactor);
				ox -= (border/scaleFactor);
			}
			return new Matrix(scaleFactor, 0, 0, scaleFactor, -(ox*scaleFactor), -(oy*scaleFactor));
		}

		
	}
}