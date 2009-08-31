package kwon.dongwook.apps.zeez.samples {
	
	import __AS3__.vec.Vector;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import kwon.dongwook.apps.zeez.models.Stroke;
	import kwon.dongwook.events.DynamicEvent;

	public class TouchScreen extends Sprite {
		
		public static const DRAWN:String = "drawn";
		[Event(name="drawn", type="kwon.dongwook.events.DynamicEvent")]
		
		private var _strokes:Vector.<Stroke>;
		private var _canvas:Sprite;
		private var _isDrawing:Boolean = false;
		private var _strokeIndex:uint = 0;
		private var _reducer:Number = 1;
		
		public function TouchScreen() {
			super();
			createChildren();
		}
		
		private function createChildren():void {
			var bg:Sprite = new Sprite();
			bg.graphics.clear();
			bg.graphics.beginFill(0x999999);
			bg.graphics.drawRect(0, 0, 300, 300);
			bg.addEventListener(MouseEvent.MOUSE_DOWN, pressMouseEventHandler);
			bg.addEventListener(MouseEvent.MOUSE_MOVE, moveMouseEventHandler);
			bg.addEventListener(MouseEvent.MOUSE_UP, releaseMouseEventHandler);
			addChild(bg);
			_canvas = new Sprite();
			_canvas.addEventListener(MouseEvent.MOUSE_UP, releaseMouseEventHandler);
			addChild(_canvas);
			clear();
		}
	
		public function clear():void {
			_strokeIndex = 0;
			_canvas.graphics.clear();
			_isDrawing = false;
			_strokes = new Vector.<Stroke>();
		}
		
		private function pressMouseEventHandler(e:MouseEvent):void {
			if (!_isDrawing) {
				_reducer = 1;
				_canvas.graphics.lineStyle(1, 0);
				_canvas.graphics.moveTo(e.localX, e.localY);
				var stroke:Stroke = new Stroke(_strokeIndex);
				stroke.dots.push(new Point(e.localX, e.localY));
				_isDrawing = true;
				_strokes.push(stroke);
			}
		}
		
		private function moveMouseEventHandler(e:MouseEvent):void {
			if (_isDrawing && (_reducer % 5) == 0) {
				_canvas.graphics.lineTo(e.localX, e.localY);
				_strokes[_strokeIndex].dots.push(new Point(e.localX, e.localY));
			}
			_reducer++;
		}
		
		private function releaseMouseEventHandler(e:MouseEvent):void {
			if (_isDrawing) {
				var event:DynamicEvent = new DynamicEvent(DRAWN);
				event.data = {strokes:_strokes.concat()};
				dispatchEvent(event);
				_isDrawing = false;
				_strokeIndex++;
			}
		}
		
	}
}