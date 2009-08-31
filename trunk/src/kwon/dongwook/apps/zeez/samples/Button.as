package kwon.dongwook.apps.zeez.samples {
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class Button extends Sprite {
		
		private var _label:TextField;
		
		public function Button() {
			super();
			_label = new TextField();
			_label.text = " clear ";
			_label.autoSize = "left";
			_label.border = true;
			_label.selectable = false;
			addChild(_label);
			this.graphics.beginFill(0xFFFFFF);
			this.graphics.drawRect(0, 0, _label.width, _label.height);
			this.graphics.endFill();
		}
		
	}
}