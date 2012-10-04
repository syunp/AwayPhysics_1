package
{
	import away3d.containers.ObjectContainer3D;
	import away3d.containers.View3D;
	import away3d.entities.Mesh;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.CubeGeometry;
	import away3d.primitives.WireframeCube;
	
	import awayphysics.collision.shapes.AWPBoxShape;
	import awayphysics.dynamics.AWPDynamicsWorld;
	import awayphysics.dynamics.AWPRigidBody;
	
	import flash.events.Event;
	import flash.geom.Vector3D;
	
	[SWF(width="465", height="465", frameRate="60")]
	public class Stage3D_3 extends View3D
	{
		private var physicsWorld:AWPDynamicsWorld;
		
		// 60fpsだから1/60秒
		private var timeStep:Number = 1.0 / 60.0;
		
		private var cubes:Vector.<AWPRigidBody>=new Vector.<AWPRigidBody>();
		
		public function Stage3D_3()
		{
			
			init();
			
			addEventListener(Event.ENTER_FRAME, loop);
		}
		
		private function init():void{
			backgroundColor = 0xFFFFFF;
			
			// AwayPhysicsが動作する世界を作る
			physicsWorld=AWPDynamicsWorld.getInstance();
			physicsWorld.initWithDbvtBroadphase();
			// 重力の設定
			physicsWorld.gravity=new Vector3D(0, -20, 0);
			
			createBox();
			
			camera.z = -2000;
			
		}
		
		private function createBox():void{
			var body:AWPRigidBody;
			var obj:Mesh;
			
			for(var i:uint = 0; i<50; i++){
				// いつも通り、キューブを作る
				var material:ColorMaterial = new ColorMaterial(0x0000FF);
				obj = new Mesh(new CubeGeometry(), material);
				scene.addChild(obj);
				
				// キューブを作るだけでは物理演算は働かない。
				// 作ったキューブと同じ大きさのものをAWPBoxShape()で作り、AWPRigidBodyで適用させる。
				body = new AWPRigidBody(new AWPBoxShape(100, 100, 100), obj, 1);
				body.x = 1000 * (Math.random() - 0.5);
				body.y = 1000 * (Math.random() - 0.5) + 1000;
				body.z = 1000 * (Math.random() - 0.5);
				cubes.push(body);
				// 作ったAWPRigidBodyをAwayPhysicsが動作する世界に追加
				physicsWorld.addRigidBody(body);
			}
		}
		
		private function loop(e:Event):void{
			
			// 下まで行ったらまた落ち直し
			for(var i:uint = 0; i<50; i++){
				if(cubes[i].y < -5000){
					cubes[i].x = 1000 * (Math.random() - 0.5);
					cubes[i].y = 1000 * (Math.random() - 0.5) + 1000;
					cubes[i].z = 1000 * (Math.random() - 0.5);
				}
			}
			
			// これが無いとphysicsWorld内のフレームが進まない
			physicsWorld.step(timeStep);
			
			render();
		}
	}
}