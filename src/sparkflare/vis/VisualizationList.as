package sparkflare.vis
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.controls.DataGrid;
	import mx.core.ILayoutElement;
	import mx.core.IVisualElement;
	import mx.events.CollectionEvent;
	import mx.events.FlexEvent;
	
	import org.juicekit.animate.TransitionEvent;
	import org.juicekit.animate.Transitioner;
	import org.juicekit.animate.Tween;
	import org.juicekit.util.FPSLabel;
	
	import spark.components.DataGroup;
	import spark.components.List;
	import spark.layouts.BasicLayout;
	import spark.layouts.supportClasses.LayoutBase;
	
	import sparkflare.mappers.MapperBase;
	import sparkflare.mappers.MapperChain;
	
	[DefaultProperty("mappers")] 
	
	/**
	 * A Visualization is an extension of a DataGroup with
	 * explicit rules that define how the item renderers are displayed
	 */
	public class VisualizationList extends List
	{
		
		private var _mappers:MapperChain;
		private var _selectedMappers:MapperChain;
		
		public var transitioner:Transitioner = new Transitioner(transitionPeriod);
		
		private var _transitionPeriod:Number = 1.5;
		
		public function get transitionPeriod():Number
		{
			return _transitionPeriod;
		}
		
		public function set transitionPeriod(value:Number):void
		{
			transitioner.duration = value;
			_transitionPeriod = value;
		}
		
		public function get mappers():MapperChain
		{
			return _mappers;
		}
		
		public function set mappers(value:MapperChain):void
		{
			value.owner = this;
			if (_mappers) {
				_mappers.addEventListener(CollectionEvent.COLLECTION_CHANGE, dataUpdated);
			} 
			_mappers = value;
			_mappers.addEventListener(CollectionEvent.COLLECTION_CHANGE, dataUpdated);
		}

		public function get selectedMappers():MapperChain
		{
			return _selectedMappers;
		}
		
		public function set selectedMappers(value:MapperChain):void
		{
			value.owner = this;
			if (_selectedMappers) {
				_selectedMappers.addEventListener(CollectionEvent.COLLECTION_CHANGE, dataUpdated);
			} 
			_selectedMappers = value;
			_selectedMappers.addEventListener(CollectionEvent.COLLECTION_CHANGE, dataUpdated);
		}
		
		override protected function commitProperties():void {
			super.commitProperties();
			
			// Run the operator list			
			var elements:ArrayCollection = new ArrayCollection();
			var selectedElements:ArrayCollection = new ArrayCollection();
			var element:CensusItemRenderer;
			
			// Gather the elements that will be updated
			const dg:DataGroup = this.dataGroup;
			var count:int = dg.numElements;
			trace('ran commit props on', count, 'elements');
			
			for (var i:int = 0; i < count; i++)
			{
				// get the current element, we're going to work with the
				// ILayoutElement interface				
				element = dg.getElementAt(i) as CensusItemRenderer;
				if (element && element.includeInLayout) 
					elements.addItem(element);
				if (element && element.selected)
					selectedElements.addItem(element);				
			}
			
			transitioner.stop();
			transitioner.reset();
			if (mappers) mappers.operate(elements, transitioner)
			if (selectedMappers) selectedMappers.operate(selectedElements, transitioner);
			transitioner.play();
		}
		
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
		}
		
		protected function dataUpdated(e:Event=null):void {
			invalidateProperties();
		}
		
		override public function set dataProvider(value:IList):void {
			if (dataProvider)
				dataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE, dataUpdated);
			super.dataProvider = value;
			dataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE, dataUpdated);
		}
		
		public function VisualizationList()
		{
			this.addEventListener(FlexEvent.CREATION_COMPLETE, dataUpdated);
//			this.useVirtualLayout = false; 			
//			this.layout = new BasicLayout();
		}
	}
}