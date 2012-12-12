package  
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
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
			
			Text.font = 'My Font';
			Text.size = 8;
			
			var button:Button = new Button("Play", 400, startGame);
			
			button.x = 100;
			button.y = 200;
			
			add(button);
		}
		
		override public function update():void
		{
			Input.mouseCursor = "auto";
			
			super.update();
			
			if ( Input.pressed(Key.M) )
			{
				Main.toggleSounds();
			}
			
			// Replace with button
			if ( Input.pressed(Key.ENTER) || Input.pressed(Key.SPACE) )
			{
				startGame();
			}
		}
		
		public function startGame (): void
		{
			FP.world = new GameWorld(1);
		}
		
		public override function end (): void
		{
			Input.mouseCursor = "auto";
		}
	}

}