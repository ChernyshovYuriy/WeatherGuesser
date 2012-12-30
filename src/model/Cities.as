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
	import flash.data.SQLConnection;
	import flash.data.SQLResult;
	import flash.data.SQLStatement;
	import flash.errors.SQLError;
	import flash.filesystem.File;
	
	import qnx.ui.data.SectionDataProvider;
	
	public class Cities
	{
	
		static public function getCities( continent:String ):SectionDataProvider
		{
			var sql:String = "select * from cities where continent='" + continent + "' ORDER BY name";
			var data:Array = getData( sql, City );

			return( groupData( data ) );
		}
		
		static private function groupData( data:Array ):SectionDataProvider
		{
			var dp:SectionDataProvider = new SectionDataProvider();
			var lastChar:String;
			
			for( var i:int = 0; i<data.length; i++ )
			{
				var firstChar:String = String( data[ i ].name ).charAt( 0 );
				if( firstChar != lastChar )
				{
					dp.addItem( {label:firstChar.toUpperCase() } );
					lastChar = firstChar;
				}
				
				dp.addChildToIndex(data[ i ], dp.length - 1 );
			}
			
			return( dp );
		}
		
		static public function getFavorites():SectionDataProvider
		{
			var sql:String = "select * from cities where favorite='" + 1 + "' ORDER BY name";
			var data:Array = getData( sql, City );

			return( groupData( data ) );
		}
		
		static public function saveFovorite( name:String, favorite:Boolean ):void
		{
			var sql:String = "UPDATE cities SET favorite=" + favorite + " WHERE name='" + name + "'";
			executeSql( sql );
		}
		
		static private function getSQLFile():File {
			var file:File = File.applicationStorageDirectory.resolvePath("assets/db/weatherguesser.db");
			if (!file.exists) {
				var packaged:File = File.applicationDirectory.resolvePath("assets/db/weatherguesser.db");
				if (packaged.exists) {
					packaged.copyTo( file );
				}
			}
			return file;
		}
		
		static private function executeSql( sql:String, itemClass:Class = null ):SQLStatement
		{
			var conn:SQLConnection = new SQLConnection();
			conn.open( getSQLFile() );
			
			var statement:SQLStatement = new SQLStatement();
			statement.sqlConnection = conn;
			
			statement.text = sql;
			if (itemClass != null) {
				statement.itemClass = itemClass;
			}
			try {
				statement.execute();
			} catch (error:SQLError) {
				trace("Cities - executeSql error " + error);
			}
			return statement ;
		}
		
		static public function getData(sql:String, itemClass:Class = null):Array {
			var statement:SQLStatement = executeSql( sql, itemClass );
			var result:SQLResult = statement.getResult();
			return result ? result.data : [];
		}
	}
}