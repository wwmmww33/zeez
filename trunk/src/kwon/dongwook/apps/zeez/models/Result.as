package kwon.dongwook.apps.zeez.models {
	
	public class Result {
		
		public var character:String;
		public var score:Number;
		
		public function Result(score:Number = -1, character:String = null) {
			this.score = score;
			if (character != null)
				this.character = character;
		}
		
		public function toString():String {
			return "score :" + score + ", character :" + character + "\n";
		}
		
		public function clone():Result {
			return new Result(score, character);
		}
	}
}