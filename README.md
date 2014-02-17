Objective-C-SimpleSqliteWrapper
===============================

An Objective-C wrapper for sqlite3 database for iOS

Simple Sqlite3 database wrapper class to execute queries using Objective-C methods.
More changes and updates will be added later.

Must add the SQLite3 Library to the project "libsqlite3.0.dylib" ->Link Binary With Libraries

Just #import "FASQLiteDB.h"

    FASQLiteDB *fasqlitedb = [FASQLiteDB sharedInstance];
    //Sqlite Database File name without extension Including in Application Bundle
    [fasqlitedb setupDatabaseWithDBFile:@"mydb"]; 

    //Execute Query : INSERT , UPDATE , DELETE
    BOOL isSuccessful = [fasqlitedb executeQuery:querystring];
    
    //Execute Query : SELECT  - return array of records (column:value as NSDictionary)
    NSArray *records = [fasqlitedb executeSelectQuery:@"SELECT * FROM mytable"];
    
    //Closing Databse Connection
    [fasqlitedb closeDatabase];


Please use this and inform about further changes so it can be made more and more better.
Sample Xcode5 project is attached.


Developed by :

Mobile Application Developers

M.furqan  (furqan_isl@hotmail.com)
Attique  (attiqueullah_2@hotmail.com)
