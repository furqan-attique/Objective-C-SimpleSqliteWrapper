//
//  FASQLiteDB.m
//  FASqliteWrapper-ObjC
//
//  Created by Furqan  (furqan_isl@hotmail.com)
//  Copyright (c) 2014 InnovativeApps. All rights reserved.
//

#import "FASQLiteDB.h"

//Singleton Class

@interface FASQLiteDB()

@property BOOL isdbConnected;

@end


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
        _isdbConnected = YES;
    }
    else
    {
        NSLog(@"[SQLITE] Error to open database connection : %s",sqlite3_errmsg(sqliteDatabase));
        sqlite3_close(sqliteDatabase);
    }
}


//Execute Query : INSERT , UPDATE , DELETE
-(BOOL)executeQuery:(NSString *)query
{
    if (self.isdbConnected == YES)
    {
        sqlite3_stmt *statement = NULL;
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
        
        
        sqlite3_finalize(statement);
    }
    
    return NO;
}



//Execute Query : SELECT  - return array of records (column:value as NSDictionary)
-(NSArray *)executeSelectQuery:(NSString *)query
{
    if (self.isdbConnected == YES) //Check if database is connected
    {
        sqlite3_stmt *statement = NULL;
        const char *sql = [query UTF8String];
        if (sqlite3_prepare_v2(sqliteDatabase, sql, -1, &statement, NULL) == SQLITE_OK)
        {
            
            NSMutableArray *columnNames = [[NSMutableArray alloc] init];
            NSMutableArray *columnTypes = [[NSMutableArray alloc] init];
            
            BOOL requireFetchColumnInfo = YES;
            int columnCount = 0;
            
            NSMutableArray *records = [[NSMutableArray alloc] init];
            
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                if (requireFetchColumnInfo)
                {
                    columnCount = sqlite3_column_count(statement);
                    
                    for (int index = 0; index < columnCount; index++)
                    {
                        NSString *columnName = [NSString stringWithUTF8String: sqlite3_column_name(statement, index)];
                        [columnNames addObject: columnName];
                            [columnTypes addObject: [NSNumber numberWithInt: [self columnTypeAtIndex: index inStatement: statement]]];
                    }
                    
                    
                    requireFetchColumnInfo = NO;
                }
                
                NSMutableDictionary *record = [[NSMutableDictionary alloc]init];
                for (int index = 0; index < columnCount; index++)
                {
                    id value = [self columnValueAtIndex: index withColumnType: [[columnTypes objectAtIndex: index] intValue] inStatement: statement];
                    if (value != nil)
                    {
                        [record setValue: value forKey: [columnNames objectAtIndex: index]];
                    }
                }
                
                [records addObject: record];
            }

            return records;
            
        }
        else
        {
            NSLog(@"[SQLITE] Error when preparing query: %s", sqlite3_errmsg(sqliteDatabase));
            sqlite3_finalize(statement);

        }
        
    }
    
    return nil;
}





