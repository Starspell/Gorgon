package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Sarah
	 */
	public class Monster extends Entity
	{
		[Embed(source = '../assets/sprites/monster.png')] private const MONSTER:Class;
		
		private const maxSpeed:Number = 1.5;
		private const timeToChangeDir:Number = 1;
		
		private var monsterImage:Image;
		private var dirTimer:Number;
		
		public var canMove:Boolean = true;
		
		public var moveQueue:Array = [];
		public var direction:String;
		
		public function Monster( startX:Number = 170, startY:Number = 120 ) 
		{
			monsterImage = new Image(MONSTER);
			dirTimer = timeToChangeDir;
			direction = "stop";
			
			super(startX, startY, monsterImage);
		}
		
		override public function update():void
		{
			if ( !canMove )
			{
				return;
			}
			
			dirTimer += FP.elapsed;
			
			if ( dirTimer > timeToChangeDir )
			{
				dirTimer -= timeToChangeDir;	

				var randNo:Number = Math.random();
		
				if (randNo < 1.0) 	direction = "left";
				if (randNo < 0.8) 	direction = "right";
				if (randNo < 0.6) 	direction = "up";
				if (randNo < 0.4) 	direction = "down";
				if (randNo < 0.2) 	direction = "stop";
			}
				
			var dx:int;
			var dy:int;
			
			if (direction != "stop") 
			{
				dx = int(direction == "right") 	- int(direction == "left");
				dy = int(direction == "down") 	- int(direction == "up");
			}
			
			x += dx * maxSpeed;
			y += dy * maxSpeed;
		}
	}

}