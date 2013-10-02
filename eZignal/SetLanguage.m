//
//  SetLanguage.m
//  eZignal
//
//  Created by MacMini on 5/15/13.
//  Copyright (c) 2013 MacMini. All rights reserved.
//

#import "SetLanguage.h"

@interface SetLanguage ()

@end

@implementation SetLanguage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation duration: (NSTimeInterval) duration {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if(interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            SetLanguage *setLanguage = [[SetLanguage alloc] initWithNibName:@"SetLanguage" bundle:nil];
            [self.navigationController pushViewController:setLanguage animated:NO];
        }
        else
        {
            SetLanguage *setLanguage = [[SetLanguage alloc] initWithNibName:@"SetLanguage_Land" bundle:nil];
            [self.navigationController pushViewController:setLanguage animated:NO];
        }
    }
    else
    {
        if(interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            SetLanguage *setLanguage = [[SetLanguage alloc] initWithNibName:@"SetLanguage_ipad" bundle:nil];
            [self.navigationController pushViewController:setLanguage animated:NO];
        }
        else
        {
            SetLanguage *setLanguage = [[SetLanguage alloc] initWithNibName:@"SetLanguage_Land_ipad" bundle:nil];
            [self.navigationController pushViewController:setLanguage animated:NO];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goArabicVer:(id)sender
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"language"];
    [defaults synchronize];
    
    Dashboard *dash;
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            dash = [[Dashboard alloc] initWithNibName:@"Dashboard" bundle:nil];
        else
            dash = [[Dashboard alloc] initWithNibName:@"Dashboard_Land" bundle:nil];
    }
    else
    {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            dash = [[Dashboard alloc] initWithNibName:@"Dashboard_ipad" bundle:nil];
        else
            dash = [[Dashboard alloc] initWithNibName:@"Dashboard_Land_ipad" bundle:nil];
    }

    
    [self.navigationController pushViewController:dash animated:NO];
}

- (IBAction)goEnglishVer:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"2" forKey:@"language"];
    [defaults synchronize];
    
    Dashboard *dash;
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            dash = [[Dashboard alloc] initWithNibName:@"Dashboard" bundle:nil];
        else
            dash = [[Dashboard alloc] initWithNibName:@"Dashboard_Land" bundle:nil];
    }
    else
    {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            dash = [[Dashboard alloc] initWithNibName:@"Dashboard_ipad" bundle:nil];
        else
            dash = [[Dashboard alloc] initWithNibName:@"Dashboard_Land_ipad" bundle:nil];
    }
    
    [self.navigationController pushViewController:dash animated:NO];
}
@end
