package ru.interactivelab.touchscript.debugging
{
	import flash.display.Sprite;
	
	internal class TouchDummy extends Sprite {
		
		public function TouchDummy() {
			super();
			redraw();
		}
		
		//--------------------------------------------------------------------------
		//
		// Private functions
		//
		//--------------------------------------------------------------------------
		
		private function redraw():void {
			graphics.lineStyle(2, 0xFFFFFF);
			graphics.beginFill(0x000000);
			graphics.drawCircle(0, 0, 20);
			graphics.endFill();
		}
		
	}
}