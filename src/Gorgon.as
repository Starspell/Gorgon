package  
{
	import net.flashpunk.graphics.*;
	/**
	 * ...
	 * @author Sarah
	 */
	public class Gorgon extends Monster
	{
		[Embed(source = '../assets/sprites/gorgon.png')] private const GORGON:Class;
		
		public function Gorgon( startX:Number, startY:Number ) 
		{
			super( startX, startY );
			
			monsterImage = new Image(GORGON);
			monsterImage.centerOO();
			graphic = monsterImage;
			
			isStatic = true;
			
			// Needs to be different for sight
			type = "gorgon";
		}
		
	}

}