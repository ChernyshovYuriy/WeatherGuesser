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
package views
{
	import model.Weather;
	
	import qnx.fuse.ui.core.SizeOptions;
	import qnx.fuse.ui.layouts.Align;
	import qnx.fuse.ui.layouts.gridLayout.GridData;
	import qnx.fuse.ui.listClasses.SectionList;
	import qnx.fuse.ui.progress.ActivityIndicator;
	
	import ui.listClasses.WeatherCellRenderer;

	/**
	 * @author juliandolce
	 */
	public class HomeView extends TitlePage
	{
		protected var list:SectionList;
		private var __showing:Boolean;
		private var __activityIndicator:ActivityIndicator;

		override public function set title( value:String ):void
		{
			super.title = value;
			if ( list != null && __showing )
			{
				list.dataProvider = Weather.getWeather( value );
			}
		}

		public function HomeView()
		{
			super();
		}

		override protected function init():void
		{
			super.init();
		}

		override protected function onAdded():void
		{
			super.onAdded();
			list = new SectionList();
			list.rowHeight = 201;
			list.cellRenderer = WeatherCellRenderer;
			var listData:GridData = new GridData();
			listData.hAlign = Align.FILL;
			listData.setOptions( SizeOptions.RESIZE_BOTH );

			list.layoutData = listData;

			content.addChild( list );

			__activityIndicator = new ActivityIndicator();
			__activityIndicator.animate( true );

			if ( title != null && __showing )
			{
				list.dataProvider = Weather.getWeather( title );
			}
			else
			{
				addChild( __activityIndicator );
			}
		}

		override protected function onTransitionInComplete():void
		{
			super.onTransitionInComplete();
			__showing = true;
			__activityIndicator.animate( false );

			if ( title != null )
			{
				list.dataProvider = Weather.getWeather( title );
			}

			if ( contains( __activityIndicator ) )
			{
				removeChild( __activityIndicator );
			}
		}

		override protected function onTransitionOutComplete():void
		{
			super.onTransitionOutComplete();
			__showing = false;
		}

		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );

			if ( __activityIndicator )
			{
				var aix:Number = Math.round( ( unscaledWidth - __activityIndicator.width ) / 2 );
				var aiy:Number = 0;

				if ( content )
				{
					aiy = Math.round( ( content.height - __activityIndicator.height ) / 2 ) + content.y;
				}

				__activityIndicator.x = aix;
				__activityIndicator.y = aiy;
			}
		}
	}
}
