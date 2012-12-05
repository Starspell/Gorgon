package  
{
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author Sarah
	 */
	public class StairsUp extends Entity 
	{
		
		public function StairsUp( startX:Number, startY:Number ) 
		{
			super( startX, startY );
			
			type = "stairsUp";
			setHitbox(Main.TW, Main.TW);
		}
		
	}

}