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
package model
{
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.SharedObject;
	import flash.utils.getTimer;
	
	import events.WeatherEvent;
	
	import qnx.ui.data.SectionDataProvider;

	/**
	 * @author juliandolce
	 */
	public class Weather
	{
		
		private static var so:SharedObject = SharedObject.getLocal("weatherguesser");
		private static var dispatcher:EventDispatcher = new EventDispatcher();
		
		public static function getWeather( city:String ):SectionDataProvider
		{
			var dp:SectionDataProvider = new SectionDataProvider();

			var file:File = File.applicationDirectory.resolvePath("assets/json/" + city + ".json");
			if ( file.exists )
			{
				var stream:FileStream = new FileStream();
				stream.open( file, FileMode.READ );

				var starttime:int = getTimer();

				var content:String = stream.readUTFBytes( stream.bytesAvailable );
				// trace( "read content", getTimer() - starttime );

				// starttime = getTimer();

				var data:Array = JSON.parse( content ) as Array;

				// trace( "parse content", getTimer() - starttime );

				var today:Date = new Date();
				var jan1:Date = new Date( today.fullYear, 0, 1 );

				var daynum:int = Math.ceil( (today.getTime() - jan1.getTime()) / 86400000 );

				if ( isLeapYear( today.fullYear ) && today.getMonth() > 1 )
				{
					daynum -= 1;
				}
				var i:int;
				var dateSplit:Array;
				var date:Date;
				//starttime = getTimer();
				var length:int = data.length;
				var add:Boolean;
				for (i = daynum; i < length; i++) {
					dateSplit = data[i].date.split(" ");
					date = new Date(today.getFullYear(), dateSplit[1] - 1, dateSplit[2]);
					add = false;
					if (date.getMonth() < today.getMonth()) {
						continue;
					}
					if (date.getMonth() == today.getMonth()) {
						if (date.getDate() >= today.getDate()) {
							add = true;
						}
					}
					if (date.getMonth() > today.getMonth()) {
						add = true;
					}
					if (add) {
						dp.addItem( { label:date.toDateString() } );
						dp.addChildToIndex( data[ i ], dp.length - 1 );
					}
				}
				//trace("Weather parsing time", getTimer() - starttime + " ms");
			}
			return dp;
		}
		
		static public function setHomeCity( name:String ):void
		{
			if( Weather.getHomeCity() != name )
			{
				so.data.homeCity = name;
				so.flush();
				dispatcher.dispatchEvent( new WeatherEvent( WeatherEvent.HOME_CHANGE ) );
			}
		}
		
		static public function getHomeCity():String
		{
			
			var city:String = "London";
			if( so.data != null && so.data.homeCity != null )
			{
				city = so.data.homeCity;
			}
			
			return( city );
		}
		
		static public function addEventListener( type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false ):void
		{
			dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference );
		}
		
		static public function removeEventListener( type:String, listener:Function, useCapture:Boolean = false ):void
		{
			dispatcher.removeEventListener(type, listener, useCapture );
		}

		private static function isLeapYear( yr:int ):Boolean
		{
			return (yr % 400 == 0) || ((yr % 4 == 0) && (yr % 100 != 0));
		}
	}
}
