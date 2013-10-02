//
//  Login.m
//  eZignal
//
//  Created by MacMini on 5/15/13.
//  Copyright (c) 2013 MacMini. All rights reserved.
//

#import "Login.h"


@interface Login ()

@end

@implementation Login
@synthesize emailTxt,passTxt,loginScroll;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) willAnimateRotationToInterfaceOrientation: (UIInterfaceOrientation) interfaceOrientation duration: (NSTimeInterval) duration {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if(interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            Login *login = [[Login alloc] initWithNibName:@"Login" bundle:nil];
            [self.navigationController pushViewController:login animated:NO];
        }
        else
        {
            Login *login = [[Login alloc] initWithNibName:@"Login_Land" bundle:nil];
            [self.navigationController pushViewController:login animated:NO];
        }
    }
    else
    {
        if(interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            Login *login = [[Login alloc] initWithNibName:@"Login_ipad" bundle:nil];
            [self.navigationController pushViewController:login animated:NO];
        }
        else
        {
            Login *login = [[Login alloc] initWithNibName:@"Login_Land_ipad" bundle:nil];
            [self.navigationController pushViewController:login animated:NO];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    passTxt.delegate=self;
    emailTxt.delegate=self;
    loginScroll.scrollEnabled=YES;
    loginScroll.bounces = NO;
   
}

- (void)viewDidUnload
{
    
    [super viewDidUnload];
    [self setEmailTxt:nil];
    [self setPassTxt:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginBtn:(id)sender
{
    SetLanguage *sl;
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            sl = [[SetLanguage alloc] initWithNibName:@"SetLanguage" bundle:nil];
        else
            sl = [[SetLanguage alloc] initWithNibName:@"SetLanguage_Land" bundle:nil];
    }
    else
    {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            sl = [[SetLanguage alloc] initWithNibName:@"SetLanguage_ipad" bundle:nil];
        else
            sl = [[SetLanguage alloc] initWithNibName:@"SetLanguage_Land_ipad" bundle:nil];
    }

    
    [self.navigationController pushViewController:sl animated:NO];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    loginScroll.scrollEnabled = YES;
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
       if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            [loginScroll setContentSize:CGSizeMake(748, 1200)];
        else
            [loginScroll setContentSize:CGSizeMake(1024, 1040)];
             
    }
    else
    {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            [loginScroll setContentSize:CGSizeMake(320, 620)];
        else
            [loginScroll setContentSize:CGSizeMake(320, 440)];
            
    }
   
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    loginScroll.scrollEnabled = NO;
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
        [loginScroll setContentSize:CGSizeMake(320, 580)];
    else
        [loginScroll setContentSize:CGSizeMake(460, 100)];
    
     [loginScroll setContentOffset:CGPointMake(0, 0)];
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    loginScroll.scrollEnabled = NO;
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            [loginScroll setContentSize:CGSizeMake(748, 1024)];
        else
            [loginScroll setContentSize:CGSizeMake(1024, 748)];
    }
  
    [loginScroll setContentOffset:CGPointMake(0, 0)];
    [textField resignFirstResponder];
    return YES;

}



@end
