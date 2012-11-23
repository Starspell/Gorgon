package
{
	import net.flashpunk.*;
	
	/**
	 * ...
	 * @author Sarah
	 */
	[SWF(width = "640", height = "480", backgroundColor="#000000")]
	public class Main extends Engine
	{
		public static var TW:int = 16;
		
		public function Main()
		{
			super(320, 240, 60, false);
			FP.screen.scale = 2;
			FP.console.enable();
		}
		
		public override function init ():void
		{
			Editor.init();
			CopyPaste.init(stage, pasteCallback);
			FP.world = new GameWorld();
		}
		
		public function pasteCallback (data:String): void
		{
			
		}
	}
}