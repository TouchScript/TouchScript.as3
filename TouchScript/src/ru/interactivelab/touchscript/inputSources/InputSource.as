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
	import flash.geom.Point;
	
	import ru.interactivelab.touchscript.TouchManager;

	public class InputSource {
		public function InputSource() {}
		
		public var coordinatesRemapper:ICoordinatesRemapper;
		
		protected function beginTouch(position:Point):int {
			if (coordinatesRemapper != null) position = coordinatesRemapper.remap(position);
			return TouchManager.beginTouch(position);
		}
		
		protected function endTouch(id:int):void {
			TouchManager.endTouch(id);
		}
		
		protected function moveTouch(id:int, position:Point):void {
			if (coordinatesRemapper != null) position = coordinatesRemapper.remap(position);
			TouchManager.moveTouch(id, position);
		}
		
		protected function cancelTouch(id:int):void {
			TouchManager.cancelTouch(id);
		}
	}
}