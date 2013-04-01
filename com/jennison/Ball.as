package com.jennison 
{
	import flash.display.Sprite;
	import flash.events.*;
	/**
	 * ...
	 * @author 
	 */
	public class Ball extends Sprite
	{
		private var _disp:Vector2D;
		private var _velo:Vector2D;
		private var _acc:Vector2D;
		private var _attractive_coeff:Number = 500;
		private var _mass:Number;
		
		public function Ball(radius:Number = 20, color:uint = 0x0000FF) 
		{
			this.draw(radius, color);
			this._mass = radius / 2;					//assuming mass is half of radius
			this.x = Math2.randomiseBetween(0, 550);
			this.y = Math2.randomiseBetween(0, 400);
			this._disp = new Vector2D(this.x, this.y);	//set initial displacement
			this._velo = new Vector2D(0, 0);
			this._acc = new Vector2D(0, 0);
		}
		
		private function draw(radius:Number, color:uint) :void
		{
			graphics.beginFill(color, 1);
			graphics.drawCircle(0, 0, radius);
			graphics.endFill();
		}
		
		public function get mass():Number 
		{
			return _mass;
		}
		
		private function getForceAttract (m1:Number, m2:Number, vec2Center:Vector2D):Vector2D
		{
			/* calculate attractive force based on the following formula:
			 * F = K * m1 * m2 / r * r
			 */
			
			var numerator:Number = this._attractive_coeff * m1 * m2;
			var denominator:Number = vec2Center.getMagnitude() * vec2Center.getMagnitude();
			var forceMagnitude:Number = numerator / denominator;
			var forceDirection:Number = vec2Center.getAngle();
						
			//setting a cap
			if (forceMagnitude > 0) forceMagnitude = Math.min(forceMagnitude, 5);
						
			//deriving force component, horizontal, vertical
			var forceX:Number = forceMagnitude * Math.cos(forceDirection);
			var forceY:Number = forceMagnitude * Math.sin(forceDirection);
			var force:Vector2D = new Vector2D(forceX, forceY);
			
			return force;
		}
		
		public function getAcc(vecForce:Vector2D):Vector2D
		{
			//setting acceleration due to force
			vecForce.multiply(1 / this._mass);
			var vecAcc:Vector2D = vecForce.duplicate();
			return vecAcc;
		}
		
		private function getDispTo(ball:Ball):Vector2D
		{
			var currentVector:Vector2D = new Vector2D(ball.x, ball.y);
			currentVector.minusVector(this._disp);
			return currentVector;
		}
		
		public function attractedTo(ball:Ball) :void
		{
			var toCenter:Vector2D = this.getDispTo(ball);
			var currentForceAttract:Vector2D = this.getForceAttract(ball.mass, this._mass, toCenter);
			this._acc = this.getAcc(currentForceAttract);
			this._velo.addVector(this._acc);
			this._disp.addVector(this._velo);
		}
		
		public function setPosition(vecDisp:Vector2D):void
		{
			this.x = Math.round(vecDisp.vecX);
			this.y = Math.round(vecDisp.vecY);
		}
		
		public function collisionInto (ball:Ball):Boolean
		{
			var hit:Boolean = false;
			var minDist:Number = (ball.width + this.width) / 2;
			
			if (this.getDispTo(ball).getMagnitude() < minDist)
			{
				hit = true;
			}
			
			return hit;
		}
		
		public function getRepel (ball:Ball): Vector2D
		{
			var minDist:Number = (ball.width + this.width) / 2;
			
			//calculate distance to repel
			var toBall:Vector2D = this.getDispTo(ball);
			var directToBall:Vector2D = toBall.getVectorDirection();
			directToBall.multiply(minDist);
			directToBall.minusVector(toBall);
			directToBall.multiply( -1);
			return directToBall;
		}
		
		public function repelledBy(ball:Ball):void
		{
			this._acc.reset();
			this._velo.reset();
			var repelDisp:Vector2D = getRepel(ball);
			this._disp.addVector(repelDisp);
		}
		
		public function animate(center:Ball, all:Array):void
		{
			this.attractedTo(center);
			if (collisionInto(center))		this.repelledBy(center);
			for (var i:int = 0; i < all.length; i++)
			{
				var current_ball:Ball = all[i] as Ball;
				if (collisionInto(current_ball) && current_ball.name != this.name)		this.repelledBy(current_ball);
			}
			this.setPosition(this._disp);
		}
	}

}