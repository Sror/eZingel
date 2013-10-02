//
//  Dashboard.h
//  eZignal
//
//  Created by Mona Qora on 5/16/13.
//  Copyright (c) 2013 MacMini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface Dashboard : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate,MFMailComposeViewControllerDelegate>
{
    BOOL menuFlag, buttFlag;
}

@property (weak, nonatomic) IBOutlet UIView *mainView;

@property (weak, nonatomic) IBOutlet UIScrollView *menu;
@property (weak, nonatomic) IBOutlet UIScrollView *headerScroll;

@property (weak, nonatomic) IBOutlet UIButton *menuBtnOut;

@property (weak, nonatomic) IBOutlet UILabel *library;
@property (weak, nonatomic) IBOutlet UILabel *browse;
@property (weak, nonatomic) IBOutlet UILabel *wishlist;
@property (weak, nonatomic) IBOutlet UILabel *logout;
@property (weak, nonatomic) IBOutlet UILabel *contactUs;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollInsideMenu;

- (IBAction)goLibrary:(id)sender;
- (IBAction)goBrowse:(id)sender;
- (IBAction)goWishList:(id)sender;
- (IBAction)logout:(id)sender;
- (IBAction)menuBtn:(id)sender;
- (IBAction)contactUs:(id)sender;
@end
