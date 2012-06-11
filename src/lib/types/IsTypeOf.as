package lib.types 
{
	
	import lib.types.Types;
	/**
	 * valida objectos
	 * 
	 * @version 1.01.02
	 * @author (View 2008) Paulo Afonso 
	 * 
	 */
			 
	public class IsTypeOf
	{		
		public function IsTypeOf() 
		{
			
		}
		
		/**
		 * recebe um objecto de qualquer tipo e valida se é um objecto válido do tipo "type". 
		 * Em alguns tipos podemos passar parametros extras.
		 * @version 3.0
		 * @date 10.11.2008
		 * 
		 * @param	obj, objecto a ser avaliado
		 * @param	type, tipos como os que estão declarados na classe Types (utils.types.Types.as), EMAIL, PHONE, etc...
		 * @param	extraOptions, para fazer validações extra, por exemplo, maxChars, minChars, notSpecialChars, etc...<br>
		 * este parâmetro depende do tipo.<br>
		 * Parâmetros suportados:<br>
		 * <b>Types.EMAIL</b> - nenhum<br/>
		 * <b>Types.PHONE</b><br/>
		 * minChars - numero minimo de caracteres<br/>
		 * maxChars - numero máximo de caracteres<br/><br/>
		 * <b>Types.TEXT</b><br/>
		 * minChars - numero minimo de caracteres<br/>
		 * maxChars - numero máximo de caracteres<br/><br/>
		 * <b>Types.PASSWORD</b> - nenhum<br/>
		 * <b>Types.NUMBER</b> - nenhum<br/>
		 * <b>Types.DATE</b><br/>
		 * yearDigits -  numero de digitos para o ano, por default 4<br/>
		 * allowFutureDates - se permite datas para além da de hoje (por default true)<br/><br/>
		 * <b>Types.ALL</b> - nenhum<br/>
		 * 
		 * @return Boolean, true em caso de estar tudo bem, false se detectar algum erro
		 * 
		 * @example O código seguinte valida um objecto do tipo Types.EMAIL:
		 * 
		 * <listing version="3.0">
		 * import utils.types.Types;
		 * import utils.types.IsTypeOf;
		 * 
		 * if (IsTypeOf.validate("email@exemplo.pt", Types.EMAIL))
		 * { 
		 *   trace("EMAIL com formato válido");
		 * }
		 * else {
		 *   trace("EMAIL Inválido");
		 * }
		 * </listing>
		 */

		public static function validate(obj:*, type:String, extraOptions:Object=null):Boolean
		{
			switch (type)
			{
				case Types.EMAIL:
					return validateEmail(obj, extraOptions);
				break;
				
				case Types.PHONE:
					return validatePhone(obj, extraOptions);
				break;
				
				case Types.PASSWORD:
					return validateText(obj, extraOptions);
				break;
				
				case Types.TEXT:
					return validateText(obj, extraOptions);
				break;
				
				case Types.DATE:
					return validateDate(obj, extraOptions);
				break;				
				
				/*
				//TODO: validateNumber
				case Types.NUMBER:
					return validateNumber(obj, extraOptions);
				break;
				*/
				
				case Types.URL:
					return validateURL(obj, extraOptions);
				break;
				
				case Types.ALL:
					return true;
				break;
			}
			
			return false;
		}
		
		/**
		 * Validates e-mail type strings
		 * @param	obj
		 * @param	extraOptions para fazer validações extra, i.e., maxChars, minChars, notSpecialChars, etc...
		 * @return  true / false
		 */

		private static function validateEmail(obj:*, extraOptions:Object=null):Boolean
		{
			if (typeof obj != "string")
			{
				return false;
			}
			var str:String = obj;
			
			if (str.indexOf ("@") > 0)
			{
				if (str.indexOf("@") + 2 < str.lastIndexOf("."))
				{
					if (str.lastIndexOf(".") < str.length - 2)
					{
						return true;
					}
				}
			}
			return false;			
		}
		
		/**
		 * Validates telephone numbers by it's length
		 * @param	obj - 
		 * @param	extraOptions para fazer validações extra, i.e., maxChars, minChars, notSpecialChars, etc...
		 * @return  true / false
		 */
		private static function validatePhone(obj:*, extraOptions:Object=null):Boolean
		{
			if (typeof obj != "string")
			{
				return false;
			}
			
			if (extraOptions == null)
			{
				return obj.length > 0;
			}
			else 
			{
				var tmpResult:Boolean = true;
				if (extraOptions.minChars != null)
				{
					if (obj.length < extraOptions.minChars)
						tmpResult = false;
				}
				if (extraOptions.maxChars != null)
				{
					if (obj.length > extraOptions.maxChars)
						tmpResult = false;
				}
				return tmpResult;
			}
		}
		
		/**
		 * Validates texts by it's length and/or extraOptions if applicable.
		 * @param	obj - 
		 * @param	extraOptions para fazer validações extra, i.e., maxChars, minChars, notSpecialChars, etc...
		 * @return  true / false
		 */
		private static function validateText(obj:*, extraOptions:Object=null):Boolean
		{
			if (typeof obj != "string")
			{
				return false;
			}
			
			if (extraOptions == null)
			{
				return obj.length > 0;
			}
			else 
			{
				var tmpResult:Boolean = true;
				if (extraOptions.minChars != null)
				{
					if (obj.length < extraOptions.minChars)
						tmpResult = false;
				}
				if (extraOptions.maxChars != null)
				{
					if (obj.length > extraOptions.maxChars)
						tmpResult = false;
				}
				return tmpResult;
			}			
		}
		
		/**
		 * Validates dates
		 * @param	obj - 
		 * @param	extraOptions: yearDigits - maximum numbers permitted for the "year" value.
		 * 						  allowFutureDates - true/false - self explanatory.
		 * @return  true / false
		 */		
		private static function validateDate(obj:*, extraOptions:Object=null):Boolean
		{
			 if (typeof obj != "string")
			{
				return false;
			}
			if (obj.length < 0)
			{
				return false;
			}
			var str:String = obj;
			var dateSplitter:String = "";
			if (str.indexOf("/") != -1)
			{
				dateSplitter = "/";
			}
			else
			{
				dateSplitter = "-";
			}
			var dateArray:Array = str.split(dateSplitter);
			
			var currentDate:Date = new Date();
			var currentYear:Number = currentDate.getFullYear();
			
			var dDia:String = dateArray[0];
			var dMes:String = dateArray[1];
			var dAno:String = dateArray[2];
				
			if (extraOptions != null)
			{
				if (extraOptions.yearDigits != null)
				{
					if (String(dAno).length != extraOptions.yearDigits)
					{
						return false;
					}
					if (extraOptions.yearDigits == 2)
					{
						var cYearShort:String = String(currentYear).substr(2, 2);
						if (Number(dAno) <= Number(cYearShort) && Number(dAno) >= 0)
						{
							dAno = String(Number(2000 + Number(dAno)));
							
							//trace ("1. ano: "+dAno)
						}
						else
						{
							dAno = String(Number(1900 + Number(dAno)));
							
							//trace ("2. ano: "+dAno)
						}
					}
				}
				
				if (extraOptions.allowFutureDates == false)
				{
					if (isFutureDate(Number(dDia), (Number(dMes) - 1), Number(dAno), extraOptions.allowFutureDates))
						return false;
				}
			}
			
			var d:Date = new Date(Number(dAno), Number(dMes) - 1, Number(dDia));		
			return (Number(dAno)==d.getFullYear() && (Number(dMes)-1)==d.getMonth() && Number(dDia)==d.getDate());
		}
		
		/**
		 * Verifica se a data submetida pela função "validateDate" é futura ou não. Caso o seja, compara com o
		 * valor fornecido nas extraOptions do objecto de data e devolve true ou false.
		 * @param	dia
		 * @param	mes
		 * @param	ano 
		 * @param	valor - boolean
		 * @return	true / false
		 */
		private static function isFutureDate(dia:Number, mes:Number, ano:Number, valor:Boolean):Boolean
		{
			var actualDate:Date = new Date();
			var aDateTimestamp:Number = actualDate.getTime();
			
			var testDate:Date = new Date (ano, mes, dia);
			var tDateTimestamp:Number = testDate.getTime();
			
			return (valor == (aDateTimestamp > tDateTimestamp));
		}
		
		/**
		 * 
		 * @param	obj
		 * @param	extraOptions 
		 * @return  true / false
		 */
		private static function validateURL(obj:*,extraOptions:Object=null):Boolean
		{
			if (typeof obj != "string")
			{
				return false;
			}
			var str:String = obj;
			
			if (str.indexOf ("@") > 0)
			{
				if (str.indexOf("@") + 2 < str.lastIndexOf("."))
				{
					if (str.lastIndexOf(".") < str.length - 2)
					{
						return true;
					}
				}
			}
			return false;			
		}
	}	
}