//
//  DbAccessor.m
//  Decory
//
//  Created by Wagih Hassan on 4/8/13.
//  Copyright (c) 2013 Freelancer. All rights reserved.
//

#import "DbAccessor.h"
#import "pdfModel.h"
#import "favModel.h"
@implementation DbAccessor

sqlite3* ezingleDatabase;

-(void)initializeDatabase
{
    NSString *path = [self createEditableDatabase];
    if (sqlite3_open([path UTF8String],  & ezingleDatabase) == SQLITE_OK)
    {
    }
    else
        sqlite3_close(ezingleDatabase);
}

- (NSString*) createEditableDatabase
{
    // Check to see if editable database already exists
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *writableDB = [documentsDir
                            stringByAppendingPathComponent:@"ezingle.db"];
    success = [fileManager fileExistsAtPath:writableDB];
    if (success)
        return writableDB;
    
    // The editable database does not exist
    // Copy the default DB to the application Documents directory.
    NSString *defaultPath = [[[NSBundle mainBundle] resourcePath]
                             stringByAppendingPathComponent:@"ezingle.db"];
    success = [fileManager copyItemAtPath:defaultPath
                                   toPath:writableDB error: & error];
    if (!success)
    {
        NSAssert1(0, @"Failed to create writable database file:’%@’.",
                  [error localizedDescription]);
        return writableDB;
    }
    else
    {
        return writableDB;
    }
}

-(BOOL) savePdf :(NSString *)pdfPath
{
    NSString *path = [self createEditableDatabase];
    if (!(sqlite3_open([path UTF8String],  & ezingleDatabase) == SQLITE_OK))
    {
        sqlite3_close(ezingleDatabase);
        return false;
    }
 
    sqlite3_stmt *statement;
    NSString *command = [NSString stringWithFormat:@"INSERT INTO pdfTable (pdfPath) VALUES('%@');",pdfPath];
    
    int sqlResult = sqlite3_prepare_v2(ezingleDatabase, [command UTF8String], -1,  & statement, 0);
    
    if ( sqlResult == SQLITE_OK )
    {
        NSLog(@"ekwkekekek");
        if(sqlite3_step(statement) != SQLITE_DONE ) {
            NSLog( @"Error: %s", sqlite3_errmsg(ezingleDatabase) );
        } else {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_finalize(statement);
        return TRUE;
    }
    else
    {
        return FALSE;
    }

}
- (NSMutableArray *) getPdfs
{
    NSString *path = [self createEditableDatabase];
    if (sqlite3_open([path UTF8String],  & ezingleDatabase) != SQLITE_OK)
    {
        sqlite3_close(ezingleDatabase);
        return false;
    }
    
    sqlite3_stmt *statement;
    NSString *command            = [NSString stringWithFormat:@"SELECT * FROM pdfTable"];
    int sqlResult                = sqlite3_prepare_v2(ezingleDatabase, [command UTF8String], -1,  & statement, 0);
    NSMutableArray *pdfList = [[NSMutableArray alloc] init] ;
    
    if ( sqlResult == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            pdfModel *am =[[pdfModel alloc]init];
            
            int r_id       = sqlite3_column_int(statement, 0);
            am.rId         = r_id;
            
            char *pdfPath = (char *)sqlite3_column_text(statement,1);
            am.pdfPath    = [NSString stringWithUTF8String:pdfPath];
            
                       
            [pdfList addObject:am];
        }
        sqlite3_finalize(statement);
    }
    else
    {
        return FALSE;
    }
    return pdfList;
}

-(BOOL) deletePdf:(NSString *)pdfPath
{
    NSString *path = [self createEditableDatabase];
    if (sqlite3_open([path UTF8String],  & ezingleDatabase) != SQLITE_OK)
    {
        sqlite3_close(ezingleDatabase);
        return false;
    }
    sqlite3_stmt *statement;
    NSString *command = [NSString stringWithFormat:@"DELETE FROM PdfTable WHERE pdfPath='%@'",pdfPath];
    int sqlResult = sqlite3_prepare_v2(ezingleDatabase, [command UTF8String], -1,  & statement, NULL);
    if ( sqlResult == SQLITE_OK) {
        sqlite3_step(statement);
        sqlite3_finalize(statement);
        return TRUE;
    }
    else
    {
        return FALSE;
    }

}

-(BOOL) deleteFav:(NSString *)pdfPath
{
    NSString *path = [self createEditableDatabase];
    if (sqlite3_open([path UTF8String],  & ezingleDatabase) != SQLITE_OK)
    {
        sqlite3_close(ezingleDatabase);
        return false;
    }
    sqlite3_stmt *statement;
    NSString *command = [NSString stringWithFormat:@"DELETE FROM favTable WHERE pdfPath='%@'",pdfPath];
    int sqlResult = sqlite3_prepare_v2(ezingleDatabase, [command UTF8String], -1,  & statement, NULL);
    if ( sqlResult == SQLITE_OK) {
        sqlite3_step(statement);
        sqlite3_finalize(statement);
        return TRUE;
    }
    else
    {
        return FALSE;
    }
    
}

-(BOOL) addToFav:(NSString *)pdfPath
{
    NSString *path = [self createEditableDatabase];
    if (!(sqlite3_open([path UTF8String],  & ezingleDatabase) == SQLITE_OK))
    {
        sqlite3_close(ezingleDatabase);
        return false;
    }
    
    sqlite3_stmt *statement;
    NSString *command = [NSString stringWithFormat:@"INSERT INTO favTable (pdfPath) VALUES('%@');",pdfPath];
    
    int sqlResult = sqlite3_prepare_v2(ezingleDatabase, [command UTF8String], -1,  & statement, 0);
    
    if ( sqlResult == SQLITE_OK )
    {
        if(sqlite3_step(statement) != SQLITE_DONE ) {
            NSLog( @"Error: %s", sqlite3_errmsg(ezingleDatabase) );
        } else {
            sqlite3_step(statement);
            sqlite3_finalize(statement);
        }
        sqlite3_finalize(statement);
        return TRUE;
    }
    else
    {
        return FALSE;
    }
}
- (NSMutableArray *) getFav
{
    NSString *path = [self createEditableDatabase];
    if (sqlite3_open([path UTF8String],  & ezingleDatabase) != SQLITE_OK)
    {
        sqlite3_close(ezingleDatabase);
        return false;
    }
    
    sqlite3_stmt *statement;
    NSString *command            = [NSString stringWithFormat:@"SELECT * FROM favTable"];
    int sqlResult                = sqlite3_prepare_v2(ezingleDatabase, [command UTF8String], -1,  & statement, 0);
    NSMutableArray *pdfList = [[NSMutableArray alloc] init] ;
    
    if ( sqlResult == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW)
        {
            favModel *am =[[favModel alloc]init];
            
            int r_id       = sqlite3_column_int(statement, 0);
            am.rId         = r_id;
            
            char *pdfPath = (char *)sqlite3_column_text(statement,1);
            am.pdfPath    = [NSString stringWithUTF8String:pdfPath];
            
            
            [pdfList addObject:am];
        }
        sqlite3_finalize(statement);
    }
    else
    {
        return FALSE;
    }
    return pdfList;
}



@end
