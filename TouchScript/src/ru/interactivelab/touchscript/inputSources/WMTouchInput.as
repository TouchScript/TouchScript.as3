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
package ru.interactivelab.touchscript.inputSources {
	import flash.display.Stage;
	import flash.events.TouchEvent;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Dictionary;
	
	import ru.interactivelab.touchscript.math.Vector2;

	public class WMTouchInput extends InputSource {
		
		private var _stage:Stage;
		private var _cursorToInternalId:Dictionary = new Dictionary();
		
		public function WMTouchInput(stage:Stage) {
			super();
			_stage = stage;
			
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			_stage.addEventListener(TouchEvent.TOUCH_BEGIN, handler_touchBegin);
			_stage.addEventListener(TouchEvent.TOUCH_END, handler_touchEnd);
			_stage.addEventListener(TouchEvent.TOUCH_MOVE, handler_touchMove);
		}
		
		private function handler_touchBegin(event:TouchEvent):void {
			if (_cursorToInternalId[event.touchPointID] != undefined) return;
			_cursorToInternalId[event.touchPointID] = beginTouch(new Vector2(event.stageX, event.stageY));
		}
		
		private function handler_touchEnd(event:TouchEvent):void {
			if (_cursorToInternalId[event.touchPointID] == undefined) return;
			endTouch(_cursorToInternalId[event.touchPointID]);
			delete _cursorToInternalId[event.touchPointID];
		}
		
		private function handler_touchMove(event:TouchEvent):void {
			if (_cursorToInternalId[event.touchPointID] == undefined) return;
			moveTouch(_cursorToInternalId[event.touchPointID], new Vector2(event.stageX, event.stageY));

		}
	}
}