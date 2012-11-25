package  
{
	import com.adobe.air.crypto.EncryptionKeyGenerator;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.*;
	
	public class Mirror extends Entity 
	{
		[Embed(source = '../assets/sprites/mirrors.png')] public static const Gfx:Class;
		
		// Maps incoming direction to outbound dir
		public var bouncingMap:Object;
		
		public function Mirror(ix:int, iy:int, dir:int) 
		{
			x = ix*Main.TW;
			y = iy*Main.TW;
			
			setHitbox(Main.TW, Main.TW);
			
			var image:Spritemap = new Spritemap(Gfx, 32, 32);
			
			image.frame = dir;
			
			image.originX = int(dir % 2) ? 0 : Main.TW;
			image.originY = int(dir / 2) ? 0 : Main.TW;
			
			graphic = image;
			
			type = "mirror";
			
			bouncingMap = new Object();
			
			switch( dir )
			{
				case 0:
					bouncingMap.left = "down";
					bouncingMap.up = "right";
					break;
				case 1:
					bouncingMap.right = "down";
					bouncingMap.up = "left";
					break;
				case 2:
					bouncingMap.left = "up";
					bouncingMap.down = "right";
					break;
				case 3:
					bouncingMap.right = "up";
					bouncingMap.down = "left";
					break;
			}
		}
		
		public function getBounceDir( incomingDir:String ):String 
		{
			return bouncingMap[incomingDir];
		}
		
	}

}