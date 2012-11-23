package  
{
	import net.flashpunk.Entity;
	/**
	 * ...
	 * @author Sarah
	 */
	public class Monster extends Entity
	{
		[Embed(source = '../assets/sprites/monster.png')] private const MONSTER:Class;
		
		private var monsterImage:Image;
		
		public var canMove:Boolean = true;
		
		public function Monster( startX:Number, startY:Number ) 
		{
			
			super(startX, startY);
		}
		
	}

}