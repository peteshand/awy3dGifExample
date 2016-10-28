package sample.away3dGif
{
	import away3d.containers.View3D;
	import away3d.controllers.HoverController;
	import away3d.entities.Mesh;
	import away3d.materials.GifMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.textures.GifTexture;
	import com.worlize.gif.GIFPlayer;
	import com.worlize.gif.events.GIFPlayerEvent;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class Main extends Sprite 
	{
		[Embed(source="bob.gif", mimeType = "application/octet-stream")]
		public static const data:Class;
		
		private var view:View3D;
		private var cameraController:HoverController;
		private var gifPlayer:GIFPlayer;
		
		//navigation variables
		private var move:Boolean = false;
		private var lastPanAngle:Number = 0;
		private var lastTiltAngle:Number = 0;
		private var lastMouseX:Number = 0;
		private var lastMouseY:Number = 0;
		
		public function Main() 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			view = new View3D();
			addChild(view);
			
			cameraController = new HoverController(view.camera, null, 180, 20, 320);
			
			//setup the render loop
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			//stage.addEventListener(Event.RESIZE, onResize);
			//onResize();
			
			gifPlayer = new GIFPlayer(true);
			gifPlayer.addEventListener(GIFPlayerEvent.COMPLETE, OnDecodeComplete);
			gifPlayer.loadBytes(new data());
			
			view.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			view.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function OnDecodeComplete(e:GIFPlayerEvent):void 
		{
			var texture:GifTexture = new GifTexture(gifPlayer);
			var gifMaterial:GifMaterial = new GifMaterial(texture);
			
			var geo:PlaneGeometry = new PlaneGeometry(gifPlayer.width * 2, gifPlayer.height * 2, 1, 1, false);
			var mesh:Mesh = new Mesh(geo, gifMaterial);
			view.scene.addChild(mesh);
		}
		
		/**
		 * render loop
		 */
		private function onEnterFrame(e:Event):void
		{
			cameraController.panAngle = 180 + ((((stage.mouseX / stage.stageWidth) * 2) - 1) * 60);
			cameraController.tiltAngle = ((((stage.mouseY / stage.stageHeight) * 2) - 1) * 20);
			view.render();
		}
		
		/**
		 * Mouse down listener for navigation
		 */
		private function onMouseDown(event:MouseEvent):void
		{
			move = true;
			lastPanAngle = cameraController.panAngle;
			lastTiltAngle = cameraController.tiltAngle;
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
			stage.addEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		/**
		 * Mouse up listener for navigation
		 */
		private function onMouseUp(event:MouseEvent):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
		
		/**
		 * Mouse stage leave listener for navigation
		 */
		private function onStageMouseLeave(event:Event):void
		{
			move = false;
			stage.removeEventListener(Event.MOUSE_LEAVE, onStageMouseLeave);
		}
	}
}