/*
* Copyright (c) 2012 Research In Motion Limited.
*
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package ui.listClasses
{
	import flash.display.Bitmap;
	
	import qnx.fuse.ui.listClasses.CellRenderer;
	import qnx.fuse.ui.text.TextFormat;
	import qnx.fuse.ui.utils.DisplayObjectUtils;

	/**
	 * @author juliandolce
	 */
	public class WeatherCellRenderer extends CellRenderer
	{
		
		private var background:Bitmap;
		
		public function WeatherCellRenderer()
		{
		}
		
		
		override protected function init():void
		{
			super.init();
			paddingLeft = 77;
		}
		
		override public function set data( value:Object ):void
		{
			if( value != null )
			{
				value.label = value.tempaverage + "\u00B0";
			}
			super.data = value;
			
			if( background != null )
			{
				if( contains( background ) )
				{
					removeChild( background );
				}
			}
			
			if( value != null )
			{
				background = DisplayObjectUtils.getDisplayAsset( Assets[ "WEATHER" + value.icon ] ) as Bitmap; 
				addChildAt( background, 1 );
			}
			
		}

		override public function getTextFormatForState( state:String ):TextFormat
		{
			var format:TextFormat =  super.getTextFormatForState( state );
			format.color = 0xFAFAFA;
			format.size = 100;
			return( format );
		}

	}
}
