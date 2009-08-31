package kwon.dongwook.apps.zeez.samples{
	
	import __AS3__.vec.Vector;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
	
	import kwon.dongwook.apps.zeez.Zeez;
	import kwon.dongwook.apps.zeez.models.Character;
	import kwon.dongwook.apps.zeez.models.Result;
	import kwon.dongwook.apps.zeez.models.Stroke;
	import kwon.dongwook.events.DynamicEvent;
	import kwon.dongwook.log.TimeRecorder;

	public class ZeezSample extends Sprite {
		
		private var _zeez:Zeez;
		private var _message:TextField;
		private var _screen:TouchScreen;
		private var _button:Button;
		private var _result:TextField;
		private var _explain:TextField;
		
		private var _debug:Boolean = true;
		
		public function ZeezSample() {
			createChild();
			createModel();
		}
		
		private function createChild():void {
			_screen = new TouchScreen();
			_screen.x = _screen.y = 10;
			_screen.addEventListener(TouchScreen.DRAWN, drawnCharacterEventHandler);
			addChild(_screen);
			
			_button = new Button();
			_button.x = _screen.x + _screen.width + 20;
			_button.y = _screen.y + _screen.height - 30;
			_button.addEventListener(MouseEvent.CLICK, clickClearEventHandler);
			addChild(_button);
			
			_result = new TextField();
			_result.x = _screen.x + _screen.width + 70;
			_result.y = 10;
			_result.width = 160;
			_result.height = 290;
			_result.border = true;
			addChild(_result);
			
			_message = new TextField();
			_message.width = 200;
			_message.text = "Data load studied data...";
			_message.x = 175;
			_message.y = 190;
			addChild(_message);
			
			_explain = new TextField();
			_explain.width = 380;
			_explain.height = 60;
			_explain.x = 10;
			_explain.y = 340;
			_explain.text = "0 1 2 3 4 5 6 7 8 9 V X ㅁ ∆ - O ^ are contained in handwriting-basic.model.\n # means a Rectangle.";
			addChild(_explain);
		}
		
		private function createModel():void {
			_zeez = new Zeez();
			_zeez.addEventListener(Zeez.READY, readyZeezEventHandler);
			var timer:Timer = new Timer(200, 1);
			timer.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {
				_zeez.start();
			}, false, 0, true);
			timer.start();
		}
		
		private function clickClearEventHandler(e:MouseEvent):void {
			_screen.clear();
			_result.text = "";
		}
		
		private function readyZeezEventHandler(e:Event):void {
			_zeez.removeEventListener(Zeez.READY, readyZeezEventHandler);
			_message.visible = false;
		}
		
		private function drawnCharacterEventHandler(e:DynamicEvent):void {
			var strokes:Vector.<Stroke> = Vector.<Stroke>(e.data.strokes);
			var char:Character = new Character();
			char.width = _screen.width;
			char.height = _screen.height;
			char.addStrokes(strokes);
			TimeRecorder.start("Start find matches");
			var results:Vector.<Result> = _zeez.classify(char, 10);
			TimeRecorder.end("End finding");
			displayResults(results);
		}
		
		private function displayResults(results:Vector.<Result>):void {
			_result.text = "------- results -------------\n";
			trace(" ---------- results ---------------------");
			for (var i:uint = 0; i < results.length; i++) {
				var result:String = " " + (i+1) + "'s :" + Result(results[i]).character + ", score:" + results[i].score 
				trace(result);
				_result.appendText(result + "\n");
			}
		}
	}
}
