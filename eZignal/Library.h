//
//  Library.h
//  eZignal
//
//  Created by Mona Qora on 5/16/13.
//  Copyright (c) 2013 MacMini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReaderViewController.h"
#import "DbAccessor.h"
@interface Library : UIViewController <UIWebViewDelegate,ReaderViewControllerDelegate>
{
    BOOL chngeFlag;
    int language, downCount, lastOffset ,booksCount, reminder;
    UIActivityIndicatorView * indicator;
    NSArray *filePathPdf,*filePathWord;
    NSMutableArray *pdfList;
    DbAccessor *db;
}

@property (weak, nonatomic) IBOutlet UIScrollView *woodLibScroll;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;

@property (weak, nonatomic) IBOutlet UILabel *libraryLblHeader;
@property (strong, nonatomic) IBOutlet UIScrollView *shelfScrol;

- (IBAction)editBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *done;
- (IBAction)done:(id)sender;
@end
