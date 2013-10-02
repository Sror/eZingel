//
//  Login.h
//  eZignal
//
//  Created by MacMini on 5/15/13.
//  Copyright (c) 2013 MacMini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetLanguage.h"

@interface Login : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UITextField *passTxt;
@property (weak, nonatomic) IBOutlet UIScrollView *loginScroll;

- (IBAction)loginBtn:(id)sender;
@end
