package lib.utils 
{
	
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import flash.geom.Transform;
	import flash.text.TextField;
	/**
	 * utilidades relacionadas com cores
	 * 
	 * @version 1.0
	 * @author (View 2008) Paulo Afonso 
	 * @date 10.11.2008
	 * 
	 */
	
	public class Colors 
	{
		public function Colors() 
		{
			
		}
		
		/**
		 * devolve true se a cor for clara
		 * @param	hex, exemplo 0x55ff00
		 * @return true se a cor for clara, false em caso contrário
		 * 
		 * @example diz se a cor 0xff2233 é clara
		 * <listing version="3.0">
		 * trace(utils.isLighColor(0xff2233));
		 * </listing>
		 */
		static public function isLightColor(hex:Number ):Boolean
		{
			var tmpColor:Object = hex2RGB(hex);
			
			return ( ((tmpColor.r*0.3 + tmpColor.g*0.59 + tmpColor.b*0.11)) > 0xff/2);
		}
		
		/**
		 * Pinta um displayobject de uma determinada cor especificada
		 * @param	dp, link para o displayobject
		 * @param	cor, 0xRRGGBB
		 * 
		 * @example pinta o botao conforme o evento do rato
		 * <listing version="3.0">
		 * import utils.Colors;
		 * var sp:Sprite=new Sprite();
		 * 
		 * sp.graphics.beginFill(0x000000);
		 * sp.graphics.drawRect(0,0,50,20);
		 * sp.graphics.endFill();
		 * 
		 * sp.buttonMode=true;
		 * sp.addEventListener(MouseEvent.MOUSE_OVER,mouseHandler);
		 * sp.addEventListener(MouseEvent.MOUSE_OUT,mouseHandler);
		 * 
		 * this.addChild(sp);
		 * 
		 * function mouseHandler(e:MouseEvent)
		 * {
		 *   if (e.type==MouseEvent.MOUSE_OVER)
		 *     Colors.setRGB(sp,0xff0000);
		 *   else Colors.setRGB(sp,0x000000);
		 * }
		 * </listing>
		 */
		public static function setRGB(dp:DisplayObject, cor:Number):void
		{
			var tempCor:ColorTransform=new ColorTransform();
			var tr:Transform = new Transform(dp);
			tempCor.color = cor;
			tr.colorTransform =tempCor;
		}
		
		/**
		 * separa as componentes RGB de um valor hexadecimal
		 * @param	hex
		 * @return Object com atributos r g b
		 */
		static public function hex2RGB ( hex:Number ):Object {
			var rgb:Object = {
				r : (hex & 0xff0000) >> 16,
				g : (hex & 0x00ff00) >> 8,
				b : hex & 0x0000ff 
				}
			return rgb;
		}	
		/**
		 * junta as componentes rgb em um numero
		 * @param	 red 
		 * @param	 green
		 * @param	 blue
		 * @return  Devolve a cor hexadecimal
		 * 
		 * @example O seguinte exemplo cria um degrade de vermelho
		 * <listing version="3.0">
		 * import utils.Colors;
		 * for (var i=0;i<=255;i++)
		 * {
		 * 		this.graphics.beginFill(Colors.RGB2hex(i,0,0));
		 * 		this.graphics.moveTo(0,i);
		 * 		this.graphics.lineTo(200,(i));
		 * 		this.graphics.lineTo(200,(i+1));
		 * 		this.graphics.lineTo(0,(i+1));
		 * 		this.graphics.endFill();
		 * }
		 * </listing>
		 */
		static public function RGB2hex ( red:Number,green:Number,blue:Number ):Number
		{
			return (red << 16) + (green << 8) + blue;
		}
		
		/**
		 * matrix a ser usada no colortransform para aplicar tint a um displayobject
		 * @param	rgb
		 * @param	amount
		 * @return devolve a matrix para o tint
		 * 
		 * @example cria bolas coloridas e depois sempre que clicamos no rato é aplicado um tint com uma cor random
		 * <listing version="3.0">
		 * import utils.Colors;
		 * for(var i=0;i<=100;i++)//criar bolas de tamanho e cor aleatórias
		 * {
		 * 		this.graphics.beginFill(0xffffff*Math.random());
		 * 		this.graphics.drawCircle(Math.random()*stage.stageWidth,Math.random()*stage.stageHeight,10+10*Math.random());
		 * 		this.graphics.endFill();
		 * }
		 * stage.addEventListener(MouseEvent.CLICK,colorize);
		 * function colorize(e:MouseEvent)//sempre que clicamos aplicamos um tint ás bolas de cor random
		 * {
		 * 		var mat=new ColorMatrixFilter(Colors.getTintMatrix(0xffffff*Math.random(), 1));
		 * 		this.filters=[mat];
		 * }</listing>
		 */
		static public function getTintMatrix (rgb:Number, amount:Number=1):Array
		{
			
			var r:Number = ( ( rgb >> 16 ) & 0xff ) / 255;
			var g:Number = ( ( rgb >> 8  ) & 0xff ) / 255;
			var b:Number = (   rgb         & 0xff ) / 255;
			
			var r_lum:Number = 0.212671;
			var g_lum:Number = 0.715160;
			var b_lum:Number = 0.072169;
			
			var inv_amount:Number = 1 - amount;
			
			/*Array(  1,0,0,0,0,
					  0,1,0,0,0,
					  0,0,1,0,0,
					  0,0,0,1,0);
			*/
			var mat:Array = [ 	inv_amount + amount*r*r_lum, 	amount*r*g_lum,  				amount*r*b_lum, 				0, 		0,
								amount*g*r_lum, 				inv_amount + amount*g*g_lum, 	amount*g*b_lum, 				0, 		0,
								amount*b*r_lum,					amount*b*g_lum, 				inv_amount + amount*b*b_lum, 	0, 		0,
								0 , 							0 , 							0 , 							1, 		0 
							];
			
			//bmd.filters = [ new ColorMatrixFilter( mat ) ];
			//	return mat;//concat(mat);
			
			return mat;
		}
		
		/**
		 * Define a cor de selecção de um texto
		 * 
		 * @param	field	TextField
		 * @param	color	uint
		 * 
		 * @example assumindo que _txt 
		 * <listing version="3.0">
		 * import utils.Colors;
		 * var txt = new TextField();
		 * txt.border = true;
		 * txt.text="testes testes";
		 * 
		 * Colors.setFieldSelectionColor(txt,0xff0000);
		 * this.addChild(txt);
		 * </listing>
		 */
		public static function setFieldSelectionColor( field:TextField, color:uint=0, remove:Boolean = false ):void
		{
			var colorTrans:ColorTransform = new ColorTransform();
			if (!remove)
			{
				field.backgroundColor = invert( field.backgroundColor );
				field.borderColor = invert( field.borderColor );
				field.textColor = invert( field.textColor );

				colorTrans.color = color;
				colorTrans.redMultiplier = -1;
				colorTrans.greenMultiplier = -1;
				colorTrans.blueMultiplier = -1;

			}
			
			field.transform.colorTransform = colorTrans;
			
		}
	
		
		protected static function invert( color:uint ):uint
		{
			var colorTrans:ColorTransform = new ColorTransform();
			colorTrans.color = color;
			
			return invertColorTransform( colorTrans ).color;
		}
		
		protected static function invertColorTransform( colorTrans:ColorTransform ):ColorTransform
		{
			with( colorTrans )
			{
				redMultiplier = -redMultiplier;
				greenMultiplier = -greenMultiplier;
				blueMultiplier = -blueMultiplier;
				redOffset = 255 - redOffset;
				greenOffset = 255 - greenOffset;
				blueOffset = 255 - blueOffset;
			}
			
			return colorTrans;
		}

		
	}
	
}