package test {
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flexunit.textui.TestRunner;

	public class Runner extends Sprite {
		
		public function Runner() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, addedToStageEventHandler);
		}
		
		private function addedToStageEventHandler(event:Event):void {
			runTest();
		}
		
		private function runTest():void {
			TestRunner.run(new FreemanChainTest(), function() {
				trace("============= Test is done; =========");
			});
		}
		
	}
}