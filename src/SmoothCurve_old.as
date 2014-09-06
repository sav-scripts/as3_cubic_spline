package  
{
	import flash.display.Graphics;
	import flash.geom.Point;
	/**
	 * ...
	 * @author sav
	 */
	public class SmoothCurve_old
	{
		
		public function SmoothCurve(pointArray:Array):void
		{
			_pointArray = pointArray.concat([]);
			len = pointArray.length;
			
			x = new Vector.<Number>(len);
			y = new Vector.<Number>(len);
			var i:int, j:int;
			var point:Point;
			
			for (i = 0; i < len; i++)
			{
				point = pointArray[i];
				x[i] = point.x;
				y[i] = point.y;
			}
			
			trace("x = " + x);
			trace("y = " + y);
			
			/**** params ****/
		
			h = new Vector.<Number>(len);
			u = new Vector.<Number>(len);
			lam = new Vector.<Number>(len);
			
			for (i = 0; i < len-1; i++)
			{
				h[i] = x[i + 1] - x[i];
			}    
			trace("h = " + h);
	 
			u[0] = 0;
			lam[0] = 1;
			for (i = 1; i < (len - 1); i++)
			{
				u[i] = h[i - 1] / (h[i] + h[i - 1]);
				lam[i] = h[i] / (h[i] + h[i - 1]);
			}
			
			trace("u = " + u);
			trace("lam = " + lam);
			
			var a:Vector.<Number> = new Vector.<Number>(len);
			var b:Vector.<Number> = new Vector.<Number>(len);
			var c:Vector.<Number> = new Vector.<Number>(len);
			
			//trace(a[0]);
	 
			//float m[len][len];
			var m:Vector.<Vector.<Number>> = new Vector.<Vector.<Number>>(len);
			
			for (i = 0; i < len; i++)
			{
				m[i] = new Vector.<Number>(len);
				
				for (j = 0; j < len; j++)
				{
					m[i][j] = 0;
				}
				
				if (i == 0)
				{
					m[i][0] = 2;
					m[i][1] = 1;
	 
					b[0] = 2;
					c[0] = 1;
				}
				else if (i == (len - 1))
				{
					m[i][len - 2] = 1;
					m[i][len - 1] = 2;
	 
					a[len-1] = 1;
					b[len-1] = 2;
				}
				else
				{
					m[i][i-1] = lam[i];
					m[i][i] = 2;
					m[i][i+1] = u[i];
					
					
					a[i] = lam[i];
					b[i] = 2;
					c[i] = u[i];
				}
			}
			
			/**** params ****/
			
			var g:Vector.<Number> = new Vector.<Number>(len);
			g[0] = 3 * (y[1] - y[0])/h[0];
			g[len - 1] = 3 * (y[len - 1] - y[len - 2]) / h[len - 2];
			
			for (i = 1; i < len - 1; i++)
			{
				g[i] = 3 * ((lam[i] * (y[i] - y[i-1])/h[i-1]) + u[i] * (y[i+1] - y[i])/h[i]);
			}
			
			trace("a = " + a);
			trace("b = " + b);
			trace("c = " + c);
			trace("g = " + g);
			
			/**** params ****/
			
			var p:Vector.<Number> = new Vector.<Number>(len);
			var q:Vector.<Number> = new Vector.<Number>(len);
	 
			p[0] = b[0];
			for (i = 0; i < len - 1; i++)
			{
				q[i] = c[i] / p[i];
			}
	 
			for (i = 1; i < len; i++)
			{
				p[i] = b[i] - a[i]*q[i-1];
			}
			
			su = new Vector.<Number>(len);
			sq = new Vector.<Number>(len);
			sx = new Vector.<Number>(len);
	 
			su[0] = c[0] / b[0];
			sq[0] = g[0] / b[0];
			
			for (i = 1; i < len - 1; i++)
			{
				su[i] = c[i] / (b[i] - su[i - 1] * a[i]);
			}
	 
			for (i = 1; i < len; i++)
			{
				sq[i] = (g[i] - sq[i - 1] * a[i]) / (b[i] - su[i - 1] * a[i]);
			}
	 
			sx[len-1] = sq[len-1];
			for (i = len - 2; i >= 0; i--)
			{
				sx[i] = sq[i] - su[i] * sx[i + 1];
			}
			
			trace("su = " + su);
			trace("sq = " + sq);
			trace("sx = " + sx);
		}
		
		public function drawAt(g:Graphics):void
		{
			
			var i:int;
			var pt:Point, curP:Point, delta:Number = 10;
			var pointX:Number, pointY:Number;
			
			g.lineStyle(1, 0x000000);
			
			for (i = 0; i < len; i++)
			{
				pt = _pointArray[i];
				
				if (i == 0)
				{
					g.moveTo(pt.x, pt.y);
				}
				else
				{
					curP = _pointArray[i - 1];
					
					trace("curP = " + curP);
					trace("pt = " + pt);
					
					if (pt.x > curP.x)
					{	
						for (pointX = curP.x; pointX < pt.x; pointX += delta)
						{
							
							pointY = getY(i-1, pointX);
							//CGPathAddLineToPoint(path, NULL, pointX, pointY);
							g.lineTo(pointX, pointY);
							
							
							trace("pointX = " + pointX + ", pointY = " + pointY);
							
							if (pointY > 2000) return;
						}
					}
					else
					{
						
						for (pointX = curP.x; pointX > pt.x; pointX -= delta)
						{
							
							pointY = getY(i-1, pointX);
							//CGPathAddLineToPoint(path, NULL, pointX, pointY);
							g.lineTo(pointX, pointY);
							
							
							trace("pointX = " + pointX + ", pointY = " + pointY);
							
							if (pointY > 2000) return;
						}
					}
				}
			}
		}
		
		public function getY(k:int, vX:Number):Number
		{
			/**** params ****/
			
			 //double (^func)(int k, float vX) = ^(int k, float vX) {
            //double p1 =  (ph[k] + 2.0 * (vX - px[k])) * ((vX - px[k+1]) * (vX - px[k+1])) * py[k] / (ph[k] *ph[k] * ph[k]);
            //double p2 =  (ph[k] - 2 * (vX - px[k+1])) * Math.pow((vX - px[k]), 2.0f) * py[k+1] / Math.pow(ph[k], 3.0f);
            //double p3 =  (vX - px[k]) * Math.pow((vX - px[k+1]), 2.0f) * psx[k] / Math.pow(ph[k], 2.0f);
            //double p4 =  (vX - px[k+1]) * Math.pow((vX - px[k]), 2.0f) * psx[k+1] / Math.pow(ph[k], 2.0f);
            //return p1 + p2 + p3 + p4;
			
			//Math.sq
            var p1:Number =  (h[k] + 2.0 * (vX - x[k])) * ((vX - x[k + 1]) * (vX - x[k + 1])) * y[k] / (h[k] * h[k] * h[k]);
            var p2:Number =  (h[k] - 2 * (vX - x[k + 1])) * Math.pow((vX - x[k]), 2.0) * y[k + 1] / Math.pow(h[k], 3.0);
            var p3:Number =  (vX - x[k]) * Math.pow((vX - x[k + 1]), 2.0) * sx[k] / Math.pow(h[k], 2.0);
            var p4:Number =  (vX - x[k + 1]) * Math.pow((vX - x[k]), 2.0) * sx[k + 1] / Math.pow(h[k], 2.0);
			
			
			//trace("p1 = " + p1);
			//trace("p2 = " + p2);
			//trace("p3 = " + sx[k]);
			//trace("p4 = " + p4);
			
            return p1 + p2 + p3 + p4;
		}
		
		/**** params ****/
		private var len:int;
		private var _pointArray:Array;
		
		private var x:Vector.<Number>;
		private	var y:Vector.<Number>;
			
		private var h:Vector.<Number>;
		private var u:Vector.<Number>;
		private var lam:Vector.<Number>;
		
		private var su:Vector.<Number>;
		private var sq:Vector.<Number>;
		private var sx:Vector.<Number>;
	}
}