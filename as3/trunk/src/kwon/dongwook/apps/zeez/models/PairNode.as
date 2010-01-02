package kwon.dongwook.apps.zeez.models {
	
	import flash.geom.Point;
	
	public class PairNode {
		
		public var first:Point;
		public var last:Point;
		
		public function PairNode(first:Point = null, last:Point = null) {
			if (first != null)
				this.first = first;
			if (last != null)
				this.last = last;
		}
		
	}
}