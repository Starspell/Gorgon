package
{
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	
	import flash.net.*;
	
	[SWF(width = "640", height = "480", backgroundColor="#000000")]
	public class Main extends Engine
	{
		public static var TW:int = 16;
		
		public static var devMode:Boolean = true;
		
		private var editor:Editor;
		
		public static const so:SharedObject = SharedObject.getLocal("draknek/gorgon", "/");
		
		public function Main()
		{
			super(320, 240, 60, true);
			FP.screen.scale = 2;
			FP.console.enable();
			FP.console.toggleKey = Key.F1;
		}
		
		public override function init ():void
		{
			LevelList.init();
			Editor.init();
			CopyPaste.init(stage, pasteCallback);
			FP.world = new GameWorld(1);
		}
		
		public override function update ():void
		{
			Input.mouseCursor = "hide";
			super.update();
		}
		
		public function pasteCallback (data:String): void
		{
			
		}
	}
}