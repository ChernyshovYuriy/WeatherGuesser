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
	import qnx.fuse.ui.core.SizeOptions;
	import qnx.fuse.ui.events.ListEvent;
	import qnx.fuse.ui.layouts.Align;
	import qnx.fuse.ui.layouts.gridLayout.GridData;
	import qnx.fuse.ui.listClasses.List;
	import qnx.ui.data.DataProvider;

	/**
	 * @author juliandolce
	 */
	public class BrowseView extends TitlePage {
		
		private var list:List;
		
		public function BrowseView() {
			super();
		}
		
		override protected function init():void
		{
			super.init();
		}
		
		
		override protected function onAdded():void
		{
			super.onAdded();
			var dp:DataProvider = new DataProvider();
			dp.addItem( {label:"Africa"} );
			dp.addItem( {label:"Antarctica"} );
			dp.addItem( {label:"Asia"} );
			dp.addItem( {label:"Atlantis"} );
			dp.addItem( {label:"Australia"} );
			dp.addItem( {label:"Europe"} );
			dp.addItem( {label:"North America"} );
			dp.addItem( {label:"South America"} );
			
			list = new List();
			list.dataProvider = dp;
			list.addEventListener( ListEvent.ITEM_CLICKED, listClicked );
			
			var listData:GridData = new GridData();
			listData.hAlign = Align.FILL;
			listData.setOptions( SizeOptions.RESIZE_BOTH );
			
			list.layoutData = listData;
			
			content.addChild( list );
			
			title = "Continents";
		}
		

		private function listClicked( event:ListEvent ):void
		{
			var continent:String = event.data.label;
			var pane:CitiesView = new CitiesView();
			pane.title = continent;
			pushPage( pane );
		}
	}
}
