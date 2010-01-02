package kwon.dongwook.apps.zeez.models {
	
	import __AS3__.vec.Vector;
	
	import flash.geom.Point;
	
	public class FeatureBuilder {
		
		private const ERROR:Number = 0.001;
		private const MAX_CHARACTER_SIZE:uint = 50;
		
		public var features:Vector.<Feature>;
		
		public function read(char:Character):Boolean {
			var width:Number = char.width;
			var height:Number = char.height;
			
			if (width == 0 || height == 0 || char.strokes.length == 0)
				return false;
			
			features = new Vector.<Feature>();
			// biased
			addFeature(0, 1);
			
			var strokesCount:uint = char.strokes.length;
			var nodes:Vector.<Vector.<Point>> = new Vector.<Vector.<Point>>(strokesCount, true);
		
			for (var strokesOrder:uint = 0; strokesOrder < strokesCount; strokesOrder++) {
				var stroke:Stroke = char.strokes[strokesOrder];
				var dotsCount:uint = stroke.dots.length;
				if (dotsCount == 0)
					return false;
				nodes[strokesOrder] = new Vector.<Point>();
				for (var dotsOrder:uint = 0; dotsOrder < dotsCount; dotsOrder++) {
					nodes[strokesOrder][dotsOrder] = new Point( 
						1.0 * char.strokes[strokesOrder].dots[dotsOrder].x / width,
						1.0 * char.strokes[strokesOrder].dots[dotsOrder].y / height);
				}
			}
			var prev:Point;
			for (strokesOrder = 0; strokesOrder < strokesCount; strokesOrder++) {
				var pairNodes:Array = [];
				var start:uint = 0;
				var end:uint = nodes[strokesOrder].length - 1;
				getVertex(nodes[strokesOrder], start, end, 0, pairNodes);
				makeVertexFeature(strokesOrder, pairNodes);
				if (prev != null) {
					makeMoveFeature(strokesOrder, prev, nodes[strokesOrder][start]);
				}
				prev = nodes[strokesOrder][end];
			}
			
			addFeature(2000000, nodes.length);
			addFeature(2000000 + nodes.length, 10);
	
			features.sort(function(a:Feature, b:Feature):Number {
				return a.index - b.index;
			});
			
			addFeature(-1, 0);
			return true;
		}
		
		private function makeBasicFeature(offset:int, first:Point, last:Point):void {
			// distance
			addFeature(offset + 1, 10 * distance(first, last));
			
			// degree
			addFeature(offset + 2, Math.atan2(last.y - first.y, last.x - first.x));
			
			// absolute position
			addFeature(offset + 3, 10 * (first.x - 0.5));
			addFeature(offset + 4, 10 * (first.y - 0.5));
			addFeature(offset + 5, 10 * (last.x - 0.5));
			addFeature(offset + 6, 10 * (last.y - 0.5));
			
			// absolute degree
			addFeature(offset + 7, Math.atan2(first.y - 0.5, first.x - 0.5));
			addFeature(offset + 8, Math.atan2(last.y - 0.5, last.x - 0.5));
			
			// absolute distance
			addFeature(offset + 9, 10 * distance2(first));
			addFeature(offset + 10, 10 * distance2(last));
			
			// difference
			addFeature(offset + 11, 5 * (last.x - first.x));
			addFeature(offset + 12, 5 * (last.y - first.y));
	
		}
		
		private function distance(first:Point, second:Point):Number {
			var x:Number = first.x - second.x;
			var y:Number = first.y - second.y;
			return Math.sqrt((x * x) + (y * y));
		}
		
		private function distance2(point:Point):Number {
			return distance(point, new Point(0.5, 0.5));
		}
		
		private function makeMoveFeature(index:int, first:Point, last:Point):void {
			makeBasicFeature(100000 + index * 1000, first, last);
		}

		private function makeVertexFeature(index:int, pairNodes:Array):void {
			var count:uint = pairNodes.length;
			for (var i:uint = 0; i < count; i++) {
				if (i > MAX_CHARACTER_SIZE)
					break;
				if (pairNodes[i] == null)
					continue;
				var first:Point = pairNodes[i].first;
				var last:Point = pairNodes[i].last;
				makeBasicFeature((index * 1000 + 20 * i), first, last);
			}
		}
		
		private function getVertex(nodes:Vector.<Point>, start:uint, end:uint, current:uint, pairNodes:Array):Array {
			pairNodes[current] = new PairNode(nodes[start], nodes[end]);
			var bestAndDistance:Object = minimumDistance(nodes, start, end);
			var best:uint = bestAndDistance.best;
			var dist:Number = bestAndDistance.distance;
			if ( dist > ERROR ) {
				getVertex(nodes, start, best, (current * 2) + 1, pairNodes);
				getVertex(nodes, best, end, (current * 2) + 2, pairNodes);
			}
			return pairNodes;
		}
		
		private const PRECISION:Number = 1000000000;
		private function round(value:Number):Number {
			return (Math.abs(value) <= 2) ? Math.round( value * PRECISION ) / PRECISION: value;
		}
		
		private function minimumDistance(nodes:Vector.<Point>, start:uint, end:uint):Object {
			if ( start == end )
				return {best:0, distance:0};
			var first:Point = nodes[start];
			var last:Point = nodes[end];
			var a:Number = round(last.x - first.x);
			var b:Number = round(last.y - first.y);
			var c:Number = round((last.y * first.x) - (last.x * first.y));

			var max:Number = -1.0;
			var best:uint = 0;
			for (var i:uint = start; i < end; i++) {
				var node:Point = nodes[i];
				var dist:Number = Math.abs(a * round(node.y) - b * round(node.x) + c); 
				if (dist > max) {
					max = dist;
					best = i;
				}
			}
			return {best:best, distance:(max * max / (a * a + b * b))};
		}
		
		private function addFeature(index:int, value:Number):void {
			features.push(new Feature(index, value));
		}
	}
}