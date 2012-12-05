package  
{
	import net.flashpunk.graphics.*;
	import net.flashpunk.FP;
	/**
	 * ...
	 * @author Sarah
	 */
	public class GorgonBaby extends Gorgon 
	{
		[Embed(source = '../assets/sprites/gorgonbaby.png')] private const GORGONBABY:Class;
		
		public var targetTileX:int = 0;
		public var targetTileY:int = 0;
		
		public function GorgonBaby( startX:Number, startY:Number ) 
		{
			super( startX, startY );
			
			var sprite:Spritemap = new Spritemap(GORGONBABY, 16, 16);
			
			sprite.add("hairify", [0,1,2,3,4], 0.1);
			sprite.play("hairify");
			
			monsterImage = sprite;
			monsterImage.centerOO();
			graphic = monsterImage;
		}
		
		override public function update():void
		{
			var currentTileX:int = x / Main.TW;
			var currentTileY:int = y / Main.TW;
			
			var dx:int = targetTileX - currentTileX;
			var dy:int = targetTileY - currentTileY;
			
			if ( !canMove ) return;
			
			if ( isStatic )
			{
				if ( Math.abs( dx ) <= 1 && Math.abs( dy ) <= 1 )
				{
					isStatic = false;
				}
				else
				{	
					super.update();
				}
			}
			
			if ( !isStatic )
			{
				if ( targetTileX != x / Main.TW || targetTileY != y / Main.TW )
				{
					canMove = false;
					FP.tween(this, {x: x + dx * Main.TW, y: y + dy * Main.TW}, Player.playerTweenTime, {tweener: FP.tweener, complete: moveDone});
				}
			}
		}
	}

}