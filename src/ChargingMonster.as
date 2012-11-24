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
		
		public function moveWithDirection():void
		{
			if ( !canMove ) return;
			
			var dx:int;
			var dy:int;
			
			if (direction != "stop") 
			{
				dx = int(direction == "right") 	- int(direction == "left");
				dy = int(direction == "down") 	- int(direction == "up");
			}
			
			if ( collide("wall", x + dx * Main.TW, y + dy * Main.TW ) )
			{
				sawPlayer = false;
				return;
			}
			
			canMove = false;
			
			FP.tween(this, {x: x+dx*Main.TW, y:y+dy*Main.TW}, tweenTime, {tweener: FP.tweener, complete: moveDone});
		}
	}

}