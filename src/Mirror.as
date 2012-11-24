package  
{
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.*;
	
	public class Mirror extends Entity 
	{
		[Embed(source = '../assets/sprites/mirrors.png')] public static const Gfx:Class;
		
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
		}
		
	}

}