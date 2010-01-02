package test {
	
	import __AS3__.vec.Vector;
	
	import flash.geom.Point;
	
	import flexunit.framework.TestCase;
	
	import kwon.dongwook.apps.zeez.models.FreemanChain;

	public class FreemanChainTest extends TestCase {
		
		private var _chain:FreemanChain;
		private var _count:uint = 0;
		
		public function FreemanChainTest(methodName:String=null) {
			super(methodName || "testFreeman");
		}
		
		public function testFreeman():void {
			_chain = new FreemanChain();
			checkDirection(new Point(0, 0), new Point(0, 1), 0);
			checkDirection(new Point(0, 0), new Point(1, 0), 2);
			checkDirection(new Point(5, 3), new Point(5, 4), 0);
			checkDirection(new Point(322, 455), new Point(323, 455), 2);
			checkDirection(new Point(59, 32), new Point(59, 340), 0);
			checkDirection(new Point(569, 237), new Point(1071, 237), 2);
			checkDirection(new Point(0, 0), new Point(1, 1), 1);
			checkDirection(new Point(0, 0), new Point(1, -1), 3);
			checkDirection(new Point(0, 0), new Point(0, -1), 4);
			checkDirection(new Point(0, 0), new Point(-1, -1), 5);
			checkDirection(new Point(0, 0), new Point(-1, 0), 6);
			checkDirection(new Point(0, 0), new Point(-1, 1), 7);
			
			checkDirection(new Point(0, 0), new Point(0.096, 2), 0);
			checkDirection(new Point(0, 0), new Point(2, 0.96), 1);
			
			var points:Vector.<Point> = new Vector.<Point>();
			points.push(new Point(39, 22));
			points.push(new Point(121, 21));
			points.push(new Point(188, 20));
			points.push(new Point(216, 20));
			points.push(new Point(228, 20));
			points.push(new Point(242, 20));
			points.push(new Point(247, 20));
			points.push(new Point(256, 20));
			points.push(new Point(256, 48));
			points.push(new Point(251, 126));
			points.push(new Point(250, 178));
			points.push(new Point(248, 206));
			points.push(new Point(247, 216));
			points.push(new Point(247, 233));
			points.push(new Point(247, 257));
			points.push(new Point(246, 264));
			points.push(new Point(227, 266));
			points.push(new Point(123, 265));
			points.push(new Point(98, 265));
			points.push(new Point(70, 266));
			points.push(new Point(48, 267));
			points.push(new Point(39, 267));
			points.push(new Point(34, 266));
			points.push(new Point(34, 237));
			points.push(new Point(47, 122));
			points.push(new Point(53, 55));
			points.push(new Point(53, 38));
			
			
			var freeman:Vector.<Point> = FreemanChain.getChain(points);
			assertEquals("length should be 3:", 8, freeman.length);
		}
		
		private function checkDirection(dot1:Point, dot2:Point, expectation:Number):void {
			var dir:Number = _chain.getFreemanDirection(dot1, dot2);
			assertEquals(_count + ">> Direction should be " + expectation, expectation, dir);
			_count++;
		}
		
	}
}