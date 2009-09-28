package kwon.dongwook.apps.zeez.models {
	
	import __AS3__.vec.Vector;
	
	import flash.geom.Point;
	
	
	public class Stroke {
		
		public var index:uint = 0;
		public var dots:Vector.<Point>;
		
		public function Stroke(index:uint = 0) {
			this.index = index;
			dots = new Vector.<Point>();
		}

		public function clone():Stroke {
			var cloned:Stroke = new Stroke(this.index);
			for each(var dot:Point in dots) {
				cloned.dots.push(new Point(dot.x, dot.y));
			}
			return cloned;
		}
		
		public function toString():String {
			if (dots == null)
				return "null";
			var exp:String = "(";
			dots.forEach(function(dot:Point, index:int, v:Vector.<Point>):void {
				exp += "(" + dot.x + " " + dot.y + ")"; 
			}, this);
			return exp + ")";
		}
	}
}