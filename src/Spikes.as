package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	
	/**
	 * ...
	 * @author Sarah
	 */
	public class Spikes extends Entity 
	{
		public function Spikes( startX:Number, startY:Number ) 
		{
			super( startX, startY );
			
			type = "spike";
			setHitbox(Main.TW, Main.TW);
		}
	}

}