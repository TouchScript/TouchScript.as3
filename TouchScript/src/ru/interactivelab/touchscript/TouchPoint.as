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
package ru.interactivelab.touchscript {
	import flash.display.InteractiveObject;
	
	import ru.interactivelab.touchscript.math.Vector2;
	
	use namespace touch_internal;
	
	public class TouchPoint {
		
		touch_internal var $id:int;
		touch_internal var $position:Vector2;
		touch_internal var $previousPosition:Vector2;
		touch_internal var $target:InteractiveObject;
		
		public function get id():int {
			return $id;
		}
		
		public function get position():Vector2 {
			return $position;
		}
		
		public function set position(value:Vector2):void {
			$previousPosition = $position;
			$position = value;
		}
		
		public function get previousPosition():Vector2 {
			return $previousPosition;
		}
		
		public function get target():InteractiveObject {
			return $target;
		}
		
		public function TouchPoint(id:int, position:Vector2) {
			$id = id;
			$position = position;
			$previousPosition = position;
		}
	}
}