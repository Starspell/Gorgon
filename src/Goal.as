package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Sarah
	 */
	public class Goal extends Entity 
	{
		[Embed(source = '../assets/sprites/goal.png')] private const GOAL:Class;
		
		public function Goal( startX:Number, startY:Number ) 
		{
			super( startX, startY, new Image(GOAL) );
			
			type = "goal";
			setHitbox(Main.TW, Main.TW);
		}
		
	}

}