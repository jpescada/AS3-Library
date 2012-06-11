package lib.media.video 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	
	import flash.utils.*;
	
	import flash.media.Video;
	import flash.events.NetStatusEvent;
    import flash.net.NetConnection;
    import flash.net.NetStream;
	
	import flash.display.Sprite;
	
	import flash.display.*;
	
	import flash.media.SoundTransform;

	//import customVideoClient;
	
	import flash.net.ObjectEncoding;
	import flash.events.SecurityErrorEvent;
	import flash.events.AsyncErrorEvent;
	
	import lib.media.video.VideoControllerEvent;
	

	/**
	 * VideoController
	 * @author Paulo Afonso
	 * @version 1.1
	 * @lastUpdate 15/06/2009
	 * 
	 * @example 
	 * vd = new VideoController(videoHolder_mc, 340, 254);
	 * //vd.soundVolume = 1;
	 * vd.addEventListener(VideoControllerEvent.VIDEO_END, onVideoEnd);
	 * 
	 * vd.addEventListener(NetStatusEvent.NET_STATUS, onNetStatus);
	 * vd.addEventListener(VideoControllerEvent.TIME_CHANGED, onTimeChange);
	 * vd.addEventListener(VideoControllerEvent.LOADED_CHANGED, onLoadedChange);
	 * 
	 * function onLoadedChange(e:VideoControllerEvent)
	 * {
	 * trace (vd.bytesTotal, " # ",vd.bytesLoaded, " # ",vd._percentLoaded);
	 * }
	 * 
	 * function onTimeChange(e:VideoControllerEvent)
	 * {
	 * trace (vd.timePlayed, " # ",vd.timeTotal);
	 * }
	 */
	
	public class VideoController  implements IEventDispatcher
	{
		
		private var _timePlayed:Number;//posicao actual no videm em segundos
		private var _timeTotal:Number;//tempo total do video em segundos
		
		private var _bufferLenght:Number;//buffer ocupado
		
		private var intervalChecking:Number;
		
		public var metaData:Object;//cópia dos dados da metadata
		public var cuePoints:Object;//cópia dos cuepoints
		
		private var netConVideo:NetConnection;
		public var netStmVideo:NetStream;
		
		public var _initTimeDownload:Number;
		public var _initCacheDownload:Number;
		public var _mediaDownload:Number;
		
		public var _videoObject:Video;//link para o video
		private var _videoTarget:Sprite;//link para o video
		
		private var _bytesLoaded:Number=0;//bytes carregados do video
		private var _bytesTotal:Number=0;//bytes total do video
		
		private var _execuntigFunction:Number=0;
		
		private var _isLoadedMetaData:Boolean=true;
		

		private var _detectingEnd:Boolean=false;//teel to the processor if is close to the end
		
		private var disp:EventDispatcher = new EventDispatcher() ;
		
		private var volumeVideo:SoundTransform=new SoundTransform();//
		
		public var isSeeking:Boolean=false;
		
		private var _bufferEmpty:Boolean=true;
		
		private var _bufferFlush:Boolean;
		
		//cacehd video
		private var _fileCached:String;
		private var _cachedNetConVideo:NetConnection;
		private var _cachedNetStmVideo:NetStream;
		private var _cachedVideoObject:Video;
		
		private var _cacheBufferEmpty:Boolean=true;
	    private var _cacheBufferFlush:Boolean;
	    private var _cacheDetectingEnd:Boolean=false;
		
		private var _removeNetStmVideo:NetStream;


		private var _actualStream:String;

		
		private var streamingNetConVideo:NetConnection;

		private var _isStreaming:Boolean = false;
		
		public var _bufferTime:Number = 3;
		
		public function VideoController(videoTarget:Sprite,width:Number=320,height:Number=240) {
			
			NetConnection.defaultObjectEncoding = ObjectEncoding.AMF0;
			
			disp = new EventDispatcher() ;
	
			
			netConVideo =new NetConnection();
			streamingNetConVideo = new NetConnection();
			netConVideo.connect(null)
			
			_videoTarget=videoTarget;

			
			netStmVideo=new NetStream(netConVideo);
			netStmVideo.client = this;
			netStmVideo.bufferTime = _bufferTime;
			netStmVideo.addEventListener(NetStatusEvent.NET_STATUS, netstat);
						
			_videoObject=new Video(width,height);
			_videoObject.attachNetStream(netStmVideo);
			
			_videoTarget.addChild(_videoObject);
			
			_videoObject.smoothing=true;
			
			this.soundVolume=1;
			
			//cache
			_fileCached="";
			
		}
		
		public function cacheVideo(fileCached:String, xp:Number=0){
			

				trace("CACHE VIDEO:" , fileCached, xp);
				
				if (_cachedNetStmVideo!=null && _cachedNetStmVideo!=netStmVideo){
					_cachedNetStmVideo.close();
					_cachedNetStmVideo.removeEventListener(NetStatusEvent.NET_STATUS, cacheNetstat);
				}

					
					
				
								
				_cachedNetStmVideo = new NetStream(netConVideo);
				_cachedNetStmVideo.bufferTime = _bufferTime;
				//_cachedNetStmVideo.client = this;
				_cachedNetStmVideo.client = (new customVideoClient());
				_cachedNetStmVideo.addEventListener(NetStatusEvent.NET_STATUS, cacheNetstat);

			
				_fileCached=fileCached;
				
				_cacheBufferEmpty=false;
				_cacheBufferFlush=false;
				_cacheDetectingEnd=false;
				
				_cachedNetStmVideo.play(_fileCached,0);
				_cachedNetStmVideo.pause();

			
			
			
		}
		
/*
	dispatchEvent métodos para implementar IEventDispatcher
*/		
		//para poderem ser chamados externamenta á classe
		public function dispatchEvent(iEvent:Event):Boolean {
			return disp.dispatchEvent(iEvent);
		}
		public function removeEventListener(iType:String, iFunction:Function, iUseCapture:Boolean = false):void {
			disp.removeEventListener(iType, iFunction, iUseCapture);
		}
		public function hasEventListener(iType:String):Boolean {
			return disp.hasEventListener(iType);
		}
		public function addEventListener(iType:String, iFunction:Function, iUseCapture:Boolean = false, iPriority:int = 0, iUseWeakReference:Boolean = false):void {
			disp.addEventListener(iType, iFunction);
		}
		public function willTrigger(iType:String):Boolean {
			return disp.willTrigger(iType);
		}
		
	/*
	onXMPData
*/	
		public function onXMPData(p_info:Object):void 
		{
			trace("onXMPData");
		}
		
/*
	onMetaData
*/
		public function onMetaData(p_info:Object):void{

			trace("Metadata loaded");
			_isLoadedMetaData=true;
			this.cuePoints=p_info["cuePoints"];
			this._timeTotal=p_info.duration;
			this.metaData=p_info;
		
			clearInterval(intervalChecking);
			intervalChecking=setInterval(verifyData,100,this);
			this.disp.dispatchEvent(new VideoControllerEvent(VideoControllerEvent.METADATA_LOADED));
			_videoObject.alpha = 1;
			

		}
/*
	onCuePoint

*/
		public function onCuePoint(p_info:Object):void{

			this.disp.dispatchEvent(new VideoControllerEvent(VideoControllerEvent.CUEPOINT_LOADED));
		}
		 
		
/*
	change video size

*/
	public function changeVideoSize(w:Number,h:Number){
		_videoObject.width = w;
		_videoObject.height = h;

		this.disp.dispatchEvent(new VideoControllerEvent(VideoControllerEvent.SIZE_CHANGED));
		
	}
	public function onLastSecond(e) {
	}
/*
isOriginalSize
*/
	public function isOriginalSize():Boolean{
		try{
		if (_videoObject.width == metaData.width && _videoObject.height== metaData.height)
			return true;
		else return false;
		}catch (e){
			return false;
		}
		return false;
	}
/*
	verifyData
	verifica se o tempo decorrido sofreu alteração, caso afirmativo invoca o listner onTimeChanged
	verifica se a percentagem de loaded do filme sofreu alteração, caso afirmativo invo o listner onLoadedChanged
*/
		public function verifyData(){
			
			if (arguments[0]._detectingEnd){//para detectar o fim do flv
				if (arguments[0].netStmVideo.bufferLength==0 && !arguments[0].isSeeking){
					//_backward
					
					if (arguments[0]._detectingEnd){
							arguments[0].disp.dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_END));
							arguments[0]._detectingEnd=false;
						}
				}
			}
			
			if (arguments[0].netStmVideo.time !=arguments[0]._timePlayed ){//quando otempo tocado é alterado
				arguments[0]._timePlayed=arguments[0].netStmVideo.time;
				arguments[0].disp.dispatchEvent(new VideoControllerEvent(VideoControllerEvent.TIME_CHANGED));
			}else if (arguments[0].netStmVideo.time ==arguments[0]._timePlayed ){//bug do player
			/*
			
			BUG WORKAROUND
			
			Segundo alguma pesquisa, alguns videos codificados com programas não adobe 
			podem causar o não envio do evento NetStream.Play.Stop
			
			*/
				//se temos o buffer vazio, o server terminou de enviar dados e não estamos em seeking
				if (arguments[0]._bufferEmpty && arguments[0]._bufferFlush && !arguments[0].isSeeking){
					//se o tempo executado é maior que o tempo total menos 1 segundo
					//1 segundo porque a meta duration não tem o tempo exacto, como consequencia podemos perder pares do final do video
					//if (arguments[0]._timePlayed>_timeTotal-1){
						
						if (arguments[0]._detectingEnd){
							arguments[0].disp.dispatchEvent(new VideoControllerEvent(VideoControllerEvent.VIDEO_END));
							arguments[0]._detectingEnd=false;
						}
						

					//}
				}
			/*
			END BUG WORKAROUND
			*/
				
			}
			
			/*
			
			if (arguments[0]._bufferLenght != arguments[0].netStmVideo.bufferLength){//verificar alterações do ocupado no buffer
				arguments[0]._bufferLenght=arguments[0].netStmVideo.bufferLength;
				arguments[0].disp.dispatchEvent(new Event("onBufferChange"));
			}*/
			
			
			if (arguments[0].bytesLoaded !=  arguments[0].netStmVideo.bytesLoaded || arguments[0].bytesTotal !=  arguments[0].netStmVideo.bytesTotal ){

				if (arguments[0]._bytesLoaded==0){
					arguments[0]._initTimeDownload=(new Date().time);
					arguments[0]._initCacheDownload=arguments[0]._bytesLoaded;
				}
				
				arguments[0]._bytesLoaded=arguments[0].netStmVideo.bytesLoaded;
				arguments[0]._bytesTotal=arguments[0].netStmVideo.bytesTotal;
				
				// estima media de download
				var diferencaTempo=(new Date().time)-arguments[0]._initTimeDownload ;

					if ((arguments[0]._initCacheDownload==0))
						arguments[0]._initCacheDownload=arguments[0].netStmVideo.bytesLoaded;

					arguments[0]._mediaDownload=(((arguments[0].netStmVideo.bytesLoaded-arguments[0]._initCacheDownload)/1024)//to k's
								/( (diferencaTempo) /1000) //to seconds
								);

			   // ******************************************************
				
				arguments[0].disp.dispatchEvent(new VideoControllerEvent(VideoControllerEvent.LOADED_CHANGED));
			}
		}
	
