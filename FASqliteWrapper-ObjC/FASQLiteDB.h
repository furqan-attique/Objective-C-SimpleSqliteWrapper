//
//  FASQLiteDB.h
//  FASqliteWrapper-ObjC
//
//  Created by Furqan  (furqan_isl@hotmail.com)
//  Copyright (c) 2014 InnovativeApps. All rights reserved.
//

//SQLiteWrapper
//Singleton Class for Sqlite Database Management
///////////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface FASQLiteDB : NSObject
{
    sqlite3 *sqliteDatabase;
}

@property(nonatomic,strong) NSString *dbpath;

+ (instancetype)sharedInstance;

-(void)setupDatabaseWithDBFile:(NSString *)sqliteDatabaseFileName;
-(BOOL)executeQuery:(NSString *)query;
-(NSArray *)executeSelectQuery:(NSString *)query;



//closing database
-(void)closeDatabase;


@end
