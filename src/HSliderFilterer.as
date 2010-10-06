package
{
    import flare.vis.data.Data;
    import flare.vis.operator.Operator;
    
    import flash.events.Event;
    
    import mx.collections.ArrayCollection;
    import mx.controls.Alert;
    import mx.controls.ComboBase;
    import mx.events.CollectionEvent;
    
    import org.juicekit.interfaces.IEvaluable;
    import org.juicekit.query.Comparison;
    import org.juicekit.query.Expression;
    import org.juicekit.query.methods.*;
    
    import skins.ColorCustomHSliderSkin;
    
    import spark.components.CheckBox;
    import spark.components.ComboBox;
    import spark.components.HGroup;
    import spark.components.HSlider;
    import spark.components.Label;
    
    /**
     * A slider that allows a user to select
     * a target element of a class and a 
     * expression.
     */
    [Bindable]
    public class HSliderFilterer extends HGroup
    {
        
        //------------------------
        // properties
        //------------------------
        
        /** Storage for raw data used to build the filter */
        private var _dataProvider:ArrayCollection;        
        /** One of categorical|continuous */
        private var _dataType:String = 'categorical';
        private var _property:String;
        /** Unique values if categorical */
        private var _values:Array = [];
        
        public var slider:HSlider = new HSlider();
        public var titleLabel:Label = new Label();
        public var enableCb:CheckBox = new CheckBox();
        public var operatorCmb:ComboBox = new ComboBox();
        
        
        /**
         * Calculate range for filters on changes to dataProvider
         */
        public function set dataProvider(v:ArrayCollection):void
        {
            if (_dataProvider) _dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, calculateFilters);            
            _dataProvider = v;
            _dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, calculateFilters);                   
        }
        
        public function get dataProvider():ArrayCollection 
        {
            return _dataProvider;
        }
        
        
        /**
        * The data property to use.
        */
        public function set property(v:String):void 
        {
            _property = v;
            titleLabel.text = v;
        }
        
        public function get property():String
        {
            return _property;
        }
        
        

        /**
        * Handle slider differently for continous and categorical.
        */
        public function set dataType(v:String):void 
        {
            _dataType = v;
            if (v == 'categorical') {
                operatorCmb.dataProvider = new ArrayCollection([
                    {label: 'is', expression: eq},
                    {label: 'is not', expression: neq}
                ]);
                
            } else {
                operatorCmb.dataProvider = new ArrayCollection([
                    {label: '<=', expression: lte},
                    {label: '>=', expression: gte},
                    {label: '=', expression: eq}
                ]);
                
            }
        }
        
        public function get dataType():String 
        {
            return _dataType;
        }

        
        //-------------------------
        // methods
        //-------------------------
        
        /**
         * Formatter for data tip on slider.
         */
        public function formatDataTip(value:Number):String 
        {
            var s:String;
            if (dataType == 'categorical') {
                // Look up the value from _values
                s = _values[int(value)][property].toString();
            } else {
                s = value.toString(); 
            }
            return s;
        }
        
        /**
        * Calculate unique filter items and
        * parameterize the slider.
        */
        private function calculateFilters(e:Event=null):void {
            if (dataType == 'categorical') {
                _values = select(property).groupby(property).eval(dataProvider.source);
                slider.minimum = 0;
                slider.maximum = _values.length - 1;
                slider.stepSize = 1;
            } else {
                var range:Object = select({minVal: min(property), maxVal:max(property)}).eval(dataProvider.source);
                slider.minimum = range[0].minVal;
                slider.maximum = range[0].maxVal;
                slider.stepSize = 1;
            }
            dispatchEvent(new Event('change'));
        }
        
        
        /**
        * A Query compatible where clause
        */
        [Bindable(name='change')] 
        public function get whereClause():IEvaluable
        {
            if (slider.enabled && dataProvider && dataProvider.length > 0 && property) {
                var comp:Function = operatorCmb.selectedItem.expression;
                if (dataType == 'categorical') {
                    var literal:Object = _values[int(slider.value)][property];
                    return comp(property, _(literal));
                } else {
                    return comp(property, _(slider.value));
                }
            } else {
                // Always true
                return eq(_(1),_(1));
            }
        }
        
        /**
         * Constructor
         * 
         * Layout and set up visual properties
         */
        public function HSliderFilterer()
        {
            dataType = 'continuous';
            verticalAlign  = 'middle';               
            
            titleLabel.setStyle('fontWeight', 'normal');
            titleLabel.setStyle('fontSize', 18);
            addElement(titleLabel);
            
            operatorCmb.width = 58;
            operatorCmb.selectedIndex = 0;
            addElement(operatorCmb);
            
            slider.setStyle('chromeColor', 0x6699ff);
            addElement(slider);
            
            enableCb.selected = true;
            addElement(enableCb);
            
            
            enableCb.addEventListener(Event.CHANGE, function(e:Event):void {
                slider.enabled = enableCb.selected;
                operatorCmb.enabled = enableCb.selected;
                alpha = enableCb.selected ? 1.0 : 0.5;
                titleLabel.setStyle('color', enableCb.selected ? 0x333333: 0xaaaaaa);
                dispatchEvent(new Event('change'));
            });
            operatorCmb.addEventListener(Event.CHANGE, function(e:Event):void {
                dispatchEvent(new Event('change'));
            });
            slider.addEventListener(Event.CHANGE, function(e:Event):void {
                dispatchEvent(new Event('change'));
            });
            slider.setStyle('liveDragging', false);
            slider.dataTipFormatFunction = formatDataTip;
            slider.setStyle('skinClass', skins.ColorCustomHSliderSkin);
        }
    }
    
    
}