package kwon.dongwook.apps.zeez.models {
	
	import flash.geom.Point;
	
	public class FreemanChain {
		
		private const DIRECTION:Array = [0, 1, 2, 2, 3, 4, 4, 5, 6, 6, 7, 0];
		private const PIECE:Number = Math.PI/6;
		private static var _instance:FreemanChain;
		
		public static function getChain(points:Vector.<Point>):Vector.<Point> {
			if (_instance == null)
				_instance = new FreemanChain();
			var chain:Vector.<int> = new Vector.<int>(points.length-1, true);
			var length:int = chain.length;
			points.forEach(function(element:Point, index:int, dots:Vector.<Point>):void {
				if (index < length) {
					chain[index] = _instance.getFreemanDirection(element, dots[index+1]);
				}
			});
			var shortened:Vector.<Point> = new Vector.<Point>();
			shortened.push(points[0]);
			var currentDir:int = chain[0];
			chain.forEach(function(dir:int, index:int, dirs:Vector.<int>):void {
				if (currentDir != dir) {
					if (shortened[shortened.length-1] != points[index])
						shortened.push(points[index]);
					shortened.push(points[index + 1]);
					currentDir = dir;
				} else if (index == length-1) {
					shortened.push(points[index + 1]);
				}
			});
			return shortened;
		}
		
		private function getFreemanDirection(dot1:Point, dot2:Point):int {
			var direction:int = 0;
			var angle:Number = angleFromOrigin(dot1, dot2);
			var index:int = Math.floor(angle / PIECE);
			return DIRECTION[index];
		}
		
		private function angleFromOrigin(dot1:Point, dot2:Point):Number {
			var vector:Point = new Point(dot2.x - dot1.x, dot2.y - dot1.y);
			var acos:Number = Math.acos(vector.y / getLength(vector));
			if (vector.x < 0)
				acos = (2 * Math.PI) - acos;
			return acos;
		}
		
		private function getLength(vector:Point):Number {
			return Math.abs(Math.sqrt(Math.pow(Math.abs(vector.x), 2) + Math.pow(Math.abs(vector.y), 2)));
		}
		
	}
}