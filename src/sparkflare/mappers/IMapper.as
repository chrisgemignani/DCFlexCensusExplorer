
package sparkflare.mappers
{
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.core.IMXMLObject;
	
	import org.juicekit.animate.Transitioner;
	
	import sparkflare.vis.VisualizationDataGroup;
	
	/**
	 * Interface for operators that perform processing tasks on the elements
	 * in a VisualizationDataGroup. These tasks include layout, and color, shape, and
	 * size encoding. Custom operators can be defined by implementing this
	 * interface. 
	 * 
	 * <p>This design is heavily influenced by Flare.</p>
	 */
	public interface IMapper extends IMXMLObject
	{		
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
				
	} // end of interface IOperator
}