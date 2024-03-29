package
{
	import net.flashpunk.*;
	import net.flashpunk.utils.*;
	
	import flash.net.*;
	
	[SWF(width = "640", height = "480", backgroundColor="#000000")]
	public class Main extends Engine
	{
		[Embed(source = '../assets/audio/AA.mp3')] private static const MUSIC:Class;
		
		private static const shakeMag:Number = 3;
		private const shakeInterval:Number = 1;
		
		private static var shakeScreen:Boolean = false;
		private static var shakeTimer:Number = 0;
		private static var currentShake:Number = 0;
		
		private static var cameraX:Number;
		private static var cameraY:Number;
		
		private static var music:Sfx = new Sfx(MUSIC);
		
		private var editor:Editor;
		
		public static var TW:int = 16;
		
		public static var devMode:Boolean = true;
		public static var honourMode:Boolean = true;
		public static const so:SharedObject = SharedObject.getLocal("draknek/gorgon", "/");
		
		public static var mute:Boolean = false;
		
		public function Main()
		{
			super(320, 240, 60, true);
			FP.screen.scale = 2;
			FP.screen.color = 0x909090;
			if ( devMode )
			{
				FP.console.enable();
			}
			FP.console.toggleKey = Key.F1;
		}
		
		public override function init ():void
		{
			LevelList.init();
			Editor.init();
			if (devMode) {
				CopyPaste.init(stage, pasteCallback);
			}
			FP.world = new TitleScreen();
			
			music.loop();
			music.volume = 0.5;
		}
		
		public override function update ():void
		{
			Input.mouseCursor = "hide";
		
			if ( shakeScreen )
			{
				shakeTimer += FP.elapsed;
				
				if ( shakeTimer < shakeInterval )
				{
					currentShake = ( (shakeInterval - shakeTimer) / shakeInterval ) * shakeMag;
					currentShake = int( currentShake );
					
					var rand:Number = Math.random();
					
					if ( rand < 0.25 ) 		FP.camera.x = cameraX - currentShake;
					else if ( rand < 0.5 ) 	FP.camera.x = cameraX + currentShake;
					else if ( rand < 0.75 ) FP.camera.y = cameraY - currentShake;
					else if ( rand < 1.0 )	FP.camera.y = cameraX + currentShake;
				}
				else
				{
					shakeScreen = false;
					FP.camera.x = cameraX;
					FP.camera.y = cameraY;
				}
			}
			
			super.update();
		}
		
		public function pasteCallback (data:String): void
		{
			
		}
		
		public static function startScreenShake():void
		{
			shakeScreen = true;
			shakeTimer = 0;
			currentShake = shakeMag;
			
			cameraX = FP.camera.x;
			cameraY = FP.camera.y;
		}
		
		public static function toggleSounds():void
		{
			mute = !mute;
			
			if ( music.playing )
			{
				music.stop();
			}
			else
			{
				music.loop();
			}
		}
	}
}