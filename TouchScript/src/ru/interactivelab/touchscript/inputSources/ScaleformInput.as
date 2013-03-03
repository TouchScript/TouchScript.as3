package ru.interactivelab.touchscript.inputSources {
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.external.ExternalInterface;
	import flash.utils.Dictionary;
	
	import ru.interactivelab.touchscript.TouchManager;
	import ru.interactivelab.touchscript.math.Vector2;

	public class ScaleformInput extends InputSource {
		
		private static const ERROR:int = 0;
		private static const HIT:int = 1;
		private static const MISS:int = 2;
		
		private var _stage:Stage;
		private var _cursorToInternalId:Dictionary = new Dictionary();
		
		public function ScaleformInput(stage:Stage) {
			super();
			
			_stage = stage;
		}
		
		public function Scaleform_beginTouch(id:int, x:Number, y:Number):int {
			if (_cursorToInternalId[id] != undefined) return ERROR;
			
			x *= _stage.stageWidth;
			y *= _stage.stageHeight;
			var target:DisplayObject = TouchManager.getHitTarget(x, y);
			if (target && target != _stage) {
				_cursorToInternalId[id] = beginTouch(new Vector2(x, y));
				return HIT;
			}
			return MISS;
		}
		
		public function Scaleform_endTouch(id:int):void {
			if (_cursorToInternalId[id] == undefined) return;
			endTouch(_cursorToInternalId[id]);
			delete _cursorToInternalId[id];
		}
		
		public function Scaleform_moveTouch(id:int, x:Number, y:Number):void {
			if (_cursorToInternalId[id] == undefined) return;
			moveTouch(_cursorToInternalId[id], new Vector2(x * _stage.stageWidth, y * _stage.stageHeight));

		}
		
		public function Scaleform_cancelTouch(id:int):void {
			if (_cursorToInternalId[id] == undefined) return;
			cancelTouch(_cursorToInternalId[id]);
			delete _cursorToInternalId[id];
		}
		
	}
}