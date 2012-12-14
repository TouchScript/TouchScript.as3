package
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	import ru.interactivelab.touchscript.TouchManager;
	import ru.interactivelab.touchscript.debugging.TouchDebugger;
	import ru.interactivelab.touchscript.events.gestures.GestureEvent;
	import ru.interactivelab.touchscript.gestures.Gesture;
	import ru.interactivelab.touchscript.gestures.PanGesture;
	import ru.interactivelab.touchscript.gestures.TapGesture;
	import ru.interactivelab.touchscript.inputSources.MouseInput;
	import ru.interactivelab.touchscript.inputSources.TuioInput;
	
	[SWF(frameRate="60", width="1024", height="768")]
	public class TestProject extends Sprite {
		
		private var _mouseInput:MouseInput;
		private var _tuioInput:TuioInput;
		
		public function TestProject() {
			TouchManager.init(stage);
			_mouseInput = new MouseInput(stage);
			_tuioInput = new TuioInput(stage.stageWidth, stage.stageHeight);
			
			var s1:Sprite = getBox(300, 0xFF0000);
			addChild(s1);
			s1.x = s1.y = 50;
			
			var s2:Sprite = getBox(200, 0x00FF00);
			s1.addChild(s2);
			
			var s3:Sprite = getBox(100, 0x0000FF);
			s2.addChild(s3);
			
			var t:TapGesture = new TapGesture(s2);
			t.addEventListener(GestureEvent.STATE_CHANGED, handle_tap);
			t = new TapGesture(s1);
			t.addEventListener(GestureEvent.STATE_CHANGED, handle_tap);
			
			var p:PanGesture = new PanGesture(s2);
			p.addEventListener(GestureEvent.STATE_CHANGED, handle_drag);
			
			addChild(new TouchDebugger());
		}
		
		private function getBox(size:uint, color:uint):Sprite {
			var obj:Sprite = new Sprite();
			obj.graphics.beginFill(color);
			obj.graphics.drawRect(0, 0, size, size);
			obj.name = "box " + size;
			return obj;
		}
		
		private function handle_tap(e:GestureEvent):void {
			if (e.state == Gesture.STATE_RECOGNIZED) {
				trace("TAP", (e.target as Gesture).displayTarget.name);
			}
		}
		
		private function handle_drag(e:GestureEvent):void {
			var target:PanGesture = e.target as PanGesture;
			if (e.state == Gesture.STATE_BEGAN || e.state == Gesture.STATE_CHANGED) {
				var delta:Point = target.localDeltaPosition;
//				trace("DRAGGED", target.displayTarget.name, delta);
				target.displayTarget.x += delta.x;
				target.displayTarget.y += delta.y;
			}
		}
		
	}
}