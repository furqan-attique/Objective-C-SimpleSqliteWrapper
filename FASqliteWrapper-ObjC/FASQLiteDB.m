//
//  FASQLiteDB.m
//  FASqliteWrapper-ObjC
//
//  Created by Furqan on 2/14/14.
//  Copyright (c) 2014 InnovativeApps. All rights reserved.
//

#import "FASQLiteDB.h"

//Singleton Class

@implementation FASQLiteDB


+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;
    
    dispatch_once(&once, ^
                  {
                      sharedInstance = [[self alloc]init];
                  });
    
    return sharedInstance;
}


-(void)copyDatabaseIfNeeded_writeable:(NSString *)sqliteDatabaseFileName

{
    @try
    {
        NSFileManager *fmgr=[NSFileManager defaultManager];
        NSError *error;
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
        NSString *path=[paths objectAtIndex:0];
        //self.dbpath=[path stringByAppendingPathComponent:@"mydb33.sqlite"];
        self.dbpath=[path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",sqliteDatabaseFileName]];

        if(![fmgr fileExistsAtPath:self.dbpath]){
            NSString *defaultDBPath=[[[NSBundle mainBundle]resourcePath]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.sqlite",sqliteDatabaseFileName]];
            if(![fmgr copyItemAtPath:defaultDBPath toPath:self.dbpath error:&error])
                NSLog(@"Failed to copy databasefile message :%@",[error localizedDescription]);
        }
        
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception: %@", exception);
    }
    
}


-(void)setupDatabaseWithDBFile:(NSString *)sqliteDatabaseFileName
{
    [self copyDatabaseIfNeeded_writeable:sqliteDatabaseFileName];
    
    if (sqlite3_open([self.dbpath UTF8String], &sqliteDatabase) == SQLITE_OK)
    {
        NSLog(@"[SQLITE] database opened successfully!");
    }
}


//Execute Query : INSERT , UPDATE , DELETE
-(BOOL)executeQuery:(NSString *)query
{
    sqlite3_stmt *statement;
    const char *sql = [query UTF8String];
    if (sqlite3_prepare_v2(sqliteDatabase, sql, -1, &statement, NULL) == SQLITE_OK)
    {
        //Execute query
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            NSLog(@"[SQLITE] query successful!");
            sqlite3_finalize(statement);
            return YES;
        }
        else
            NSLog(@"[SQLITE] Error when executing query : %s",sqlite3_errmsg(sqliteDatabase));

    }
    else
        NSLog(@"[SQLITE] Error when preparing query: %s", sqlite3_errmsg(sqliteDatabase));
    
    
    return NO;
}



//Execute Query : SELECT  - return array of records (columns as array)
-(NSArray *)executeSelectQuery:(NSString *)query
{

    sqlite3_stmt *statement = nil;
    const char *sql = [query UTF8String];
    if (sqlite3_prepare_v2(sqliteDatabase, sql, -1, &statement, NULL) != SQLITE_OK) {
        NSLog(@"[SQLITE] Error when preparing query!");
    } else {
        NSMutableArray *result = [NSMutableArray array];
        while (sqlite3_step(statement) == SQLITE_ROW) {
            NSMutableArray *row = [NSMutableArray array];
            for (int i=0; i<sqlite3_column_count(statement); i++) {
                int colType = sqlite3_column_type(statement, i);
                id value;
                if (colType == SQLITE_TEXT) {
                    const unsigned char *col = sqlite3_column_text(statement, i);
                    value = [NSString stringWithFormat:@"%s", col];
                } else if (colType == SQLITE_INTEGER) {
                    int col = sqlite3_column_int(statement, i);
                    value = [NSNumber numberWithInt:col];
                } else if (colType == SQLITE_FLOAT) {
                    double col = sqlite3_column_double(statement, i);
                    value = [NSNumber numberWithDouble:col];
                } else if (colType == SQLITE_NULL) {
                    value = [NSNull null];
                } else {
                    NSLog(@"[SQLITE] UNKNOWN DATATYPE");
                }
                
                [row addObject:value];
            }
            [result addObject:row];
        }
        return result;
    }
    return nil;
}





/*
 +(id)sharedDBManager
 {
 static FASQLiteDB *sharedInstance = nil;
 static dispatch_once_t predicate;
 dispatch_once(&predicate, ^{
 sharedInstance = [[self alloc] init];
 });
 return sharedInstance;
 
 
 
 }
 
 */




@end
