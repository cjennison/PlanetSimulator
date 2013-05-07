package  {
  import Box2D.Dynamics.*;
  import Box2D.Collision.*;
  import Box2D.Dynamics.Contacts.*;
  import com.jennison.Sun;
  import com.jennison.Planet;
  import flash.utils.getDefinitionByName;
  import flash.utils.*;
  import com.jennison.Globals;
  public class customContact extends b2ContactListener {
	  
	public var sun:Sun;
	  
    override public function BeginContact(contact:b2Contact):void{
     // trace("a collision started");
      var fixtureA:b2Fixture=contact.GetFixtureA();
      var fixtureB:b2Fixture=contact.GetFixtureB();
      var bodyA:b2Body=fixtureA.GetBody();
      var bodyB:b2Body=fixtureB.GetBody();
     // trace("first body: "+ bodyA.GetUserData());
     // trace("second body: " + bodyB.GetUserData());
	  
	 // trace(getClass(bodyB.GetUserData()));
	  
	  if (getClass(bodyA.GetUserData().asset) == Sun) {
			Globals.bodiesToRemove.push(bodyB);
	  }
	  
	  if (getClass(bodyB.GetUserData().asset) == Sun) {
			Globals.bodiesToRemove.push(bodyA);
	  }
	  
	  
	   if (getClass(bodyB.GetUserData().asset) == Planet && getClass(bodyA.GetUserData().asset) == Planet) {
			Globals.bodiesToCompare.push(bodyA);
			Globals.bodiesToCompare.push(bodyB);

	  }
	  
	  
	}
    override public function EndContact(contact:b2Contact):void{
      trace("a collision ended");
      var fixtureA:b2Fixture=contact.GetFixtureA();
      var fixtureB:b2Fixture=contact.GetFixtureB();
      var bodyA:b2Body=fixtureA.GetBody();
      var bodyB:b2Body=fixtureB.GetBody();
     // trace("first body: "+bodyA.GetUserData());
    //  trace("second body: "+bodyB.GetUserData());
    }
	
	
	static function getClass(obj:Object):Class {
        return Class(getDefinitionByName(getQualifiedClassName(obj)));
    }
  }
}