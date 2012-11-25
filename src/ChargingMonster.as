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
		
		private const chargingTweenTime:Number = 6;
		private const pauseTime:Number = 0.25;		
		
		private var shouldPause:Boolean = true;
		private var pauseTimer:Number = 0;
		
		public function ChargingMonster( startX:Number, startY:Number ) 
		{
			super( startX, startY );
			
			monsterImage = new Image(CHARGING);
			monsterImage.centerOO();
			graphic = monsterImage;
			addGraphic(monsterSightImage);
			
			isStatic = true;
			
			direction = "up";
		}
		
		override public function update():void
		{
			if ( !canSeePlayer && !sawPlayer )
			{
				super.update();
			}
			else
			{
				// Pause before charging
				if ( shouldPause )
				{
					pauseTimer += FP.elapsed;
					if ( pauseTimer > pauseTime )
					{
						shouldPause = false;
					}
				}
				else
				{
					updateSight();
					moveWithDirection( chargingTweenTime );
				}
			}
		}
		
		override protected function hitWall():void
		{
			sawPlayer = false;
			shouldPause = true;
			pauseTimer = 0;
			
			Main.startScreenShake();
		}
		
		override protected function hitMirror():void
		{
			// Would end up breaking the mirror but for now doesn't do anything special
			
			hitWall();
		}
	}

}