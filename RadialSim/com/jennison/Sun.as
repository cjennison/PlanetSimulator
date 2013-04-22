package com.jennison 
{
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import com.jennison.Globals;
	/**
	 * ...
	 * @author 
	 */
	public class Sun extends MovieClip
	{
		public var tooltip:ToolTip;
		public function Sun() 
		{
			this.addEventListener(MouseEvent.MOUSE_OVER, showInformation);
			this.addEventListener(MouseEvent.MOUSE_MOVE, update);
			this.addEventListener(MouseEvent.MOUSE_OUT, removeTool);
		}
		
		private function update(e:MouseEvent):void 
		{
			if (tooltip) {
				tooltip.x = mouseX;
				tooltip.y = mouseY;
			}
			
		}
		
		private function removeTool(e:MouseEvent):void 
		{
			removeChild(tooltip);
		}
		
		private function showInformation(e:MouseEvent):void 
		{
			tooltip = new ToolTip();
			addChild(tooltip);
			tooltip.planetName.text = Globals.sun_name;
			tooltip.x = mouseX;
			tooltip.y = mouseY;
		}
		
	}

}