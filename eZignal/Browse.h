//
//  Browse.h
//  eZignal
//
//  Created by MacMini on 5/19/13.
//  Copyright (c) 2013 MacMini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DbAccessor.h"
@interface Browse : UIViewController<UIWebViewDelegate>
{
    NSString *destination;
    UIAlertView *progressAlert;
    DbAccessor *db;
}
@property (weak, nonatomic) IBOutlet UILabel *browseLblHeader;

@property (retain, nonatomic) IBOutlet UIWebView *storeWebView;
@end
