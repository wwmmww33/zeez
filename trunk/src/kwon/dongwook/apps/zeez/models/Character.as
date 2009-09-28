package kwon.dongwook.apps.zeez.models {
	
	import __AS3__.vec.Vector;
	
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

		public function applyFreemanChain():void {
			for each(var element:Stroke in _strokes) {
				element.dots = FreemanChain.getChain(element.dots);
			}
		}
		
		public function rescaleArea():void {
			_strokes = Rescaler.rescale(this);
		}
		
		public function clone():Character {
			var cloned:Character = new Character();
			cloned.width = width;
			cloned.height = height;
			for each(var stroke:Stroke in _strokes) {
				cloned.addStroke(stroke.clone());
			}
			return cloned;
		}
		
	}
}