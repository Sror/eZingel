//
//  WishList.h
//  eZingel
//
//  Created by MacMini on 5/20/13.
//  Copyright (c) 2013 MacMini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "favModel.h"
#import "DbAccessor.h"
#import "ReaderViewController.h"
#import "PSCStoreManager.h"
#import "PSCFileHelper.h"
#import "PSCGridViewController.h"
#import "PSCGoToPageButtonItem.h"
#import "PSCKioskPDFViewController.h"
#import "PSCImageGridViewCell.h"
#import "PSCMagazine.h"
#import "PSCMagazineFolder.h"
#import "PSCKioskPDFViewController.h"
#import "PSCSettingsController.h"
#import "PSCShadowView.h"
#import "SDURLCache.h"
@interface WishList : UIViewController<UIWebViewDelegate,ReaderViewControllerDelegate,PSCStoreManagerDelegate>
{
    BOOL chngeFlag;
    int language,booksCount,reminder, downCount, lastOffset;
    DbAccessor *db;
    UIActivityIndicatorView * indicator;
    NSMutableArray *pdfList;
}
@property (weak, nonatomic) IBOutlet UILabel *wishlistLblHeader;

@property (weak, nonatomic) IBOutlet UIScrollView *tableLibScroll;
@property (weak, nonatomic) IBOutlet UIScrollView *woodLibScroll;

@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

- (IBAction)changeBtn:(id)sender;
- (IBAction)editBtn:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *favScroll;
- (IBAction)edit:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *done;
- (IBAction)done:(id)sender;
@end
