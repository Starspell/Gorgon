package
{
	import net.flashpunk.*;
	import net.flashpunk.graphics.*;
	import net.flashpunk.masks.*;
	import net.flashpunk.utils.*;
	
	public class Button extends Entity
	{
		public var image:Image;
		
		public var callback:Function;
		
		public var normalColor:uint = 0x8ad4f1;
		public var hoverColor:uint = 0xd97d3c;
		
		public function Button (text:String, _y:int, _callback:Function)
		{
			y = _y;
			
			image = new Text(text, 0, 0);
			
			image.color = normalColor;
			
			graphic = image;
			
			setHitbox(image.width - 1, image.height - 1);
			
			type = "button";
			
			callback = _callback;
		}
		
		public override function update (): void
		{
			if (!world || !collidable) return;
			
			var over:Boolean = collidePoint(x, y, world.mouseX, world.mouseY);
			
			if (over) {
				Input.mouseCursor = "button";
			}
			
			image.color = (over) ? hoverColor : normalColor;
			
			if (over && Input.mousePressed && callback != null) {
				callback();
			}
		}
	}
}

