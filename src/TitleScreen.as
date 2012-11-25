package  
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.utils.*;
	
	/**
	 * ...
	 * @author Sarah
	 */
	public class TitleScreen extends World 
	{
		[Embed(source = '../assets/sprites/titlescreen.png')] private const TITLE:Class;
		
		private var titleScreen:Entity;
		
		public function TitleScreen() 
		{
			titleScreen = new Entity(0, 0, new Image(TITLE));
			add(titleScreen);
		}
		
		override public function update():void
		{
			super.update();
			
			// Replace with button
			if ( Input.pressed(Key.ENTER) || Input.pressed(Key.SPACE) )
			{
				FP.world = new GameWorld(1);
			}
		}
	}

}