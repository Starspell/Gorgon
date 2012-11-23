package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Sarah
	 */
	public class Wall extends Entity 
	{
		[Embed(source = '../assets/sprites/wall.png')] private const WALL:Class;
		
		public function Wall( startX:Number, startY:Number ) 
		{
			super( startX, startY, new Image(WALL) );

			setHitbox(Main.TW, Main.TW);
			type = "wall";
		}
		
	}

}