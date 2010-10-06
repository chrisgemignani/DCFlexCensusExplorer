
package sparkflare.mappers
{  
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.events.CollectionEvent;
	import mx.events.PropertyChangeEvent;
	import mx.events.PropertyChangeEventKind;
	
	import org.juicekit.animate.Transitioner;
	import org.juicekit.palette.IPalette;
	import org.juicekit.palette.Palette;
	import org.juicekit.palette.SizePalette;
	import org.juicekit.scale.LinearScale;
	import org.juicekit.scale.Scale;
	import org.juicekit.util.Filter;
	import org.juicekit.util.Property;
	
	/**
	 * Dispatched when the mapping has changed
	 *
	 * @eventType flash.events.Event
	 */
	[Event(name="updateMapper", type="flash.events.Event")]
	
	
	
	/**
	 * Base class for Operators that perform encoding of visual variables such
	 * as color, shape, and size. All Encoders share a similar structure:
	 * A source property (e.g., a data field) is mapped to a target property
	 * (e.g., a visual variable) using a <tt>ScaleBinding</tt> instance to map
	 * between values and a <tt>Palette</tt> instance to map scaled output
	 * into visual variables such as color, shape, and size.
	 */
	[Bindable]
	public class Mapper extends MapperBase
	{
		/** Boolean function indicating which items to process. */
		protected var _filter:Function;
		/** A transitioner for collecting value updates. */
		protected var _t:Transitioner;
		/** The source property name */
		protected var _source:String;
		protected var sourceProp:Property;
		/** The target property name. */
		protected var targetProp:Property;
		protected var _target:String;
		/** Storage for the palette */
		protected var _palette:IPalette;
		/** Storage for the scale */		
		protected var _scale:Scale;
		
		
		/** A scale binding to the source data. */
		public function get scale():Scale {
			return _scale;
		}
		
		public function set scale(s:Scale):void {
			if (s is Scale) {
				if (scale) _scale.removeEventListener(Scale.UPDATE_SCALE, updateMapper);
				_scale = s;
				_scale.addEventListener(Scale.UPDATE_SCALE, updateMapper);
				updateMapper();        
			}
		}
		
		/**
		 * Set the mapper's scale maximum value
		 */
		public function set sourceMax(v:Object):void {
			scale.max = v;
			updateMapper();
		}
		
		public function get sourceMax():Object {
			return scale.max;
		}
		
		/**
		 * Set the mapper's scale minimum value
		 */
		public function set sourceMin(v:Object):void {
			scale.min = v;
			updateMapper();
		}
		
		public function get sourceMin():Object {
			return scale.min;
		}
		

		/**
		 * Set the mapper's scale maximum value
		 */
		public function set targetMax(v:Object):void {
			palette['max'] = Number(v);
			updateMapper();
		}
		
		public function get targetMax():Object {
			return palette['max'];
		}
		
		/**
		 * Set the mapper's scale minimum value
		 */
		public function set targetMin(v:Object):void {
			palette['min'] = Number(v);
			updateMapper();
		}
		
		public function get targetMin():Object {
			return palette['min'];
		}
		
		
		/**
		 * Set the encoder's palette length
		 */
		public function set binCount(v:uint):void {
			(palette as SizePalette).length = v;
			updateMapper();
}
		
		public function get binCount():uint {
			return (palette as SizePalette).length;
		}
		
		
		
		
		/** Boolean function indicating which items to process. Only items
		 *  for which this function return true will be considered by the
		 *  labeler. If the function is null, all items will be considered.
		 *  @see flare.util.Filter */
		public function get filter():Function {
			return _filter;
		}
		
		public function set filter(f:*):void {
			_filter = Filter.$(f);
			updateMapper();
		}
		
		protected var _requiredState:String;
		public function set requiredState(state:String):void {
			_requiredState = state;
		}
		
		
		/** The source property. */
		public function get sourceField():String {
			return _source;
		}
		
		public function set sourceField(f:String):void {
			if (_source != f) {
				_source = f;
				sourceProp = new Property(f);
				updateMapper();
			}
		}
		
		/** The target property. */
		public function get targetField():String {
			return _target;
		}
		
		public function set targetField(f:String):void {
			if (_target != f) {
				_target = f;
				targetProp = new Property(f);
				updateMapper();
			}
		}

		
		/** The palette used to map scale values to visual values. */
		public function get palette():IPalette {
			return _palette;
		}
		
		public function set palette(p:*):void {
			_palette = p;			
		}
		
		
		/**
		 * Updates the encoder after a change to encoding parameters
		 */
		protected function updateMapper(e:Event=null):void
		{
			if (enabled) {
//				dispatchEvent(new PropertyChangeEvent(PropertyChangeEvent.PROPERTY_CHANGE,
//													  true, false, PropertyChangeEventKind.UPDATE, 'ignore', null, null, this));
			}
		}
		
		
		// --------------------------------------------------------------------
		
		/**
		 * Creates a new Mapper.
		 * @param source the source property
		 * @param target the target property
		 * @param filter a filter function controlling which items are encoded
		 */
		public function Mapper(source:String = null, target:String = null, filter:* = null)
		{
			_source = source;
			_target = target;
			this.filter = filter;			

			this.scale = new LinearScale();
			this.palette = new SizePalette();			
		}
		
				
		/** @inheritDoc */
		override public function operate(items:ArrayCollection, t:Transitioner = null):void
		{
			if (enabled) {
				_t = (t != null ? t : Transitioner.DEFAULT);
				var p:Property = Property.$(_source);
				
				var targetProp:Property = Property.$(_target);
				if (items) {
					items.disableAutoUpdate();
					for each (var row:Object in items) {
						if (row) { 
							var oldValue:Object = targetProp.getValue(row);
							var newValue:Object = encode(p.getValue(row));
							_t.setValue(row, _target, newValue);
							items.itemUpdated(row, _target, oldValue, newValue);
						}
					}
					items.enableAutoUpdate();
				}
				
				_t = null;
			}
		}
		
		
		/**
		 * Computes an encoding for the input value.
		 * 
		 * @param val a data value to encode
		 * @return the encoded visual value
		 */
		[Bindable(event="updateMapper")]
		public function encode(val:Object):*
		{
			return palette.getValue(scale.interpolate(val));
		}
		
	} // end of class Encoder
}