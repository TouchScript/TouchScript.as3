package ru.interactivelab.touchscript.gestures {
	import flash.display.InteractiveObject;
	
	public class ReleaseGesture extends Gesture {
		public function ReleaseGesture(target:InteractiveObject, ...params) {
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
		
		protected override function touchesEnded(touches:Array):void {
			if (_activeTouches.length == 0) setState(GestureState.RECOGNIZED);
		}
		
	}
}