/*
	Stop
		Para o video
*/
		public function stop(){
			netStmVideo.pause();
			try
			{
				netStmVideo.seek(0);
			}catch (e:Error) { trace ("ERRO SEEK 4");  };
								
		}
/*
	Stop
		Para o video
*/
		public function pause(){
			netStmVideo.pause();
		
								
		}
		
		/*
		Executa o video
		*/
		public function StreamingNetStatusHandler(event) {
			trace ("event.info.code"+event.info.code);
			if (event.info.code=="NetConnection.Connect.Success"){
				netStmVideo=new NetStream(streamingNetConVideo);
				netStmVideo.client = this;
				netStmVideo.addEventListener(NetStatusEvent.NET_STATUS, netstat);
				netStmVideo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				_videoObject.attachNetStream(netStmVideo);
					
			 	netStmVideo.bufferTime=_bufferTime;
				trace ("play stream:" +_actualStream);
				
				netStmVideo.play(_actualStream,true);
				_videoObject.alpha=1;
				streamingNetConVideo.removeEventListener(NetStatusEvent.NET_STATUS, StreamingNetStatusHandler);
				
				this.soundVolume=volumeVideo.volume;
				
			}
			
			
		}
		public function OnFI(e):void{
				//
			}
		public function onBWDone():void{
				//
			}
			
		public function securityErrorHandler(event:SecurityErrorEvent):void {
			trace("securityErrorHandler");   
		}

		public function playStream(_url:String,_stream:String){
			netStmVideo.close();
			_videoObject.clear();
			
			this._actualStream=_stream;

			streamingNetConVideo.addEventListener(NetStatusEvent.NET_STATUS, StreamingNetStatusHandler);
			
			streamingNetConVideo.close();
			streamingNetConVideo.client = this;
			trace("Connect :"+_url),
			streamingNetConVideo.connect(_url);
			
			
			
			_isStreaming=true;
			
			
		}
		public function play(...args){
			_videoObject.clear();
			netStmVideo.close();
			streamingNetConVideo.close();
			
			_isStreaming=false;
		
			
			if (!_isLoadedMetaData) return;

			//netStmVideo.close();
			if (typeof(args[0])=="string"){//se receber uma string como paramentro (url)
				
			
				netStmVideo.close();
				_videoObject.clear();
				
				if (_fileCached==args[0]){//if file is in cache
					netStmVideo.removeEventListener(NetStatusEvent.NET_STATUS, netstat);
					
					netStmVideo.close();
					
				
					
					netStmVideo=null;
					
					clearInterval(intervalChecking);
					
					_cachedNetStmVideo.removeEventListener(NetStatusEvent.NET_STATUS, cacheNetstat);
					_fileCached="";
					netStmVideo=_cachedNetStmVideo;
					
					
					netStmVideo.resume();
					
					

					_isLoadedMetaData=_cachedNetStmVideo.client._isLoadedMetaData;

					_videoObject.attachNetStream(_cachedNetStmVideo);
					
					if (_isLoadedMetaData){
						
						this.cuePoints=_cachedNetStmVideo.client.metaData["cuePoints"];
						this._timeTotal=_cachedNetStmVideo.client.metaData.duration;
						this.metaData=_cachedNetStmVideo.client.metaData;
					
						
						clearInterval(intervalChecking);
					    intervalChecking=setInterval(verifyData,100,this);
						this.disp.dispatchEvent(new VideoControllerEvent(VideoControllerEvent.METADATA_LOADED));
						_videoObject.alpha=1;
						

					}
					
					
					netStmVideo.client=this;
					netStmVideo.addEventListener(NetStatusEvent.NET_STATUS, netstat);
					
					_bufferEmpty=_cacheBufferEmpty;
					_bufferFlush=_cacheBufferFlush;
					
					_detectingEnd=_cacheDetectingEnd;
					
					
					
				}else{//file is not in cache
				
					
					 	 netStmVideo.removeEventListener(NetStatusEvent.NET_STATUS, netstat);
						 netStmVideo.close();
						 _removeNetStmVideo=netStmVideo;
						 _removeNetStmVideo.close();
						// _removeNetStmVideo.
						
						 netStmVideo=null;
						
						
						 clearInterval(intervalChecking);
					
					  if (_cachedNetStmVideo!=null){
						
					 	 _cachedNetStmVideo.removeEventListener(NetStatusEvent.NET_STATUS, cacheNetstat);
						 _cachedNetStmVideo.close();
						 //netConVideo.close();
						 _cachedNetStmVideo=null;
						 _fileCached="";
						
						
					 }
					  
						  netStmVideo = new NetStream(netConVideo);
						  netStmVideo.bufferTime = _bufferTime;
						  netStmVideo.client = this;
						 
						  netStmVideo.addEventListener(NetStatusEvent.NET_STATUS, netstat);
						 _videoObject.attachNetStream(netStmVideo);
					
					
						  netStmVideo.bufferTime=_bufferTime;
						
						_bytesLoaded=0;
						_bytesTotal=0;
						_bufferLenght=0;
						_bufferFlush=false;
				
						_bufferEmpty=true;
						
						_initTimeDownload=new Date().time;
						_mediaDownload=0;
						_initCacheDownload=0;
						
						
						 _videoObject.alpha=0;
	
						_isLoadedMetaData=false;
						netStmVideo.play(args[0],0);//toca o url	
					
					//},1000);
				
				}
				
				
			}else {
				netStmVideo.resume();//faz resume ao video
			}
			
			this.soundVolume=volumeVideo.volume;
			
			
			
            
			

		}
