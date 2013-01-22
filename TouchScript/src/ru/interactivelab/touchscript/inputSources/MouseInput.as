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