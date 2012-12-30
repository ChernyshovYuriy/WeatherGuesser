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
	import qnx.fuse.ui.layouts.Align;
	import qnx.fuse.ui.core.SizeOptions;
	import qnx.fuse.ui.buttons.SegmentedControl;
	import qnx.fuse.ui.core.Container;
	import qnx.fuse.ui.layouts.gridLayout.GridData;
	import qnx.fuse.ui.layouts.gridLayout.GridLayout;
	import qnx.fuse.ui.navigation.Page;
	import qnx.fuse.ui.text.Label;
	import qnx.fuse.ui.text.TextFormat;
	import qnx.ui.data.DataProvider;

	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;

	/**
	 * @author juliandolce
	 */
	public class MaxMinView extends Page
	{
		private var __filter:SegmentedControl;
		private var __temperatures:Vector.<Label>;
		private var __cities:Vector.<Label>;
		private var __xml:XML = <root>
    <max>
        <item name="Kinshasa" 			temp="40" />    
        <item name="Tiujana" 			temp="35" />
        <item name="Lagos" 				temp="32" />
        <item name="Tokyo" 				temp="30" />
        <item name="Sydney" 			temp="28" />
    </max>
    <min>
        <item name="McMurdo Station" 	temp="-33" />
        <item name="Copenhagen" 		temp="-22" />
        <item name="Moscow" 			temp="-15" />
        <item name="Tokyo" 				temp="-14" />    
        <item name="Toronto" 			temp="-11" />
    </min>
</root>;

		public function MaxMinView()
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
			var container:Container = new Container();
			var s:Sprite = new Sprite();
			var g:Graphics = s.graphics;
			g.beginFill( 0xf8f8f8 );
			g.drawRect( 0, 0, 10, 10 );
			g.endFill();

			container.background = s;

			var layout:GridLayout = new GridLayout();
			layout.numColumns = 2;
			layout.spacing = 50;
			container.layout = layout;

			__filter = new SegmentedControl();
			__filter.dataProvider = new DataProvider( [ { label:"Max" }, { label:"Min" } ] );
			__filter.addEventListener( Event.CHANGE, filterChanged );
			__filter.selectedIndex = 0;

			var filterData:GridData = new GridData();
			filterData.hSpan = 2;
			filterData.marginTop = 50;
			filterData.marginLeft = 50;
			filterData.marginRight = 50;
			filterData.setOptions( SizeOptions.RESIZE_HORIZONTAL );
			filterData.hAlign = Align.BEGIN;
			filterData.vAlign = Align.BEGIN;
			__filter.layoutData = filterData;

			container.addChild( __filter );

			var num:int = 5;

			__temperatures = new Vector.<Label>( num, true );
			__cities = new Vector.<Label>( num, true );
			
			var tempData:GridData = new GridData();
			tempData.marginLeft = 50;
			
			var cityData:GridData = new GridData();
			cityData.marginRight = 50;

			for ( var i:int = 0; i < num; i++ )
			{
				
				var temp:Label = new Label();
				var tempFormat:TextFormat = new TextFormat;
				tempFormat.size = 59;
				tempFormat.font = "Slate Pro Light";
				temp.format = tempFormat;
				temp.layoutData = tempData;
				
				container.addChild( temp );
				__temperatures[ i ] = temp;

				var city:Label = new Label();
				var format:TextFormat = new TextFormat;
				format.size = 59;
				city.format = format;
				city.layoutData = cityData;
				container.addChild( city );
				__cities[ i ] = city;
			}
			setData( false );

			content = container;
		}

		private function setData( min:Boolean ):void
		{
			var list:XMLList;
			var color:uint;
			if ( min )
			{
				color = 0x006dba;
				list = __xml.max.item;
			}
			else
			{
				color = 0xd8225E;
				list = __xml.min.item;
			}
			for ( var i:int = 0; i < list.length(); i++ )
			{
				var node:XML = list[ i ];
				__temperatures[ i ].text = node.@temp.toString() + "\u00B0";
				__cities[ i ].text = node.@name.toString();

				var format:TextFormat = __temperatures[ i ].format;
				format.color = color;
				__temperatures[ i ].format = format;
			}
		}

		private function filterChanged( event:Event ):void
		{
			setData( __filter.selectedIndex == 1 );
		}
	}
}
