package  
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.*;
	
	/**
	 * ...
	 * @author Sarah
	 */
	public class WinScreen extends World 
	{
		[Embed(source = '../assets/sprites/winscreen.png')] private const WIN:Class;
		
		private var winScreen:Entity;
		
		public function WinScreen() 
		{
			winScreen = new Entity(0, 0, new Image(WIN));
			add(winScreen);
		}
		
		override public function update():void
		{
			super.update();
			
			if ( Input.pressed(Key.M) )
			{
				Main.toggleSounds();
			}
			
			if ( Input.pressed(Key.ENTER) || Input.pressed(Key.SPACE) )
			{
				FP.world = new TitleScreen();
			}
		}
	}

}