package  
{
	import net.flashpunk.Entity;
	
	/**
	 * ...
	 * @author Sarah
	 */
	public class Spikes extends Entity 
	{
		[Embed(source = '../assets/sprites/spikes.png')] private const SPIKE:Class;
		
		public function Spikes( startX:Number, startY:Number ) 
		{
			super( startX, startY );
			
			type = "spike";
			setHitbox(Main.TW, Main.TW);
		}
	}

}