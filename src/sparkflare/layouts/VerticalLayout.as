package sparkflare.layouts
{
    import mx.collections.ArrayCollection;
    import mx.collections.ListCollectionView;
    
    import org.juicekit.animate.Transitioner;
    import org.juicekit.util.Property;
    import org.juicekit.util.Sort;
    
    import sparkflare.mappers.IMapper;
    import sparkflare.mappers.MapperBase;
    
    /**
     * Layouts are IMappers that affect multiple properties at once, typically
     * x, y, height, and width. HorizontalStripeLayout lays items out in vertical
     * stripes.
     */
    [Bindable]
    public class VerticalLayout extends MapperBase
    {
        
        public var sizeField:String;
        
        
        /** @inheritDoc */
        override public function operate(items:ArrayCollection, t:Transitioner = null):void
        {
            var row:Object;
            var _t:Transitioner;
            var v:Number;
            
            if (enabled) 
            {
                _t = (t != null ? t : Transitioner.DEFAULT);
                var sizeProp:Property = Property.$(sizeField);
                
                if (items) 
                {
                    var y:Number = 0;
                    for each (row in items) 
                    {
                        _t.setValue(row, 'y', y);
                        _t.setValue(row, 'x', 0);
                        y += 10;
                    }
                }
                
                _t = null;
            }
        }
        
        
        /**
         * Constructor
         */
        public function VerticalLayout()
        {
        }
        
        
    }
}