package  {
  import Box2D.Dynamics.*;
  import Box2D.Collision.*;
  import Box2D.Dynamics.Contacts.*;
  public class customContact extends b2ContactListener {
    override public function BeginContact(contact:b2Contact):void{
      trace("a collision started");
      var fixtureA:b2Fixture=contact.GetFixtureA();
      var fixtureB:b2Fixture=contact.GetFixtureB();
      var bodyA:b2Body=fixtureA.GetBody();
      var bodyB:b2Body=fixtureB.GetBody();
      trace("first body: "+bodyA.GetUserData());
      trace("second body: "+bodyB.GetUserData());
      trace("---------------------------");
    }
    override public function EndContact(contact:b2Contact):void{
      trace("a collision ended");
      var fixtureA:b2Fixture=contact.GetFixtureA();
      var fixtureB:b2Fixture=contact.GetFixtureB();
      var bodyA:b2Body=fixtureA.GetBody();
      var bodyB:b2Body=fixtureB.GetBody();
      trace("first body: "+bodyA.GetUserData());
      trace("second body: "+bodyB.GetUserData());
      trace("---------------------------");
    }
  }
}