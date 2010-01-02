package kwon.dongwook.apps.zeez.models {
	
	public class Feature {
		
		public var index:int;
		public var value:Number;
		
		public function Feature(index:int = 0, value:Number = 1) {
			this.index = index;
			this.value = value;
		}
		
		public function toString():String {
			return "index[" + index + "]:" + value + "\n";
		}
	}
}