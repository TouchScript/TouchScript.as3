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
package ru.interactivelab.touchscript.gestures {
	import flash.display.InteractiveObject;
	
	public class PressGesture extends Gesture {
		public function PressGesture(target:InteractiveObject, ...params) {
			super(target, params);
		}
		
		public override function canPreventGesture(gesture:Gesture):Boolean {
			if (delegate == null) return false;
			return delegate.shouldRecognizeSimultaneously(this, gesture);
		}
		
		public override function canBePreventedByGesture(gesture:Gesture):Boolean {
			if (delegate == null) return false;
			return !delegate.shouldRecognizeSimultaneously(this, gesture);
		}
		
		protected override function touchesBegan(touches:Array):void {
			if (_activeTouches.length == touches.length) setState(GestureState.RECOGNIZED);
		}
		
	}
}