- (int)columnTypeAtIndex: (int)column inStatement: (sqlite3_stmt *)statement {
	// Declared data types - http://www.sqlite.org/datatype3.html 
	const NSSet *blobTypes = [NSSet setWithObjects: @"BINARY", @"BLOB", @"VARBINARY", nil];
	const NSSet *charTypes = [NSSet setWithObjects: @"CHAR", @"CHARACTER", @"CLOB", @"NATIONAL VARYING CHARACTER", @"NATIVE CHARACTER", @"NCHAR", @"NVARCHAR", @"TEXT", @"VARCHAR", @"VARIANT", @"VARYING CHARACTER", nil];
	const NSSet *dateTypes = [NSSet setWithObjects: @"DATE", @"DATETIME", @"TIME", @"TIMESTAMP", nil];
	const NSSet *intTypes  = [NSSet setWithObjects: @"BIGINT", @"BIT", @"BOOL", @"BOOLEAN", @"INT", @"INT2", @"INT8", @"INTEGER", @"MEDIUMINT", @"SMALLINT", @"TINYINT", nil];
	const NSSet *nullTypes = [NSSet setWithObjects: @"NULL", nil];
	const NSSet *realTypes = [NSSet setWithObjects: @"DECIMAL", @"DOUBLE", @"DOUBLE PRECISION", @"FLOAT", @"NUMERIC", @"REAL", nil];
	// Determine data type of the column - http://www.sqlite.org/c3ref/c_blob.html
	const char *columnType = (const char *)sqlite3_column_decltype(statement, column);
	if (columnType != NULL) {
		NSString *dataType = [[NSString stringWithUTF8String: columnType] uppercaseString];
		NSRange end = [dataType rangeOfString: @"("];
		if (end.location != NSNotFound) {
			dataType = [dataType substringWithRange: NSMakeRange(0, end.location)];
		}
		if ([dataType hasPrefix: @"UNSIGNED"]) {
			dataType = [dataType substringWithRange: NSMakeRange(0, 8)];
		}
		dataType = [dataType stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
		if ([intTypes containsObject: dataType]) {
			return SQLITE_INTEGER;
		}
		if ([realTypes containsObject: dataType]) {
			return SQLITE_FLOAT;
		}
		if ([charTypes containsObject: dataType]) {
			return SQLITE_TEXT;
		}
		if ([blobTypes containsObject: dataType]) {
			return SQLITE_BLOB;
		}
		if ([nullTypes containsObject: dataType]) {
			return SQLITE_NULL;
		}
		if ([dateTypes containsObject: dataType]) {
			return SQLITE_TEXT;
		}
		return SQLITE_TEXT;
	}
	return sqlite3_column_type(statement, column);
}

- (id)columnValueAtIndex: (int)column withColumnType: (int)columnType inStatement: (sqlite3_stmt *)statement {
	if (columnType == SQLITE_INTEGER) {
		return [NSNumber numberWithInt: sqlite3_column_int(statement, column)];
	}
	if (columnType == SQLITE_FLOAT) {
		return [[NSDecimalNumber alloc] initWithDouble: sqlite3_column_double(statement, column)];
	}
	if (columnType == SQLITE_TEXT) {
		const char *text = (const char *)sqlite3_column_text(statement, column);
		if (text != NULL) {
			return [NSString stringWithUTF8String: text];
		}
	}
	if (columnType == SQLITE_BLOB) {
		return [NSData dataWithBytes: sqlite3_column_blob(statement, column) length: sqlite3_column_bytes(statement, column)];
	}
	if (columnType == SQLITE_TEXT) {
		const char *text = (const char *)sqlite3_column_text(statement, column);
		if (text != NULL) {
			NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
			[formatter setDateFormat: @"yyyy-MM-dd HH:mm:ss"];
			NSDate *date = [formatter dateFromString: [NSString stringWithUTF8String: text]];
			return date;
		}
	}
	return [NSNull null];
}






//Closing Database Connection
///////////////////////////////////////////////////////////////////
-(void)closeDatabase
{
	@synchronized(self) {
		if (_isdbConnected) {
			if (sqlite3_close(sqliteDatabase) != SQLITE_OK) {
				@throw [NSException exceptionWithName: @"SQLiteException" reason: [NSString stringWithFormat: @"Failed to close database connection. '%S'", (const unichar *)sqlite3_errmsg16(sqliteDatabase)] userInfo: nil];
			}
			_isdbConnected = NO;
		}
	}
}












/*
 //Execute Query : SELECT  - return array of records (columns as array)
 -(NSArray *)executeSelectQuery:(NSString *)query
 {
 
 sqlite3_stmt *statement = NULL;
 const char *sql = [query UTF8String];
 if (sqlite3_prepare_v2(sqliteDatabase, sql, -1, &statement, NULL) == SQLITE_OK)
 {
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
 else
 {
 NSLog(@"[SQLITE] Error when preparing query: %s", sqlite3_errmsg(sqliteDatabase));
 }
 
 return nil;
 }

 */







@end
