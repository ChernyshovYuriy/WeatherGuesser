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
package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	import events.WeatherEvent;
	
	import model.Weather;
	
	import qnx.fuse.ui.navigation.NavigationPane;
	import qnx.fuse.ui.navigation.Tab;
	import qnx.fuse.ui.navigation.TabbedPane;
	import qnx.fuse.ui.theme.ThemeGlobals;
	
	import views.BrowseView;
	import views.FavoritesView;
	import views.HomeView;
	import views.InfoView;
	import views.MaxMinView;

	[SWF(backgroundColor="#f8f8f8", frameRate="60")]
	public class WeatherGuesser extends Sprite
	{
		[Embed(source="assets/styles/styles.css", mimeType="application/octet-stream")]
		private var STYLES:Class;
		private var tabbedPane:TabbedPane;
		private var tabOverFlow:Sprite;

		public function WeatherGuesser()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.addEventListener( Event.RESIZE, stageResize );

			//setting mouseChildren=false and opaqueBackground globally helps scrolling performance
			ThemeGlobals.injectCSS( "CellRenderer{ mouseChildren:false; opaqueBackground:#FAFAFA;}" );
			ThemeGlobals.injectCSS( (new STYLES() as ByteArray).toString() );

			tabOverFlow = new Sprite();
			addChild( tabOverFlow );

			tabbedPane = new TabbedPane();
			tabbedPane.tabOverflowParent = tabOverFlow;

			var tabs:Vector.<Tab> = new Vector.<Tab>();

			var weather:HomeView = new HomeView();
			weather.title = Weather.getHomeCity();

			Weather.addEventListener( WeatherEvent.HOME_CHANGE, onHomeCityChanged );

			var homeTab:Tab = new Tab( "Home", new Assets.ICON_HOME() );
			homeTab.content = weather;

			tabs.push( homeTab );

			var browse:NavigationPane = new NavigationPane();
			browse.push( new BrowseView() );

			var browseTab:Tab = new Tab( "Browse", new Assets.ICON_BROWSE() );
			browseTab.content = browse;

			var fav:NavigationPane = new NavigationPane();
			fav.push( new FavoritesView() );

			var favTab:Tab = new Tab( "Favorites", new Assets.ICON_FAVORITE() );
			favTab.content = fav;

			tabs.push( browseTab );
			tabs.push( favTab );
			tabs.push( createTab( "Max/Min", null, MaxMinView ) );

			var info:NavigationPane = new NavigationPane();
			info.push( new InfoView() );

			var infoTab:Tab = new Tab( "Info", new Assets.ICON_INFO() );
			infoTab.content = info;

			tabs.push( infoTab );

			tabbedPane.tabs = tabs;
			tabbedPane.activeTab = tabs[ 0 ];

			addChild( tabbedPane );
		}

		private function onHomeCityChanged( event:WeatherEvent ):void
		{
			var homeTab:Tab = tabbedPane.tabs[ 0 ];
			var view:HomeView = homeTab.content as HomeView;
			view.title = Weather.getHomeCity();
		}

		private function createTab( label:String, icon:Object, content:Class ):Tab
		{
			var tab:Tab = new Tab( label, icon );
			tab.content = new content();
			return( tab );
		}

		private function stageResize( event:Event ):void
		{
			tabbedPane.width = stage.stageWidth;
			tabbedPane.height = stage.stageHeight;
		}
	}
}
