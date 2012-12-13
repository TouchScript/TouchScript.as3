package ru.interactivelab.touchscript {
	import ru.interactivelab.touchscript.gestures.Gesture;

	public interface IGestureDelegate {
		function shouldReceiveTouch(gesture:Gesture, touch:TouchPoint):Boolean;
		function shouldBegin(gesture:Gesture):Boolean;
		function shouldRecognizeSimultaneously(first:Gesture, second:Gesture):Boolean;
	}
}