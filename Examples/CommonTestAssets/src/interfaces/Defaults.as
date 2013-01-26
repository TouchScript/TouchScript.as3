package interfaces {
	public class Defaults {
		public static const MAIN_WINDOW_PADDING:int = 20;
		
		public static function randomColor():uint {
			return 	((Math.random() * 0x80 + 0x80) << 16 ) +
				((Math.random() * 0x80 + 0x80) << 8 ) +
				(Math.random() * 0x80 + 0x80);
		}
		
	}
}