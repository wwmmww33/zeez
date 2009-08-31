package kwon.dongwook.apps.zeez.models {
	
	import __AS3__.vec.Vector;
	
	import flash.geom.Point;
	import kwon.dongwook.apps.zeez.models.Stroke;
	
	public class Character {
		
		private var _strokes:Vector.<Stroke>;
		public function get strokes():Vector.<Stroke> { return _strokes; }
		
		public var width:Number;
		public var height:Number;
		
		public function Character() {
			_strokes = new Vector.<Stroke>();
		}
				
		public function addStroke(stroke:Stroke):void {
			_strokes.push(stroke);
		}
		
		public function addStrokes(strokes:Vector.<Stroke>):void {
			_strokes = _strokes.concat(strokes);
		}

	}
}