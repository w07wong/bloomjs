package
{
   import flash.events.Event;
   import mx.containers.HBox;
   import mx.containers.TitleWindow;
   import mx.containers.VBox;
   import mx.controls.Label;
   import mx.controls.VSlider;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.CloseEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.SliderEvent;
   import mx.managers.PopUpManager;
   
   public class ControlPanel extends TitleWindow
   {
       
      
      private var _109250890scale:VSlider;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function ControlPanel()
      {
         _documentDescriptor_ = new UIComponentDescriptor({
            "type":TitleWindow,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":HBox,
                  "propertiesFactory":function():Object
                  {
                     return {"childDescriptors":[new UIComponentDescriptor({
                        "type":VBox,
                        "propertiesFactory":function():Object
                        {
                           return {"childDescriptors":[new UIComponentDescriptor({
                              "type":Label,
                              "propertiesFactory":function():Object
                              {
                                 return {"text":"Change Palette"};
                              }
                           }),new UIComponentDescriptor({
                              "type":VSlider,
                              "id":"scale",
                              "events":{"change":"__scale_change"},
                              "stylesFactory":function():void
                              {
                                 this.dataTipPrecision = 0;
                              },
                              "propertiesFactory":function():Object
                              {
                                 return {
                                    "tickInterval":10,
                                    "minimum":0,
                                    "value":100,
                                    "maximum":300,
                                    "labels":["0x","3x"],
                                    "snapInterval":1,
                                    "liveDragging":false
                                 };
                              }
                           })]};
                        }
                     })]};
                  }
               })]};
            }
         });
         super();
         mx_internal::_document = this;
         this.title = "Controls";
         this.showCloseButton = true;
         this.addEventListener("close",___ControlPanel_TitleWindow1_close);
      }
      
      public function __scale_change(param1:SliderEvent) : void
      {
         sliderEvent(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get scale() : VSlider
      {
         return this._109250890scale;
      }
      
      override public function initialize() : void
      {
         mx_internal::setDocumentDescriptor(_documentDescriptor_);
         super.initialize();
      }
      
      public function closeLogin() : void
      {
         PopUpManager.removePopUp(this);
      }
      
      public function set scale(param1:VSlider) : void
      {
         var _loc2_:Object = this._109250890scale;
         if(_loc2_ !== param1)
         {
            this._109250890scale = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"scale",_loc2_,param1));
         }
      }
      
      public function sliderEvent(param1:SliderEvent) : void
      {
         TunableParameters.BLOOM_SCALE = scale.value;
         dispatchEvent(new Event(Event.CHANGE));
      }
      
      public function ___ControlPanel_TitleWindow1_close(param1:CloseEvent) : void
      {
         closeLogin();
      }
   }
}
