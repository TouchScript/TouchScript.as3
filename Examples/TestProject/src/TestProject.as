package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import interfaces.Example1;
	
	import ru.interactivelab.touchscript.TouchManager;
	import ru.interactivelab.touchscript.debugging.TouchDebugger;
	import ru.interactivelab.touchscript.inputSources.MouseInput;
	import ru.interactivelab.touchscript.inputSources.TuioInput;
	
	
	[SWF(frameRate="60", width="1280", height="800")]
	public class TestProject extends Sprite {
		
		private var _mouseInput:MouseInput;
		private var _tuioInput:TuioInput;
		
		public function TestProject() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			TouchManager.init(stage);
			_mouseInput = new MouseInput(stage);
			_tuioInput = new TuioInput(stage.stageWidth, stage.stageHeight);
			
			addChild(new Example1());
			
			addChild(new TouchDebugger());
		}
		
	}
}