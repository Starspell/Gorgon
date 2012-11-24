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
		
		protected var canSeePlayer:Boolean = false;
		protected var sawPlayer:Boolean = false;
		protected var killsWithSight:Boolean = false;
		
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
			
			updateSight();
		}
		
		protected function updateSight():void
		{
			var currentWorld:GameWorld = FP.world as GameWorld;
			
			canSeePlayer = false;
			
			if ( currentWorld )
			{
				switch( direction )
				{
					case "left":
						canSeePlayer = currentWorld.player.x < x && currentWorld.player.y == y;
						break;
					case "right":
						canSeePlayer = currentWorld.player.x > x && currentWorld.player.y == y;
						break;
					case "up":
						canSeePlayer = currentWorld.player.x == x && currentWorld.player.y < y;
						break;
					case "down":
						canSeePlayer = currentWorld.player.x == x && currentWorld.player.y > y;
						break;
				}
				
				sawPlayer = sawPlayer || canSeePlayer;
				currentWorld.showDeath = canSeePlayer && killsWithSight;
			}			
		}
	}

}