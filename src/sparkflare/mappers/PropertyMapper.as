/*
* Copyright (c) 2007-2010 Regents of the University of California.
*   All rights reserved.
*
*   Redistribution and use in source and binary forms, with or without
*   modification, are permitted provided that the following conditions
*   are met:
*
*   1. Redistributions of source code must retain the above copyright
*   notice, this list of conditions and the following disclaimer.
*
*   2. Redistributions in binary form must reproduce the above copyright
*   notice, this list of conditions and the following disclaimer in the
*   documentation and/or other materials provided with the distribution.
*
*   3.  Neither the name of the University nor the names of its contributors
*   may be used to endorse or promote products derived from this software
*   without specific prior written permission.
*
*   THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
*   ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
*   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
*   ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
*   FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
*   DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
*   OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
*   HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
*   LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
*   OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
*   SUCH DAMAGE.
*/

package sparkflare.mappers
{  
	import mx.collections.ArrayCollection;
	import mx.utils.ObjectProxy;
	
	import org.juicekit.animate.Transitioner;
	import org.juicekit.util.Property;
	
	/**
	 * Applies the properties in <code>targetValues</code> to
	 * each mappable item.
	 */
	[Bindable]
	public class PropertyMapper extends Mapper
	{
		protected var _values:Object = {};
		
		/**
		 * Set exact values. 
		 */
		public function set targetValues(v:Object):void {
			_values = v;
		}
		
		public function get targetValues():Object {
			return _values;
		}
		
		
		/** @inheritDoc */
		override public function operate(items:ArrayCollection, t:Transitioner = null):void
		{
			if (enabled && targetValues) {
				_t = (t != null ? t : Transitioner.DEFAULT);
				for (var _target in targetValues) {
					var targetProp:Property = Property.$(_target);
					var newValue:Object = targetValues[_target];
					if (items) {
						for each (var row:Object in items) {
							if (filter == null || filter(row)) {
								var oldValue:Object = targetProp.getValue(row);
								_t.setValue(row, _target, newValue);
								items.itemUpdated(row, _target, oldValue, newValue); 
							}
						}
					}					
				}
				
				_t = null;
			}
		}
		
		
		
		
		
	} // end of class Encoder
}