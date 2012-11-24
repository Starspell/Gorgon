package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	import flash.display.*;
	import flash.utils.*;
	
	public class AutoTile
	{
		public static function chooseTiles (map:Tilemap, src:Tilemap):void
		{
			for ( var iy:int = 0; iy < src.rows; iy++ )
			{
				for ( var ix:int = 0; ix < src.columns; ix++ )
				{
					var tile:uint = src.getTile(ix,iy);
					
					if (tile == 0) {
						map.setTile(ix, iy, 6*6);
					}
					else if (tile == 1) {
						autoWall(src, map, ix, iy, 6*3);
					}
					else if (tile == 2) {
						map.setTile(ix, iy, 6*6+1);
					}
					else if (tile == 4) {
						map.setTile(ix, iy, 6*6+2);
					}
				}
			}
		}
		
		public static function autoWall(src:Tilemap, map:Tilemap, i:int, j:int, offset:int):void
		{
			var flags:int = 0;
			if(isWall(src, i, j-1)) flags |= 1;
			if(isWall(src, i+1, j)) flags |= 2;
			if(isWall(src, i, j+1)) flags |= 4;
			if(isWall(src, i-1, j)) flags |= 8;
			
			var allWall:Boolean = false;
			var tx:int=0;
			var ty:int=0;
			switch(flags)
			{
				case 0: tx=1; ty=1; break;
				case 1: tx=1; ty=0; break;
				case 2: tx=2; ty=1; break;
				case 3:	tx=2; ty=0;
					if(isWall(src, i+1,j-1)) tx+=3;
					break;
				case 4: tx=1; ty=2; break;
				case 5: tx=1; ty=1; break;
				case 6: tx=2; ty=2;
					if(isWall(src, i+1,j+1)) tx+=3;
					break;
				case 7: tx=2; ty=1; break;
				case 8: tx=0; ty=1; break;
				case 9: tx=0; ty=0;
					if(isWall(src, i-1,j-1)) tx+=3;
					break;
				case 10: tx=1; ty=1; break;
				case 11: tx=1; ty=0; break;
				case 12: tx=0; ty=2;
					if(isWall(src, i-1,j+1)) tx+=3;
					break;
				case 13: tx=0; ty=1; break;
				case 14: tx=1; ty=2; break;
				case 15: allWall = true; break;
			}
			
			if(allWall)
			{
				flags = 0;
				if(isWall(src, i+1, j-1)) flags |= 1;
				if(isWall(src, i+1, j+1)) flags |= 2;
				if(isWall(src, i-1, j+1)) flags |= 4;
				if(isWall(src, i-1, j-1)) flags |= 8;
				switch(flags)
				{
					default: tx=4; ty=1; break;
					case 7: tx=2; ty=2; break;
					case 11: tx=2; ty=0; break;
					case 13: tx=0; ty=0; break;
					case 14: tx=0; ty=2; break;
				}
			}
			
			map.setTile(i, j, tx+ty*6 + offset);
		}
		
		public static function isWall (src:Tilemap, i:int, j:int):Boolean
		{
			if(i<0 || i>=src.columns || j<0 || j>=src.rows) return true;
			
			var tile:int = src.getTile(i,j);
			
			return (tile == 1);
		}
	
	}
}