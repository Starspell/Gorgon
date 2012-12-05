package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Sarah
	 */
	public class StairsDown extends Entity 
	{
		public function StairsDown( startX:Number, startY:Number ) 
		{
			super( startX, startY );
			
			type = "stairsDown";
			setHitbox(Main.TW, Main.TW);
		}
		
	}

}