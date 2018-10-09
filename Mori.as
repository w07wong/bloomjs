package
{
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.errors.EOFError;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.events.ProgressEvent;
   import flash.events.SecurityErrorEvent;
   import flash.events.TimerEvent;
   import flash.net.Socket;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.navigateToURL;
   import flash.system.Security;
   import flash.utils.Timer;
   import flash.utils.getDefinitionByName;
   import flash.utils.setInterval;
   import flash.utils.setTimeout;
   import mx.binding.Binding;
   import mx.binding.IBindingClient;
   import mx.binding.IWatcherSetupUtil;
   import mx.collections.ArrayCollection;
   import mx.containers.Canvas;
   import mx.containers.HBox;
   import mx.controls.Alert;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.LinkButton;
   import mx.controls.Text;
   import mx.core.Application;
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.effects.Blur;
   import mx.effects.Fade;
   import mx.effects.Zoom;
   import mx.effects.easing.Cubic;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.managers.PopUpManager;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   public class Mori extends Application implements IBindingClient
   {
      
      private static const HOST_NAME:String = "memento.ieor.berkeley.edu";
      
      private static const connectionLostMessage:String = "Connection Lost";
      
      private static const timeOutMessage:String = "Live data is currently unavailable. Displaying prerecorded data.";
      
      private static const PORT_NUMBER:int = 6021;
      
      mx_internal static var _Mori_StylesInit_done:Boolean = false;
      
      private static const connectionClosedMessage:String = "Hit reload for another 5 minutes of data";
      
      private static const maxBufferSize:int = 100000;
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private static const socketErrorMessage:String = "Live data is currently unavailable. Displaying prerecorded data.";
      
      private static const dataFileNameRoot:String = "data";
      
      private static const allChannelsBusyMessage:String = "Sorry! All client connections to Memento Mori are currently in use. Please try again in 10 minutes.";
       
      
      private var _289929120paletteImage:Image;
      
      mx_internal var _bindings:Array;
      
      private var imageReady:Boolean;
      
      private var lastBreak:int = 0;
      
      private var loader:URLLoader;
      
      private var appletStartTime:Number;
      
      private var regularStripe:Number = 30;
      
      private var socketStartTime:Number;
      
      private var animationTimer:Timer;
      
      private var imageWidth:int;
      
      private var sumOfSizes:Number;
      
      private var flowerIndex:int;
      
      private var enoughData:Boolean;
      
      private var _336650556loading:Label;
      
      private var traceMiddle:Number;
      
      private var thinStripe:Number = 10;
      
      private var speed:int = 3;
      
      private var millisecInterval:int = 85;
      
      private var delayedSamples:ArrayCollection;
      
      private var startTime:Number;
      
      private var breaks:ArrayCollection;
      
      private var imageLoader:Loader;
      
      private var _1364013995center:Label;
      
      private var waitInterval:int;
      
      private var numberOfPeaks:int;
      
      private const animationDelay:Number = 350;
      
      private var bufferSize:int;
      
      private var imageHeight:int;
      
      public var old_color_map:String;
      
      private var errors:Boolean;
      
      mx_internal var _bindingsByDestination:Object;
      
      private var absoluteMax:int = 2000;
      
      private var socket:Socket;
      
      private var firstSampleReceived:Boolean = false;
      
      private var numPackets:int;
      
      private var _1185106329imgCls:Class;
      
      private var zoomDuration:int = 600;
      
      private var averageSampleValue:int;
      
      private var hasAdded:Boolean;
      
      private var firstDelayed:Boolean;
      
      private var maxNumFlowers:int = 18;
      
      private var maxToStop:int = 500;
      
      private var fakeFlowerIndex:int = 0;
      
      private var minToDisplay:int = 1000;
      
      private var imageData:BitmapData;
      
      private var readSingleByte:Boolean;
      
      private var samplesBuffer:ArrayCollection;
      
      private var startPosition:int;
      
      private var bufferCount:int = 0;
      
      private var packetSize:int;
      
      private var prevY:int = 0;
      
      private var bytesToIgnore:int;
      
      private var averageProportion:Number;
      
      private var _786725065mainDisplay:UIComponent;
      
      private var colorImage:Image;
      
      private var running:Boolean = false;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      mx_internal var _watchers:Array;
      
      private var BHZ:Boolean;
      
      private var whatsLeft:int;
      
      private var totalPacketLoadTime:Number;
      
      private var readFromStart:Boolean;
      
      private var timeCoordinates:ArrayCollection;
      
      private var dataFileName:String = "data.txt";
      
      private var _3343801main:Canvas;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var moreThanAbsoluteMax:int = 2200;
      
      private var animationBegun:Boolean = false;
      
      public function Mori()
      {
         _documentDescriptor_ = new UIComponentDescriptor({
            "type":Application,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Canvas,
                  "id":"main",
                  "events":{"creationComplete":"__main_creationComplete"},
                  "stylesFactory":function():void
                  {
                     this.backgroundColor = 16777215;
                     this.backgroundAlpha = 1;
                     this.horizontalCenter = "1";
                     this.verticalCenter = "1.5";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "alpha":1,
                        "percentWidth":100,
                        "percentHeight":100
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":UIComponent,
                  "id":"mainDisplay",
                  "propertiesFactory":function():Object
                  {
                     return {"percentHeight":100};
                  }
               }),new UIComponentDescriptor({
                  "type":Image,
                  "id":"paletteImage",
                  "propertiesFactory":function():Object
                  {
                     return {"visible":false};
                  }
               }),new UIComponentDescriptor({
                  "type":Label,
                  "id":"center",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":298,
                        "y":179,
                        "text":"Label",
                        "visible":false
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Label,
                  "id":"loading",
                  "stylesFactory":function():void
                  {
                     this.fontWeight = "bold";
                     this.fontSize = 18;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "text":"Loading...",
                        "visible":true
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":HBox,
                  "stylesFactory":function():void
                  {
                     this.backgroundColor = 14540253;
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "height":20,
                        "percentWidth":100,
                        "visible":false,
                        "includeInLayout":false,
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Text,
                           "stylesFactory":function():void
                           {
                              this.fontWeight = "bold";
                              this.fontSize = 16;
                              this.fontFamily = "Arial";
                              this.color = 4418163;
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "text":"Bloom",
                                 "visible":true
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":LinkButton,
                           "events":{"click":"___Mori_LinkButton1_click"},
                           "stylesFactory":function():void
                           {
                              this.color = 0;
                              this.fontWeight = "bold";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"label":"About"};
                           }
                        }),new UIComponentDescriptor({
                           "type":LinkButton,
                           "events":{"click":"___Mori_LinkButton2_click"},
                           "stylesFactory":function():void
                           {
                              this.color = 0;
                              this.fontWeight = "bold";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"label":"Control Panel"};
                           }
                        })]
                     };
                  }
               })]};
            }
         });
         _1185106329imgCls = Mori_imgCls;
         old_color_map = TunableParameters.COLOR_MAP;
         _bindings = [];
         _watchers = [];
         _bindingsByDestination = {};
         _bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration();
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.horizontalAlign = "center";
            this.backgroundColor = 16777215;
         };
         mx_internal::_Mori_StylesInit();
         this.layout = "absolute";
         this.alpha = 1;
         this.visible = true;
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         Mori._watcherSetupUtil = param1;
      }
      
      public static function RGBtoH(param1:Number, param2:Number, param3:Number) : Number
      {
         var _loc4_:Number = Math.max(param1,param2,param3);
         var _loc5_:Number = Math.min(param1,param2,param3);
         var _loc6_:Number = _loc4_ - _loc5_;
         var _loc7_:Number = 0;
         if(param1 == _loc4_)
         {
            _loc7_ = (param2 - param3) / _loc6_;
         }
         else if(param2 == _loc4_)
         {
            _loc7_ = 2 + (param3 - param1) / _loc6_;
         }
         else
         {
            _loc7_ = 4 + (param1 - param2) / _loc6_;
         }
         return _loc7_;
      }
      
      public static function RGBtoV(param1:Number, param2:Number, param3:Number) : Number
      {
         return Math.max(param1,param2,param3);
      }
      
      public function readFromStream(param1:int) : void
      {
         var temp:int = 0;
         var numSamples:int = param1;
         var i:int = 0;
         while(i < numSamples)
         {
            if(i < numSamples - 1 && socket.bytesAvailable == 4 || socket.bytesAvailable < 4)
            {
               readFromStart = false;
               bytesToIgnore = 4 - socket.bytesAvailable;
               whatsLeft = packetSize - i - Math.ceil(bytesToIgnore / 4);
               if(BHZ && socket.bytesAvailable == 4)
               {
                  temp = socket.readInt();
                  if(Math.abs(temp) < 1000000)
                  {
                     samplesBuffer.addItemAt(temp,bufferCount % maxBufferSize);
                     bufferCount++;
                  }
                  else
                  {
                     socket.readByte();
                  }
               }
               else
               {
                  socket.readUTFBytes(socket.bytesAvailable);
               }
               break;
            }
            if(socket.bytesAvailable >= 4)
            {
               if(BHZ)
               {
                  try
                  {
                     temp = socket.readInt();
                     if(Math.abs(temp) > 1000000)
                     {
                        trace("Byte alignment broken...realigning");
                        socket.readByte();
                     }
                     else
                     {
                        trace(temp + "");
                        samplesBuffer.addItemAt(temp,bufferCount % maxBufferSize);
                        bufferCount++;
                     }
                  }
                  catch(err:Error)
                  {
                  }
               }
               else
               {
                  socket.readInt();
               }
            }
            i++;
         }
      }
      
      public function launchAnimation() : void
      {
         preparePalette();
         setInterval(onFlowerTimer,animationDelay);
      }
      
      public function loadDataFromFile() : void
      {
         var dataFileName:String = null;
         samplesBuffer = new ArrayCollection();
         dataFileName = "data.txt";
         loader.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
         try
         {
            loader.load(new URLRequest(dataFileName));
         }
         catch(error:Error)
         {
            trace("Unable to load prerecorded data from file " + dataFileName);
         }
         loader.addEventListener(Event.COMPLETE,onLoaderComplete);
      }
      
      public function init() : void
      {
         Security.allowDomain("memento.ieor.berkeley.edu");
         Security.loadPolicyFile("xmlsocket://" + "memento.ieor.berkeley.edu" + ":" + "843");
         totalPacketLoadTime = 0;
         sumOfSizes = 0;
         numberOfPeaks = 0;
         averageProportion = 0;
         numPackets = 0;
         prevY = main.height / 2;
         appletStartTime = new Date().valueOf();
         enoughData = false;
         flowerIndex = 0;
         breaks = new ArrayCollection();
         lastBreak = 0;
         errors = false;
         readSingleByte = true;
         readFromStart = true;
         BHZ = false;
         samplesBuffer = new ArrayCollection();
         launchAnimation();
         animationBegun = true;
         socket = new Socket();
         socket.addEventListener(ProgressEvent.SOCKET_DATA,onSocketData);
         socket.addEventListener("close",onSocketClose);
         socket.addEventListener("ioError",onSocketClose);
         socket.addEventListener("securityError",onSocketClose);
         socketStartTime = new Date().valueOf();
         socket.connect(HOST_NAME,PORT_NUMBER);
      }
      
      public function __main_creationComplete(param1:FlexEvent) : void
      {
         init();
      }
      
      public function openControlPanel() : void
      {
         var _loc1_:IFlexDisplayObject = PopUpManager.createPopUp(this,ControlPanel,false);
         PopUpManager.centerPopUp(_loc1_);
      }
      
      public function handleLinkButton() : void
      {
         navigateToURL(new URLRequest("info.html"),"_blank");
      }
      
      private function _Mori_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = imgCls;
         _loc1_ = this.width / 2 - 50;
         _loc1_ = this.height / 2 - 50;
      }
      
      public function onLoaderComplete(param1:Event) : void
      {
         var _loc4_:int = 0;
         var _loc2_:Array = String(loader.data).split("\n");
         if(_loc2_.length == 0)
         {
            loadDataFromFile();
            return;
         }
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = int(_loc2_[_loc3_]);
            samplesBuffer.addItem(_loc4_);
            _loc3_++;
         }
         if(samplesBuffer.length > 300)
         {
            enoughData = true;
            launchAnimation();
         }
      }
      
      public function getColorH(param1:uint) : Number
      {
         var _loc2_:uint = param1;
         var _loc3_:* = _loc2_ >> 16 & 255;
         var _loc4_:* = _loc2_ >> 8 & 255;
         var _loc5_:* = _loc2_ & 255;
         return RGBtoH(_loc3_ / 255,_loc4_ / 255,_loc5_ / 255);
      }
      
      [Bindable(event="propertyChange")]
      public function get loading() : Label
      {
         return this._336650556loading;
      }
      
      public function onFlowerTimer(param1:TimerEvent = null) : void
      {
         var _loc3_:Number = NaN;
         var _loc5_:int = 0;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc2_:int = value(samplesBuffer,lastBreak);
         _loc3_ = runningAverage(samplesBuffer,flowerIndex,10);
         var _loc4_:Array = minmax(samplesBuffer,flowerIndex);
         _loc5_ = _loc4_[0];
         loading.visible = false;
         loading.includeInLayout = false;
         if(_loc5_ != 0)
         {
            _loc6_ = Math.abs(_loc5_);
            _loc7_ = _loc4_[1];
            _loc8_ = Math.abs(_loc7_) * 1.4 * TunableParameters.BLOOM_SCALE / 100;
            _loc9_ = 50 * (fakeFlowerIndex + 100) % (main.width - 100);
            _loc10_ = (main.height - 100) * Math.random() + 100;
            _loc10_ = Math.max(50,Math.min(main.height - 150,_loc10_));
            _loc9_ = Math.max(50,Math.min(main.width - 50,_loc9_));
            _loc8_ = Math.max(170,Math.min(320,_loc8_));
            drawFlower(_loc9_,_loc10_,_loc8_);
            lastBreak = flowerIndex;
            prevY = _loc10_;
         }
         else if(flowerIndex - lastBreak > 9)
         {
            _loc9_ = 50 * (fakeFlowerIndex + 100) % (main.width - 100);
            _loc9_ = Math.max(100,Math.min(main.width - 100,_loc9_));
            _loc5_ = value(samplesBuffer,flowerIndex);
            _loc3_ = runningAverage(samplesBuffer,flowerIndex,7);
            _loc7_ = value(samplesBuffer,flowerIndex - 2) - 2 * value(samplesBuffer,flowerIndex - 1) + value(samplesBuffer,flowerIndex);
            _loc8_ = Math.max(150,Math.min(320,400 * Math.abs(_loc5_ / _loc3_)));
            _loc10_ = (main.height - 100) * Math.random() + 100;
            drawFlower(_loc9_,_loc10_,_loc8_);
            lastBreak = flowerIndex;
         }
         if(samplesBuffer.length > 0 && flowerIndex < samplesBuffer.length)
         {
            flowerIndex++;
         }
         else
         {
            _loc9_ = 50 * (fakeFlowerIndex + 100) % (main.width - 100);
            _loc8_ = Math.max(100,300 * Math.random());
            if(Math.random() < 0.15)
            {
               drawFlower(_loc9_,prevY + (Math.random() - 0.5) * 300,_loc8_);
            }
         }
         fakeFlowerIndex++;
      }
      
      public function getColorV(param1:uint) : Number
      {
         var _loc2_:uint = param1;
         var _loc3_:* = _loc2_ >> 16 & 255;
         var _loc4_:* = _loc2_ >> 8 & 255;
         var _loc5_:* = _loc2_ & 255;
         return RGBtoV(_loc3_ / 255,_loc4_ / 255,_loc5_ / 255);
      }
      
      public function drawRandomFlowers() : void
      {
      }
      
      [Bindable(event="propertyChange")]
      public function get center() : Label
      {
         return this._1364013995center;
      }
      
      public function runningAverage(param1:ArrayCollection, param2:int, param3:int) : Number
      {
         var _loc4_:Number = 0;
         var _loc5_:int = param2 - param3;
         while(_loc5_ <= param2)
         {
            _loc4_ = _loc4_ + value(param1,_loc5_);
            _loc5_++;
         }
         return _loc4_ / (param3 + 1);
      }
      
      [Bindable(event="propertyChange")]
      public function get imgCls() : Class
      {
         return this._1185106329imgCls;
      }
      
      public function safeRemove(param1:UIComponent) : void
      {
         var flower:UIComponent = param1;
         try
         {
            mainDisplay.removeChild(flower);
            return;
         }
         catch(err:Error)
         {
            return;
         }
      }
      
      public function value(param1:ArrayCollection, param2:int) : Number
      {
         var _loc3_:int = param2 % param1.length;
         if(_loc3_ < 0)
         {
            _loc3_ = _loc3_ + param1.length;
         }
         if(param1.length == 0)
         {
            return 0;
         }
         return Number(param1.getItemAt(_loc3_));
      }
      
      mx_internal function _Mori_StylesInit() : void
      {
         var _loc1_:CSSStyleDeclaration = null;
         var _loc2_:Array = null;
         if(mx_internal::_Mori_StylesInit_done)
         {
            return;
         }
         mx_internal::_Mori_StylesInit_done = true;
         StyleManager.mx_internal::initProtoChainRoots();
      }
      
      public function readPartialPacket() : void
      {
         readSingleByte = true;
         readFromStart = true;
         try
         {
            socket.readUTFBytes(bytesToIgnore);
         }
         catch(err:Error)
         {
         }
         readFromStream(whatsLeft);
      }
      
      public function set loading(param1:Label) : void
      {
         var _loc2_:Object = this._336650556loading;
         if(_loc2_ !== param1)
         {
            this._336650556loading = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"loading",_loc2_,param1));
         }
      }
      
      public function set main(param1:Canvas) : void
      {
         var _loc2_:Object = this._3343801main;
         if(_loc2_ !== param1)
         {
            this._3343801main = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"main",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var target:Mori = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(_documentDescriptor_);
         var bindings:Array = _Mori_bindingsSetup();
         var watchers:Array = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_MoriWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },bindings,watchers);
         var i:uint = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         super.initialize();
      }
      
      public function onSocketSecurityError(param1:SecurityErrorEvent) : void
      {
         errors = true;
         Alert.show("security error");
      }
      
      public function ___Mori_LinkButton1_click(param1:MouseEvent) : void
      {
         Alert.show("Work in Progress:\n-------------------------------------------------------\nBloom: A Tribute to Kenneth Noland\nKen Goldberg, Sanjay Krishnan,\nFernanda Viagas, Martin Wattenberg\nIn this internet-based earthwork, minute movements of the Hayward Fault in California are detected by a seismograph, transmitted continuously via the Internet, and processed to generate an evolving field of circular blooms. The size and position of each bloom is based on real-time changes in the Earth\'s motion, measured as a vertical velocity continuously updated from the seismometer.  The horizontal position of blooms is based on time, their vertical position is based on magnitude of the second derivative (rate of change), and their size is based on the relative size of the extremum.  Large movements create large blooms; small jitters create tiny buds. All colors come from photographs of flowers found on Flickr. Special thanks to the UC Berkeley Seismology Department for the live data feed from the Hayward Fault seismometer station and to David Nachum, Vijay Vasudevan, Woj Matusek for work on earlier versions.");
      }
      
      [Bindable(event="propertyChange")]
      public function get paletteImage() : Image
      {
         return this._289929120paletteImage;
      }
      
      public function set paletteImage(param1:Image) : void
      {
         var _loc2_:Object = this._289929120paletteImage;
         if(_loc2_ !== param1)
         {
            this._289929120paletteImage = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"paletteImage",_loc2_,param1));
         }
      }
      
      public function set center(param1:Label) : void
      {
         var _loc2_:Object = this._1364013995center;
         if(_loc2_ !== param1)
         {
            this._1364013995center = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"center",_loc2_,param1));
         }
      }
      
      public function preparePalette() : void
      {
         imageWidth = paletteImage.contentWidth;
         imageHeight = paletteImage.contentHeight;
         imageData = new BitmapData(imageWidth,imageHeight);
         imageData.draw(paletteImage.content);
      }
      
      public function readPacketFromStart() : void
      {
         var c:String = null;
         var channel:String = null;
         firstSampleReceived = true;
         readSingleByte = true;
         try
         {
            c = String.fromCharCode(socket.readByte());
            while(c != "\n")
            {
               c = String.fromCharCode(socket.readByte());
            }
            channel = socket.readUTFBytes(4).substring(0,3);
            BHZ = channel == "BHZ";
            packetSize = socket.readUnsignedShort();
            socket.readUTFBytes(7);
            readFromStream(packetSize);
            return;
         }
         catch(e:EOFError)
         {
            return;
         }
      }
      
      public function getColor(param1:Number, param2:Number) : int
      {
         var _loc3_:int = param1 * imageWidth;
         var _loc4_:int = param2 * imageHeight;
         return imageData.getPixel(_loc3_,_loc4_);
      }
      
      public function onIOError(param1:Event) : void
      {
         loadDataFromFile();
      }
      
      public function ___Mori_LinkButton2_click(param1:MouseEvent) : void
      {
         openControlPanel();
      }
      
      [Bindable(event="propertyChange")]
      public function get mainDisplay() : UIComponent
      {
         return this._786725065mainDisplay;
      }
      
      public function drawFlower(param1:Number, param2:Number, param3:Number) : void
      {
         var _loc6_:Number = NaN;
         var _loc10_:int = 0;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:int = 0;
         if(old_color_map != TunableParameters.COLOR_MAP)
         {
            preparePalette();
            old_color_map = TunableParameters.COLOR_MAP;
         }
         thinStripe = 8;
         regularStripe = 15;
         var _loc4_:int = 15;
         var _loc5_:UIComponent = new UIComponent();
         var _loc7_:Array = new Array();
         var _loc8_:Number = Math.random();
         var _loc9_:Number = Math.random();
         _loc10_ = 0;
         while(_loc10_ < _loc4_)
         {
            _loc15_ = Math.max(Math.min(_loc8_ + (Math.random() / 3 - 0.165),0.99),0.05);
            _loc16_ = Math.max(Math.min(_loc9_ + (Math.random() / 3 - 0.165),0.99),0.05);
            _loc17_ = getColor(_loc15_,_loc16_);
            _loc7_.push(bucket({
               "color":_loc17_,
               "hue":getColorH(_loc17_),
               "bright":getColorV(_loc17_)
            }));
            _loc8_ = _loc15_;
            _loc9_ = _loc16_;
            _loc10_++;
         }
         _loc7_.sortOn(["hue","bright"],Array.NUMERIC);
         _loc10_ = 0;
         while(_loc10_ < _loc4_)
         {
            _loc6_ = param3 - int(_loc10_ > 0) * thinStripe - int(_loc10_ > 1) * (_loc10_ - 1) * regularStripe;
            if(_loc6_ < thinStripe)
            {
               break;
            }
            _loc5_.graphics.beginFill(_loc7_.pop()["color"]);
            _loc5_.graphics.drawCircle(param1 + main.x,param2 + main.y,_loc6_);
            _loc5_.graphics.endFill();
            _loc10_++;
         }
         _loc5_.cacheAsBitmap = true;
         var _loc11_:Zoom = new Zoom(_loc5_);
         _loc11_.duration = 200 + param3 * 6.5;
         _loc11_.originX = param1;
         _loc11_.originY = param2;
         _loc11_.zoomHeightFrom = 0.1;
         _loc11_.zoomHeightTo = 1;
         _loc11_.zoomWidthFrom = 0.1;
         _loc11_.zoomWidthTo = 1;
         _loc11_.play();
         var _loc12_:Blur = new Blur(_loc5_);
         _loc12_.blurXFrom = 0;
         _loc12_.blurYFrom = 0;
         _loc12_.blurXTo = 15;
         _loc12_.blurYTo = 15;
         _loc12_.duration = 8000;
         setTimeout(_loc12_.play,_loc11_.duration);
         var _loc13_:Fade = new Fade(_loc5_);
         _loc13_.duration = _loc11_.duration;
         _loc13_.alphaFrom = 0;
         _loc13_.alphaTo = 1;
         _loc13_.play();
         var _loc14_:Fade = new Fade(_loc5_);
         _loc14_.duration = 20000;
         _loc14_.alphaFrom = 1;
         _loc14_.alphaTo = 0;
         _loc14_.easingFunction = Cubic.easeOut;
         setTimeout(_loc14_.play,_loc11_.duration);
         if(mainDisplay.numChildren >= maxNumFlowers)
         {
            mainDisplay.removeChildAt(0);
         }
         mainDisplay.addChild(_loc5_);
         setTimeout(safeRemove,_loc11_.duration + _loc14_.duration,_loc5_);
      }
      
      [Bindable(event="propertyChange")]
      public function get main() : Canvas
      {
         return this._3343801main;
      }
      
      public function minmax(param1:ArrayCollection, param2:int) : Array
      {
         var _loc3_:Number = Math.abs(value(param1,param2) - runningAverage(samplesBuffer,flowerIndex,20));
         var _loc4_:Number = Math.abs(value(param1,param2 - 1) - runningAverage(samplesBuffer,flowerIndex - 1,20));
         var _loc5_:Number = Math.abs(value(param1,param2 + 1) - runningAverage(samplesBuffer,flowerIndex + 1,20));
         var _loc6_:Number = value(param1,param2) - runningAverage(samplesBuffer,flowerIndex,20);
         var _loc7_:Number = value(param1,param2 - 1) - runningAverage(samplesBuffer,flowerIndex - 1,20);
         var _loc8_:Number = value(param1,param2 + 1) - runningAverage(samplesBuffer,flowerIndex + 1,20);
         var _loc9_:Number = value(param1,param2 - 2) - runningAverage(samplesBuffer,flowerIndex - 2,20);
         var _loc10_:Number = value(param1,param2 + 2) - runningAverage(samplesBuffer,flowerIndex + 2,20);
         if(_loc3_ >= _loc4_ && _loc3_ >= _loc5_)
         {
            return new Array(_loc6_,0.25 * (_loc6_ - _loc9_) + 0.25 * (_loc6_ - _loc7_) + 0.25 * (_loc6_ - _loc6_) + 0.25 * (_loc6_ - _loc10_),_loc6_,_loc7_,_loc8_);
         }
         return new Array(0,0.5 * (_loc3_ - _loc4_) + 0.5 * (_loc3_ - _loc5_),_loc3_,_loc4_,_loc5_);
      }
      
      public function set imgCls(param1:Class) : void
      {
         var _loc2_:Object = this._1185106329imgCls;
         if(_loc2_ !== param1)
         {
            this._1185106329imgCls = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"imgCls",_loc2_,param1));
         }
      }
      
      public function set mainDisplay(param1:UIComponent) : void
      {
         var _loc2_:Object = this._786725065mainDisplay;
         if(_loc2_ !== param1)
         {
            this._786725065mainDisplay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mainDisplay",_loc2_,param1));
         }
      }
      
      public function bucket(param1:Object) : Object
      {
         return param1;
      }
      
      public function onSocketClose(param1:Event) : void
      {
         errors = true;
         trace(connectionLostMessage);
      }
      
      private function _Mori_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return imgCls;
         },function(param1:Object):void
         {
            paletteImage.source = param1;
         },"paletteImage.source");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return this.width / 2 - 50;
         },function(param1:Number):void
         {
            loading.x = param1;
         },"loading.x");
         result[1] = binding;
         binding = new Binding(this,function():Number
         {
            return this.height / 2 - 50;
         },function(param1:Number):void
         {
            loading.y = param1;
         },"loading.y");
         result[2] = binding;
         return result;
      }
      
      public function readFirstByte() : void
      {
         readSingleByte = false;
         readFromStart = true;
         if(socket.readByte() != 20)
         {
            if(firstSampleReceived)
            {
               trace(connectionClosedMessage);
            }
            else
            {
               trace(allChannelsBusyMessage);
            }
            errors = true;
         }
      }
      
      public function onSocketData(param1:ProgressEvent) : void
      {
         firstSampleReceived = true;
         if(readFromStart)
         {
            if(readSingleByte)
            {
               readFirstByte();
            }
            else
            {
               readPacketFromStart();
            }
         }
         else
         {
            readPartialPacket();
         }
      }
   }
}
