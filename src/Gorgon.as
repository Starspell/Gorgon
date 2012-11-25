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
			
			var sprite:Spritemap = new Spritemap(GORGON, 16, 16);
			
			sprite.add("hairify", [0,1,2,3,4], 0.1);
			sprite.play("hairify");
			
			monsterImage = sprite;
			monsterImage.centerOO();
			graphic = monsterImage;
			
			isStatic = true;
			
			// Needs to be different for sight
			type = "gorgon";
		}
		
	}

}