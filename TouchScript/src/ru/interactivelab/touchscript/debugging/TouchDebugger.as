package ru.interactivelab.touchscript.debugging
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import ru.interactivelab.touchscript.TouchManager;
	import ru.interactivelab.touchscript.TouchPoint;
	import ru.interactivelab.touchscript.events.TouchManagerEvent;
	
	public class TouchDebugger extends Sprite {
		
		//--------------------------------------------------------------------------
		//
		// Private variables
		//
		//--------------------------------------------------------------------------
		
		private const _touchPoints:Object = {};
		private var _touchPointsContainer:Sprite;
		
		public function TouchDebugger() {
			super();
			
			mouseEnabled = false;
			mouseChildren = false;
			
			_touchPointsContainer = new Sprite();
			_touchPointsContainer.mouseEnabled = false;
			addChild(_touchPointsContainer );
			
			addEventListener(Event.ADDED_TO_STAGE, handler_addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, handler_removedFromStage);
		}
		
		//--------------------------------------------------------------------------
		//
		// Private functions
		//
		//--------------------------------------------------------------------------
		
		private function activate():void {
			TouchManager.addEventListener(TouchManagerEvent.TOUCH_POINTS_ADDED, handler_added);
			TouchManager.addEventListener(TouchManagerEvent.TOUCH_POINTS_UPDATED, handler_updated);
			TouchManager.addEventListener(TouchManagerEvent.TOUCH_POINTS_REMOVED, handler_removed);
			TouchManager.addEventListener(TouchManagerEvent.TOUCH_POINTS_CANCELLED, handler_removed);
		}
		
		private function deactivate():void {
			TouchManager.removeEventListener(TouchManagerEvent.TOUCH_POINTS_ADDED, handler_added);
			TouchManager.removeEventListener(TouchManagerEvent.TOUCH_POINTS_UPDATED, handler_updated);
			TouchManager.removeEventListener(TouchManagerEvent.TOUCH_POINTS_REMOVED, handler_removed);
			TouchManager.removeEventListener(TouchManagerEvent.TOUCH_POINTS_CANCELLED, handler_removed);
		}
		
		//--------------------------------------------------------------------------
		//
		// Event handlers
		//
		//--------------------------------------------------------------------------
		
		private function handler_addedToStage(event:Event):void {
			activate();
		}
		
		private function handler_removedFromStage(event:Event):void {
			deactivate();
		}
		
		private function handler_added(event:TouchManagerEvent):void {
			for each (var touch:TouchPoint in event.touchPoints) {
				var dummy:TouchDummy = new TouchDummy();
				this._touchPoints[touch.id] = dummy;
				this._touchPointsContainer.addChild(dummy);
				
				dummy.mouseEnabled = false;
				dummy.x = touch.position.x;
				dummy.y = touch.position.y;
			}
		}
		
		private function handler_updated(event:TouchManagerEvent):void {
			for each (var touch:TouchPoint in event.touchPoints) {
				var dummy:TouchDummy = this._touchPoints[touch.id];
				if (!dummy) return;
				dummy.x = touch.position.x;
				dummy.y = touch.position.y;
			}
		}
		
		private function handler_removed(event:TouchManagerEvent):void {
			for each (var touch:TouchPoint in event.touchPoints) {
				var dummy:TouchDummy = this._touchPoints[touch.id];
				delete this._touchPoints[touch.id];
				if (!dummy) return;
				this._touchPointsContainer.removeChild(dummy);
			}
		}
		
	}
}