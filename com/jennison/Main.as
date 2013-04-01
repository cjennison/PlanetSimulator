package com.jennison 
{
	import Box2D.Collision.Shapes.b2CircleShape;
	import Box2D.Collision.Shapes.b2PolygonShape;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author 
	 */
	public class Main extends MovieClip 
	{
		
		private var mainBall:Ball;
		private var totalBalls:int = 10;
		public function Main() 
		{
			init();
		}
		
		private function init(e:Event = null):void {
			//removeEventListener
			createBalls();
			mainBall.addEventListener(MouseEvent.MOUSE_DOWN, m_down);
			stage.addEventListener(MouseEvent.MOUSE_UP, m_up);
			animateAll();
		}
		
		private function animateAll():void 
		{
			for (var i:int = 0; i < totalBalls; i++) 
			{
				//each ball is pulled by main ball
				var current_ball:Ball = this.getChildByName("ball" + i) as Ball;
				current_ball.addEventListener(Event.ENTER_FRAME, enterFrame);
			}
		}
		
		private function enterFrame(e:Event):void 
		{
			var allObj:Array = new Array();
			for (var i:int = 0; i < totalBalls; i++) 
			{
				var current_ball:Ball = this.getChildAt(i) as Ball;
				allObj.push(current_ball);
			}
			e.target.animate(mainBall, allObj);
		}
		
		private function m_up(e:MouseEvent):void 
		{
			stopDrag();
		}
		
		private function m_down(e:MouseEvent):void 
		{
			e.target.startDrag();
		}
		
		private function createBalls():void {
			mainBall = new Ball(50, 0x00FF00); //create planet
			this.addChild(mainBall);
			for (var i:int = 0; i < this.totalBalls; i++) 
			{
				var currentBall:Ball = new Ball();
				currentBall.name = "ball" + i;
				this.addChild(currentBall);
			}
		}
		
		
		
	}

}