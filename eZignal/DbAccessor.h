//
//  DbAccessor.h
//  Decory
//
//  Created by Wagih Hassan on 4/8/13.
//  Copyright (c) 2013 Freelancer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>


@interface DbAccessor : NSObject
{
    NSString  *databasePath;
    sqlite3 *contactDB;
}
-(BOOL) savePdf :(NSString *)pdfPath;
- (NSMutableArray *) getPdfs;
-(BOOL) deletePdf:(NSString *)pdfPath;

-(BOOL) addToFav:(NSString *)pdfPath;
- (NSMutableArray *) getFav;
-(BOOL) deleteFav:(NSString *)pdfPath;
@end
