package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import sav.game.map.grid_layer.GridLayer;
	import sav.game.MouseRecorder;
	import sav.geom.path.PathUtils;
	import sav.geom.path.SplineCurve;
	import sav.geom.path.TrianglesData;
	
	/**
	 * ...
	 * @author sav
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			MouseRecorder.init(stage);
			
			var grid:GridLayer = GridLayer.quickBuildAt(this);
			
			var pointArray:Vector.<Point> = new Vector.<Point>;
			//pointArray.push(new Point(100, 100));
			//pointArray.push(new Point(200, 100));
			//pointArray.push(new Point(200, 200));
			//pointArray.push(new Point(300, 200));
			
			pointArray.push(new Point(130, 170));
			pointArray.push(new Point(211, 123));
			pointArray.push(new Point(304, 330));
			pointArray.push(new Point(404, 130));
			pointArray.push(new Point(604, 130));
			
			//pointArray = pointArray.reverse();
			
			
			var nodeLayer:Sprite = _nodeLayer = new Sprite;
			addChild(nodeLayer);
			for each(var point:Point in pointArray)
			{
				var nodeSprite:NodeSprite = new NodeSprite(point);
				nodeLayer.addChild(nodeSprite);
				
				MouseRecorder.registDrag(nodeSprite, null, false, updateNode);
			}
			
			_smoothCurve = new SplineCurve(1, 2);
			_smoothCurve.fit(pointArray);
			
			
			redraw();
		}
		
		private function updateNode(node:NodeSprite, dx:Number, dy:Number):void
		{	
			node.x += dx;
			node.y += dy;
			
			node.myPoint.x = node.x;
			node.myPoint.y = node.y;
			
			_smoothCurve.update();
			redraw();
		}
		
		private function redraw():void
		{
			var resultPointList:Vector.<Point> = _smoothCurve.resultPointList;
			
			//trace("numVertices = " + resultPointList.length);
			//trace("result point list = " + resultPointList);
			
			
			var i:int, n:int = resultPointList.length;
			var point:Point;
			var g:Graphics = this.graphics;
			var g2:Graphics = _nodeLayer.graphics;
			g.clear();
			g2.clear();
			
			var bitmapData:BitmapData = Bitmap(new GrassTexture()).bitmapData;
			var obj:TrianglesData = PathUtils.getTrianglesData_fromPoints(resultPointList, 30, 150, false, 0);
			var tx:Number, ty:Number;
			n = obj.vertices.length;
			
			g.beginBitmapFill(bitmapData, null,true, true);
			g.drawTriangles(obj.vertices, obj.indices, obj.uvData);
			g.endFill();
		}
		
		/**** params ****/
		private var _smoothCurve:SplineCurve;
		private var _nodeLayer:Sprite;
		
		[Embed(source = "../res/GrassTexture.png")]
		private var GrassTexture:Class;
		
		[Embed(source = "../res/SimpleCrate.png")]
		private var SimpleCrate:Class;
	}
}


import flash.display.Sprite;
	
class NodeSprite extends Sprite
{
	public var myPoint:flash.geom.Point;
	
	public function NodeSprite(myPoint:flash.geom.Point)
	{
		this.myPoint = myPoint;
		this.x = myPoint.x;
		this.y = myPoint.y;
		
		var g:flash.display.Graphics = this.graphics;
		g.lineStyle(1, 0x000000);
		g.beginFill(0xff0000);
		g.drawCircle(0, 0, 4);
		g.endFill();
	}
}