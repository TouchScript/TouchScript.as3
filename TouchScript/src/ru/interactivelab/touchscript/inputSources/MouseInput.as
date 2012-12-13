package ru.interactivelab.touchscript.inputSources
{
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.geom.Point;

	public class MouseInput extends InputSource {
		
		private var _stage:Stage;
		private var _mousePointId:int = -1;
		
		public function MouseInput(stage:Stage) {
			super();
			_stage = stage;
			
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, handler_mouseDown);
			_stage.addEventListener(MouseEvent.MOUSE_UP, handler_mouseUp);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, handler_mouseMove);
		}
		
		private function handler_mouseDown(event:MouseEvent):void {
			_mousePointId = beginTouch(new Point(event.stageX, event.stageY));
		}
		
		private function handler_mouseUp(event:MouseEvent):void {
			if (_mousePointId == -1) return;
			endTouch(_mousePointId);
			_mousePointId = -1;
		}
		
		private function handler_mouseMove(event:MouseEvent):void {
			if (_mousePointId == -1) return;
			moveTouch(_mousePointId, new Point(event.stageX, event.stageY));
		}
		
	}
}