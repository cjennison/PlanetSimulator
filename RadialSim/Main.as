package {
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import Box2D.Dynamics.*;
	import Box2D.Collision.*;
	import Box2D.Collision.Shapes.*;
	import Box2D.Common.Math.*;
	import Box2D.Dynamics.Joints.*;
	import customContact;
	
	public class Main extends Sprite {
		private var world:b2World=new b2World(new b2Vec2(0,0),true);
		private var worldScale:Number=30;
		private var planetVector:Vector.<b2Body>=new Vector.<b2Body>();
		private var debrisVector:Vector.<b2Body>=new Vector.<b2Body>();
		private var orbitCanvas:Sprite = new Sprite();
		
		private var velX:Number = 0;
		private var velY:Number = 0;
		
		private var firstMouseX:Number = 0;
		private var firstMouseY:Number = 0;
		private var pulling:Boolean = false;
		var pullLine:Shape;
		
		private var mouseTxt:mouseText = new mouseText();
		
		
		public function Main() {
			world.SetContactListener(new customContact());
			addChild(orbitCanvas);
			orbitCanvas.graphics.lineStyle(1,0xff0000);
			debugDraw();
			addSun(stage.stageWidth/2,stage.stageHeight/2 + 40,70);
			//addPlanet(480,120,45);
			addEventListener(Event.ENTER_FRAME,update);
			stage.addEventListener(MouseEvent.MOUSE_UP, createDebris);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, startPull);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, pull);
			
		}

		
		private function pull(e:MouseEvent):void 
		{
			if (!pulling) { return; }
			velX = (firstMouseX - mouseX)/10;
			velY = (firstMouseY -  mouseY)/10;
			mouseTxt.x = mouseX;
			mouseTxt.y = mouseY;
			mouseTxt.velText.text = "Initial Velocity: " + velX + " km/s, " + velY + " km/s";;
			
			pullLine.graphics.clear();
			pullLine.graphics.moveTo(firstMouseX, firstMouseY);
			pullLine.graphics.lineStyle(1, 0xFF0000, 1);
			pullLine.graphics.lineTo(mouseX, mouseY);
			trace(velX + " " + velY);
		}
		
		private function startPull(e:MouseEvent):void 
		{
			addChild(mouseTxt);
			pulling = true;
			firstMouseX = mouseX;
			firstMouseY = mouseY;
			
			pullLine = new Shape();
			addChild(pullLine);
			
			trace(firstMouseX + " " + firstMouseY);
			
		}
		private function createDebris(e:MouseEvent):void {
			addBox(mouseX, mouseY, 20, 20, Math.random()*10);
			pulling = false;
			pullLine.graphics.clear();
			removeChild(mouseTxt);
		}
		private function addSun(pX:Number,pY:Number,r:Number):void {
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.restitution=0;
			fixtureDef.density=1;
			var circleShape:b2CircleShape=new b2CircleShape(r/worldScale);
			fixtureDef.shape=circleShape;
			var bodyDef:b2BodyDef=new b2BodyDef();
			bodyDef.userData = "sun";
			bodyDef.position.Set(pX/worldScale,pY/worldScale);
			var thePlanet:b2Body=world.CreateBody(bodyDef);
			planetVector.push(thePlanet);
			thePlanet.CreateFixture(fixtureDef);
			orbitCanvas.graphics.drawCircle(pX,pY,r*3.5);
		}
		private function addBox(pX:Number, pY:Number, w:Number, h:Number, r:Number):void {
			
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.restitution=0;
			fixtureDef.density=1;
			var circleShape:b2CircleShape=new b2CircleShape(r/worldScale);
			fixtureDef.shape=circleShape;
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.userData = "planet";
			bodyDef.position.Set(pX/worldScale,pY/worldScale);
			var body:b2Body=world.CreateBody(bodyDef);
			debrisVector.push(body);
			body.CreateFixture(fixtureDef);
			body.SetLinearVelocity(new b2Vec2(velX, velY));
			
			/*
			var circleShape:b2CircleShape=new b2CircleShape(10/worldScale);
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.density=1;
			fixtureDef.friction=1;
			fixtureDef.restitution=0;
			fixtureDef.shape=circleShape;
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			
			bodyDef.position.Set(pX / worldScale, pY / worldScale);
			var box:b2Body=world.CreateBody(bodyDef);
			debrisVector.push(box);
			box.CreateFixture(fixtureDef);
			
			box.SetLinearVelocity(new b2Vec2(velX, velY));
			*/
		}
		private function debugDraw():void {
			var debugDraw:b2DebugDraw = new b2DebugDraw();
			var debugSprite:Sprite = new Sprite();
			addChild(debugSprite);
			debugDraw.SetSprite(debugSprite);
			debugDraw.SetDrawScale(worldScale);
			debugDraw.SetFlags(b2DebugDraw.e_shapeBit|b2DebugDraw.e_jointBit);
			debugDraw.SetFillAlpha(0.5);
			world.SetDebugDraw(debugDraw);
		}
		private function update(e:Event):void {
			world.Step(1/30, 10, 10);
			world.ClearForces();
			for (var i:int = 0; i < debrisVector.length; i++) {
				//trace(debrisVector[i].GetUserData());
				var debrisPosition:b2Vec2=debrisVector[i].GetWorldCenter();
				for (var j:int = 0; j < planetVector.length; j++) {
					//trace(planetVector[i].GetUserData());
					var planetShape:b2CircleShape=planetVector[j].GetFixtureList().GetShape() as b2CircleShape;
					var planetRadius:Number=planetShape.GetRadius();
					var planetPosition:b2Vec2=planetVector[j].GetWorldCenter();
					var planetDistance:b2Vec2=new b2Vec2(0,0);
					planetDistance.Add(debrisPosition);
					planetDistance.Subtract(planetPosition);
					var finalDistance:Number=planetDistance.Length();
					if (finalDistance<=planetRadius*4) {
						planetDistance.NegativeSelf();
						var vecSum:Number=Math.abs(planetDistance.x)+Math.abs(planetDistance.y);
						planetDistance.Multiply((1/vecSum)*planetRadius/finalDistance * 10);
						debrisVector[i].ApplyForce(planetDistance,debrisVector[i].GetWorldCenter());
					}
				}
			}
			world.DrawDebugData();
		}
	}
}