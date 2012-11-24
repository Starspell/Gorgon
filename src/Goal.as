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
		public function Goal( startX:Number, startY:Number ) 
		{
			super( startX, startY );
			
			type = "goal";
			setHitbox(Main.TW, Main.TW);
		}
		
	}

}