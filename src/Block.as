package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Sarah
	 */
	public class Block extends Entity 
	{
		[Embed(source = '../assets/sprites/block.png')] private const BLOCK:Class;
		
		public function Block( startX:int, startY:int ) 
		{
			super( startX, startY, new Image(BLOCK) );
			
			type = "block";
			setHitbox(Main.TW, Main.TW);
		}
		
		public function breakBlock():void
		{
			
		}
	}

}