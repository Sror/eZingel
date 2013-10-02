//
//  AppDelegate.h
//  eZignal
//
//  Created by MacMini on 5/15/13.
//  Copyright (c) 2013 MacMini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetLanguage.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SetLanguage *sl;
@property (nonatomic,strong) UINavigationController *nav;

@property (nonatomic) int currentBack;
@property (nonatomic) int tabIndex;
@property (nonatomic) int fileType;

@property (nonatomic) int currentTab;

@end
