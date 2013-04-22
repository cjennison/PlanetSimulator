package {
	import adobe.utils.CustomActions;
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
	import com.jennison.Globals;
	import com.jennison.Sun;
	import com.jennison.Planet;
	import com.jennison.Introduction;
	import fl.transitions.Tween;
	import fl.transitions.easing.*;
	import fl.transitions.TweenEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
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
		
		//Planets
		private var sun:Sun = new Sun();
		private var planet:Planet;
		
		//Intro
		private var intro:Introduction = new Introduction();
		
		public function Main() {
			
			addChild(intro);
			intro.igniteBtn.mouseEnabled = false;
			intro.igniteBtn.alpha = 0;
			attachIgnite();
		}
		
		
		
		public function initWorld(e:MouseEvent = null) {
			Globals.sun_name = intro.sunName.text;
			removeChild(intro);
			world.SetContactListener(new customContact());
			addChild(orbitCanvas);
			orbitCanvas.graphics.lineStyle(1,0xff0000);
			debugDraw();
			addSun(stage.stageWidth/2,stage.stageHeight/2 + 10,40);
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
			mouseTxt.velText.text = "Entry Velocity: " + velX + " km/s, " + velY + " km/s";;
			
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
		private function addSun(pX:Number, pY:Number, r:Number):void {
			
			sun = new Sun();
			addChild(sun);
			var sunTween:Tween = new Tween(sun, "alpha", Strong.easeOut, 0, 1, 5, true);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.restitution=0;
			fixtureDef.density=1;
			var circleShape:b2CircleShape=new b2CircleShape(r/worldScale);
			fixtureDef.shape=circleShape;
			var bodyDef:b2BodyDef=new b2BodyDef();
			bodyDef.userData = {asset:sun, radius:r};;
			bodyDef.position.Set(pX/worldScale,pY/worldScale);
			var thePlanet:b2Body=world.CreateBody(bodyDef);
			planetVector.push(thePlanet);
			thePlanet.CreateFixture(fixtureDef);
			//orbitCanvas.graphics.drawCircle(pX, pY, r * 3.5);
			
			sun.x = pX;
			sun.y = pY;
			
			sun.sungraphic.width = r * 2.3;
			sun.sungraphic.height = r * 2.3;
			
			createDialogue(["This is your Sun, " + Globals.sun_name, "A large mass of Helium and Hydrogen", "Use your mouse to send planets into the pull of " + Globals.sun_name]);
		}
		private function addBox(pX:Number, pY:Number, w:Number, h:Number, r:Number):void {
			
			planet = new Planet();
			addChild(planet);
			
			var fixtureDef:b2FixtureDef = new b2FixtureDef();
			fixtureDef.restitution=0;
			fixtureDef.density=1;
			var circleShape:b2CircleShape=new b2CircleShape(r/worldScale);
			fixtureDef.shape=circleShape;
			var bodyDef:b2BodyDef = new b2BodyDef();
			bodyDef.type = b2Body.b2_dynamicBody;
			bodyDef.userData = {asset:planet, radius:r};
			bodyDef.position.Set(pX/worldScale,pY/worldScale);
			var body:b2Body=world.CreateBody(bodyDef);
			debrisVector.push(body);
			body.CreateFixture(fixtureDef);
			body.SetLinearVelocity(new b2Vec2(velX, velY));
			planet.scaleX = r / 10;
			planet.scaleY = r / 10;
			planet.x = pX;
			planet.y = pY;
			
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
			world.Step(1/40, 10, 10);
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
					if (finalDistance<=planetRadius*10) {
						planetDistance.NegativeSelf();
						var vecSum:Number=Math.abs(planetDistance.x)+Math.abs(planetDistance.y);
						planetDistance.Multiply((1/vecSum)*planetRadius/finalDistance * 10);
						debrisVector[i].ApplyForce(planetDistance,debrisVector[i].GetWorldCenter());
					}
				}
			}
			
			
			for (var currentBody:b2Body = world.GetBodyList(); currentBody; currentBody = currentBody.GetNext()) {
				if (currentBody.GetUserData()) {
					currentBody.GetUserData().asset.x = currentBody.GetPosition().x * worldScale;
					currentBody.GetUserData().asset.y = currentBody.GetPosition().y * worldScale;
				}
			}
			
			//trace(Globals.bodiesToRemove);
			for (var k:int = 0; k < Globals.bodiesToRemove.length; k++) 
			{
				removeChild(Globals.bodiesToRemove[k].GetUserData().asset);

				world.DestroyBody(Globals.bodiesToRemove[k]);
				Globals.bodiesToRemove.splice(k, 1);
			}
			
			world.DrawDebugData();
		}
		
		public function attachIgnite() {
			
			intro.igniteBtn.addEventListener(MouseEvent.CLICK, initWorld);
		}
		
		
		public function createDialogue(textArr:Array) {
			var i = 0;
			function displayDialogue(text:String, time:Number) {
				var dialogue:Dialogue = new Dialogue();
				addChild(dialogue);
				dialogue.mouseEnabled = false;
				dialogue.ignoreChildren = true;
				dialogue.dialogueText.text = text;
				dialogue.x = stage.stageWidth / 2 - 360;
				dialogue.y = 100;
				var dialogueTween:Tween = new Tween(dialogue, "alpha", Strong.easeOut, 0, 1, 5, true);

				var dialogueTimer:Timer = new Timer(1000, time);
				dialogueTimer.start();
				dialogueTimer.addEventListener(TimerEvent.TIMER_COMPLETE, function() {
					var dialogueTweenOut:Tween = new Tween(dialogue, "alpha", Strong.easeOut, 1, 0, 5, true);
					dialogueTweenOut.addEventListener(TweenEvent.MOTION_FINISH, function() {
						removeChild(dialogue);
						i++;
						if (textArr[i]) {
							displayDialogue(textArr[i], 3);
						}
					});
				});
			}
			
			displayDialogue(textArr[i], 3);
			
		}
		
	}
	
	
}