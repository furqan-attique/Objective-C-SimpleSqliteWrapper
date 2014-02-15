Objective-C-SimpleSqliteWrapper
===============================

An Objective-C wrapper for sqlite database for iOS

Simple Sqlite3 database wrapper class to execute queries using Objective-C methods.
More changes and updates will be added later.

Just import   #import "FASQLiteDB.h"
    FASQLiteDB *fasqlitedb = [FASQLiteDB sharedInstance];
    [fasqlitedb setupDatabaseWithDBFile:@"mydb"]; //Sqlite Database File name without extension

    //Execute Query : INSERT , UPDATE , DELETE
    [fasqlitedb executeQuery:querystring];
    
    //Execute Query : SELECT  - return array of records (columns as array)
    NSArray *records = [fasqlitedb executeSelectQuery:@"SELECT * FROM mytable"];

Please use this and inform about further changes so it can be made more and more better.
Sample Xcode5 project is attached.


Developed by :
Mobile Application Developers

M.furqan  (furqan_isl@hotmail.com)
Attique  (attiqueullah_2@hotmail.com)
