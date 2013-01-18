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