public function cacheNetstat(stats:NetStatusEvent) {
		trace ("cacheNetstat"+stats.info.code);
			if (stats.info.code=="NetStream.Play.Start")
				_cacheDetectingEnd=false;
				
			if (stats.info.code=="NetStream.Play.Stop"){//parou o download
				_cacheDetectingEnd=true;
			} 
			
			if (stats.info.code=="NetStream.Buffer.Flush"){//parou o download
				_cacheBufferFlush=true;
			} 
			
			if (stats.info.code=="NetStream.Buffer.Full"){//parou o download
				_cacheBufferEmpty=false;
			} 
			if (stats.info.code=="NetStream.Buffer.Empty"){//parou o download
				_cacheBufferEmpty=true;
			}
			if ("NetStream.Seek.Notify"==stats.info.code){
				isSeeking=false;
			}
			
			disp.dispatchEvent(stats);
}
		/*
			disptach netStatusEvent
			
		*/
		
		public function netstat(stats:NetStatusEvent) {


		trace ("netstat"+stats.info.code);
			
			if ("NetStream.Seek.Notify"==stats.info.code){
				isSeeking=false;
			}
				
				
			
			//caso existiu tentativa de fazer seek para uma posição inválida
			if (stats.info.code=="NetStream.Seek.InvalidTime"){//para o seek do knob
			
				try{
					netStmVideo.seek(stats.info.details);//faz seek para a ultima posicao válida
				}catch (e:Error) { trace ("ERRO SEEK 5");  };
			
				//isSeeking=false;
			}
			if (stats.info.code=="NetStream.Play.Start")
				_detectingEnd=false;
				
			if (stats.info.code=="NetStream.Play.Stop"){//parou o download
				_detectingEnd=true;
			} 
			
			if (stats.info.code=="NetStream.Buffer.Flush"){//parou o download
				_bufferFlush=true;
			} 
			
			if (stats.info.code=="NetStream.Buffer.Full"){//parou o download
				_bufferEmpty=false;
			} 
			if (stats.info.code=="NetStream.Buffer.Empty"){//parou o download
				_bufferEmpty=true;
			} 
			//_bufferEmpty

			
			disp.dispatchEvent(stats);//caso exista algum listner fora da classe para o NetStatusEvent
        }
		/*
			adicioanr ou remover smooth ao video
		*/
		public function toogleSmooth(event:MouseEvent):void{
			_videoObject.smoothing=!_videoObject.smoothing;
		}
		/*
		Resume/pause o video
		*/
		public function tooglePlayPause(){
			
			netStmVideo.togglePause();
			
		}
		/*
		Resume o video
		*/
		public function resume(){
	
			if (_isStreaming){
				netStmVideo.resume();
				netStmVideo.play(_actualStream,true);
			}else netStmVideo.resume();
		}
		
		//SET
		
		public function set timePlayed(tempo:Number){
			

				if (tempo < 0)
				{
					try
					{
					netStmVideo.seek(0);
					}catch (e:Error) { trace ("ERRO SEEK 1");  };
				}
				else if (tempo > _timeTotal)
				{
					try {
						netStmVideo.seek(_timeTotal)
					
					}catch (e:Error) { trace ("ERRO SEEK 2");  };
				}
				else 
				{
					try {
						netStmVideo.seek(tempo);
					}catch (e:Error) { trace ("ERRO SEEK 3");  };
				}

		}
		
		public function set soundVolume(vol:Number){

			var temp=Math.round(vol*10)/10;
			volumeVideo.volume=temp;
			netStmVideo.soundTransform=volumeVideo; 
			
		}
		
	
	    // GETS
		public function get soundVolume():Number{

			return volumeVideo.volume;
			
		}
		/*
		Devolve a percentagem do video carregado
		*/
		public function get _percentLoaded():Number{
			return this._bytesTotal/this._bytesLoaded;
		}
		/*
		Devolve a percentagem do video carregado
		*/
		public function get bytesTotal():Number{
			return this._bytesTotal;
		}
		/*
		Devolve a percentagem do video carregado
		*/
		public function get bytesLoaded():Number{
			return this._bytesLoaded;
		}
		/*
		Devolve o buffer aconselhado para visualizar o restante do filme evitando ao máximo possiveis paragens
		*/
		public function get recomendedBufferTime():Number{
			var tempoRestanteVisualizacao=(this._timeTotal-this._timePlayed);//to seconds
			//var tempoRestanteCarregamento=
			var kBytesRestantes=(this._bytesTotal-this._bytesLoaded)/1024;//to kb
			
			return (kBytesRestantes/_mediaDownload)-tempoRestanteVisualizacao;//seconds
			
			
		}
		/*
		Devolve o tempo executado
		*/
		
		public function get timePlayed():Number{
			return this._timePlayed;
		}
		/*
		Devolve o tempo total do video
		*/
		
		public function get timeTotal():Number{
			return this._timeTotal;
		}
		
		public function get myVideo():Video{
			return _videoObject;
		}
		public function get myVideoTarget():Sprite{
			return _videoTarget;
		} 
		/*
		Devolve o tempo guardado em buffer
		*/
		
		public function get bufferLenght():Number{
			return this._bufferLenght;
		}
		/*
		Devolve os kbps médios para download do video
		*/
		
		public function get mediaDownload():Number{
			return this._mediaDownload;
		}
		/*
			verificar se já foi loaded a meta data
		*/
		public function get isLoadedMetaData():Boolean{
			return this._isLoadedMetaData;
		}
		/*
		
		
		*/
		public function get smoothing():Boolean{
			return _videoObject.smoothing;
		}
		/*
		
		*/
		public function get isStreaming():Boolean{
			return _isStreaming;
		}
		
		
	
		
		
		
		
	}
}


	class customVideoClient {
		
		public var _isLoadedMetaData:Boolean=false;
		public var metaData:Object;//cópia dos dados da metadata
	
		public function customVideoClient(){
		}
		
		public function onMetaData(info:Object):void {
	
			trace("metadata 2 loaded");	
			_isLoadedMetaData=true;

				this.metaData=info;
				

		}
		public function onXMPData(p_info:Object):void 
		{
			trace("onXMPData");
		}
		public function onCuePoint(info:Object):void {
		   
		}
	}