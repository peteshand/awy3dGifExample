package away3d.textures 
{
	import away3d.materials.utils.IVideoPlayer;
	import away3d.textures.BitmapTexture;
	import away3d.textures.Texture2DBase;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.textures.TextureBase;
	import flash.display3D.textures.VideoTexture;
	import away3d.materials.utils.SimpleVideoPlayer;
	import flash.events.Event;
	import flash.utils.getDefinitionByName;
	
	public class NativeVideoTexture extends Texture2DBase 
	{
		private var texture:TextureBase;
		private var _autoPlay:Boolean;
		private var _player:IVideoPlayer;
		private var VideoTextureClass:Class;
		
		public function NativeVideoTexture(source:String, loop:Boolean = true, autoPlay:Boolean = false, player:IVideoPlayer = null) 
		{
			// assigns the provided player or creates a simple player if null.
			_player = player || new SimpleVideoPlayer();
			_player.loop = loop;
			_player.source = source;
			
			// sets autplay
			_autoPlay = autoPlay;
			
			// if autoplay start video
			if (autoPlay)
				_player.play();
			
			
			try {
				VideoTextureClass = getDefinitionByName("flash.display3D.textures.VideoTexture") as Class;
			}
			catch (e:Error) {
				trace(e);
			}
		}
		
		override protected function uploadContent(texture:TextureBase):void
		{
			
		}
		
		override protected function createTexture(context:Context3D):TextureBase
		{
			if (!VideoTextureClass) {
				throw new Error("flash.display3D.textures.VideoTexture not supported");
				return null;
			}
			
			texture = context.createVideoTexture();
			VideoTextureClass(texture).attachNetStream(_player.ns);
			VideoTextureClass(texture).addEventListener("renderState", renderFrame);
			return texture;
		}
		
		private function renderFrame(e:Event):void
		{
			
		}
	}
}