/*
* Copyright (C) 2013 Interactive Lab
* 
* Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation 
* files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, 
* modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the 
* Software is furnished to do so, subject to the following conditions:
* The above copyright notice and this permission notice shall be included in all copies or substantial portions of the 
* Software.
* 
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE 
* WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR 
* COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
* OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
package ru.interactivelab.touchscript.debugging {
	import flash.display.Sprite;
	import flash.events.Event;
	
	import ru.interactivelab.touchscript.TouchManager;
	import ru.interactivelab.touchscript.TouchPoint;
	import ru.interactivelab.touchscript.events.TouchManagerEvent;
	import ru.interactivelab.touchscript.touch_internal;
	
	use namespace touch_internal;
	
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
				this._touchPoints[touch.$id] = dummy;
				this._touchPointsContainer.addChild(dummy);
				
				dummy.mouseEnabled = false;
				dummy.x = touch.$position.$x;
				dummy.y = touch.$position.$y;
			}
		}
		
		private function handler_updated(event:TouchManagerEvent):void {
			for each (var touch:TouchPoint in event.touchPoints) {
				var dummy:TouchDummy = this._touchPoints[touch.$id];
				if (!dummy) return;
				dummy.x = touch.$position.$x;
				dummy.y = touch.$position.$y;
			}
		}
		
		private function handler_removed(event:TouchManagerEvent):void {
			for each (var touch:TouchPoint in event.touchPoints) {
				var dummy:TouchDummy = this._touchPoints[touch.$id];
				delete this._touchPoints[touch.$id];
				if (!dummy) return;
				this._touchPointsContainer.removeChild(dummy);
			}
		}
		
	}
}

import flash.display.Sprite;

internal class TouchDummy extends Sprite {
	
	public function TouchDummy() {
		super();
		redraw();
	}
	
	private function redraw():void {
		graphics.lineStyle(2, 0xFFFFFF);
		graphics.beginFill(0x000000);
		graphics.drawCircle(0, 0, 20);
		graphics.endFill();
	}
	
}