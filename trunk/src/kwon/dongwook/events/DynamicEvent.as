package kwon.dongwook.events {
	
	import flash.events.Event;
	
	public class DynamicEvent extends Event {
		
		public function DynamicEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}
		
		public var data:*;
	}
}