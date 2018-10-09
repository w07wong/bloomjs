package
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class TunableParameters implements IEventDispatcher
   {
      
      private static var _staticBindingEventDispatcher:EventDispatcher = new EventDispatcher();
      
      private static var _473839168COLOR_MAP:String = "http://memento.ieor.berkeley.edu/blooms/palettes/palette4.jpg";
      
      public static var BLOOM_SCALE:Number = 100;
       
      
      private var _bindingEventDispatcher:EventDispatcher;
      
      public function TunableParameters()
      {
         _bindingEventDispatcher = new EventDispatcher(IEventDispatcher(this));
         super();
      }
      
      [Bindable(event="propertyChange")]
      public static function get COLOR_MAP() : String
      {
         return TunableParameters._473839168COLOR_MAP;
      }
      
      public static function get staticEventDispatcher() : IEventDispatcher
      {
         return _staticBindingEventDispatcher;
      }
      
      public static function set COLOR_MAP(param1:String) : void
      {
         var _loc3_:IEventDispatcher = null;
         var _loc2_:Object = TunableParameters._473839168COLOR_MAP;
         if(_loc2_ !== param1)
         {
            TunableParameters._473839168COLOR_MAP = param1;
            _loc3_ = TunableParameters.staticEventDispatcher;
            if(_loc3_ != null)
            {
               _loc3_.dispatchEvent(PropertyChangeEvent.createUpdateEvent(TunableParameters,"COLOR_MAP",_loc2_,param1));
            }
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return _bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return _bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return _bindingEventDispatcher.willTrigger(param1);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         _bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         _bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
   }
}
