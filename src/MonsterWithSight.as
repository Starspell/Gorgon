package  
{
	import net.flashpunk.graphics.Image;
	import net.flashpunk.*;
	
	/**
	 * ...
	 * @author Sarah
	 */
	public class MonsterWithSight extends Monster 
	{
		[Embed(source = '../assets/sprites/monsterwithsight.png')] private const MONSTERSIGHT:Class;
		
		public function MonsterWithSight( startX:Number = 170, startY:Number = 120 ) 
		{
			super( startX, startY );
			
			monsterImage = new Image(MONSTERSIGHT);
			monsterImage.centerOO();
			graphic = monsterImage;
		}
		
		override public function update():void
		{
			super.update();
			
			var currentWorld:GameWorld = FP.world as GameWorld;
			
			var dead:Boolean = false;
			
			if ( currentWorld )
			{
				switch(direction)
				{
					case "left":
						dead = currentWorld.player.x < x && currentWorld.player.y == y;
						break;
					case "right":
						dead = currentWorld.player.x > x && currentWorld.player.y == y;
						break;
					case "up":
						dead = currentWorld.player.x == x && currentWorld.player.y < y;
						break;
					case "down":
						dead = currentWorld.player.x == x && currentWorld.player.y > y;
						break;
				}
				
				currentWorld.showDeath = dead;
			}			
		}
	}

}