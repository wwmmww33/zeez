package kwon.dongwook.apps.zeez.models {
	
	import __AS3__.vec.Vector;
	
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class Rescaler {
		
		public static function rescale(char:Character):Vector.<Stroke> {
			var strokes:Vector.<Stroke> = char.strokes;
			var matrix:Matrix = Rescaler.getTransformMatrix(char);
			strokes.forEach(function(stroke:Stroke, strokeIndex:int, vector:Vector.<Stroke>):void {
				stroke.dots.forEach(function(dot:Point, dotIndex:int, points:Vector.<Point>):void {
					points[dotIndex] = matrix.transformPoint(dot);
				});
			});
			return strokes;
		}

		private static function getTransformMatrix(char:Character):Matrix {
			var strokes:Vector.<Stroke> = char.strokes;
			var xs:Vector.<Point> = new Vector.<Point>();
			var ys:Vector.<Point> = new Vector.<Point>();
			
			strokes.forEach(function(stroke:Stroke, strokeIndex:int, vector:Vector.<Stroke>):void {
				xs = xs.concat(stroke.dots);
				ys = ys.concat(stroke.dots);
			});
			
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