package sparkflare.distortions
{
    import mx.collections.ArrayCollection;
    import mx.collections.IList;
    import mx.collections.ListCollectionView;
    import mx.core.IMXMLObject;
    
    import org.juicekit.animate.Transitioner;
    
    import sparkflare.vis.VisualizationDataGroup;

    public class Distortion implements IMapper
    {
        public function Distortion()
        {
        }
        
        
            function get name():String;
            function set name(s:String):void;
            
            /** Indicates if the operator is enabled or disabled. */
            function get enabled():Boolean;
            
            function set enabled(b:Boolean):void;
            
            /**
             * Sets parameter values for this operator.
             * @params an object containing parameter names and values.
             */
            function set parameters(params:Object):void;
            
            /**
             * Performs an operation over the contents of a DataGroup.
             * @param t a Transitioner instance for collecting value updates.
             */
            function operate(items:ArrayCollection, t:Transitioner = null):void;
            
    }
}