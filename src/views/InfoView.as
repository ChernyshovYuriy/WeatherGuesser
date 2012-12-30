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
	import flash.display.Bitmap;
	
	import qnx.fuse.ui.actionbar.ActionPlacement;
	import qnx.fuse.ui.core.Action;
	import qnx.fuse.ui.core.ActionBase;
	import qnx.fuse.ui.core.Container;
	import qnx.fuse.ui.core.SizeOptions;
	import qnx.fuse.ui.display.Image;
	import qnx.fuse.ui.layouts.Align;
	import qnx.fuse.ui.layouts.gridLayout.GridData;
	import qnx.fuse.ui.layouts.gridLayout.GridLayout;
	import qnx.fuse.ui.navigation.Page;
	import qnx.fuse.ui.text.Label;
	import qnx.fuse.ui.text.TextFormat;

	/**
	 * @author juliandolce
	 */
	public class InfoView extends Page
	{
		private var moreAction:Action;
		
		public function InfoView()
		{
			super();
		}

		override protected function init():void
		{
			super.init();
			
			
			moreAction = new Action( "More Info", new Assets.ICON_CONTINENTS() );
			moreAction.actionBarPlacement = ActionPlacement.ON_BAR;
			
			actions = new Vector.<Action>();
			actions.push( moreAction );
		}
		
		
		override protected function onAdded():void
		{
			super.onAdded();

			var container:Container = new Container();
			var layout:GridLayout = new GridLayout();
			layout.numColumns = 1;
			layout.paddingLeft = 50;
			layout.paddingRight = 50;
			layout.paddingTop = 50;
			layout.paddingBottom = 30;
			container.layout = layout;
			
			var bg:Bitmap = new Assets.INFO_BG();
			container.background = bg;
			
			var sun:Image = new Image();
			sun.setImage( new Assets.INFO_SUN() );
			sun.fixedAspectRatio = true;
			var sunData:GridData = new GridData();
			sunData.setOptions( SizeOptions.NONE );
			sunData.hAlign = Align.END;
			sunData.marginBottom = 30;
			sun.layoutData = sunData;
			
			
			container.addChild( sun );
			
			var label:Label = new Label();
			label.maxLines = 0;
			label.text = "Welcome to the weather guesser. This little app will predict (guess) the weather, not only today or tomorrow, but for the whole year. Sounds too good to be true? Go ahead and try it.";
			
			var format:TextFormat = label.format;
			format.size = 54;
			format.color = 0xFAFAFA;
			format.italic = true;
			format.font = "Slate Pro Light";
			
			label.format = format;
			
			
			var labelData:GridData = new GridData();
			labelData.setOptions( SizeOptions.RESIZE_BOTH );
			//labelData.marginBottom = 30;
			label.layoutData = labelData;
			
			container.addChild( label );
			
			
			var cloud:Image = new Image();
			cloud.fixedAspectRatio = true;
			cloud.setImage( new Assets.INFO_CLOUD() );
			
			
			var cloudData:GridData = new GridData();
			cloudData.setOptions( SizeOptions.NONE );
			cloudData.hAlign = Align.BEGIN;
			cloudData.vAlign = Align.BEGIN;
			cloudData.marginBottom = 70;
			cloud.layoutData = cloudData;
			
			container.addChild( cloud );
		
			var footer:Label = new Label();
			footer.text = "BlackBerry 10 AIR sample app 2012";
			
			var footerData:GridData = new GridData();
			footerData.hAlign = Align.END;
			footerData.setOptions(SizeOptions.GROW_HORIZONTAL);
			footer.layoutData = footerData;
			
			format = footer.format;
			format.size = 30;
			format.color = 0xFAFAFA;
			format.font = "Slate Pro Light";
			
			footer.format = format;
			
			
			container.addChild( footer );
			
			
			content = container;
		}

		override public function onActionSelected( action:ActionBase ):void
		{
			if( action == moreAction )
			{
				var morePage:MoreInfo = new MoreInfo();
				pushPage( morePage );
			}
			else
			{
				super.onActionSelected(action);
			}
		}

	}
}
