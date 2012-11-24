package  
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	/**
	 * ...
	 * @author Sarah
	 */
	public class ChargingMonster extends MonsterWithSight 
	{
		[Embed(source = '../assets/sprites/chargingmonster.png')] private const CHARGING:Class;
		
		public function ChargingMonster( startX:Number, startY:Number ) 
		{
			super( startX, startY );
			
			monsterImage = new Image(CHARGING);
			monsterImage.centerOO();
			graphic = monsterImage;
		}
		
		override public function update():void
		{
			if ( !canSeePlayer && !sawPlayer )
			{
				super.update();
			}
			else
			{
				updateSight();
				moveWithDirection();
			}
		}
		
		override protected function hitWall():void
		{
			sawPlayer = false;
		}
	}

}