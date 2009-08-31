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