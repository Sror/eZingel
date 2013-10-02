//
//  Dashboard.m
//  eZignal
//
//  Created by Mona Qora on 5/16/13.
//  Copyright (c) 2013 MacMini. All rights reserved.
//

#import "Dashboard.h"
#import "Library.h"
#import "AppDelegate.h"
#import "Browse.h"
#import "WishList.h"
#import "Login.h"
@interface Dashboard ()

@end

@implementation Dashboard
@synthesize menu,headerScroll,mainView,menuBtnOut,library,browse,wishlist,logout,scrollInsideMenu,contactUs;

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
            Dashboard *dash = [[Dashboard alloc] initWithNibName:@"Dashboard" bundle:nil];
            [self.navigationController pushViewController:dash animated:NO];
        }
        else
        {
            Dashboard *dash = [[Dashboard alloc] initWithNibName:@"Dashboard_Land" bundle:nil];
            [self.navigationController pushViewController:dash animated:NO];
        }
    }
    else
    {
        if(interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
        {
            Dashboard *dash = [[Dashboard alloc] initWithNibName:@"Dashboard_ipad" bundle:nil];
            [self.navigationController pushViewController:dash animated:NO];
        }
        else
        {
            Dashboard *dash = [[Dashboard alloc] initWithNibName:@"Dashboard_Land_ipad" bundle:nil];
            [self.navigationController pushViewController:dash animated:NO];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ((AppDelegate *) [UIApplication sharedApplication].delegate).currentBack = 1;
    scrollInsideMenu.scrollEnabled = YES;
     if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
         [scrollInsideMenu setContentSize:CGSizeMake(scrollInsideMenu.frame.size.width, 460)];
     else
        [scrollInsideMenu setContentSize:CGSizeMake(scrollInsideMenu.frame.size.width, 1230)];
    
    [scrollInsideMenu setBounces:NO];
    
    UISwipeGestureRecognizer *oneFingerSwipeLeft =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showMenu:)];
    [oneFingerSwipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [mainView addGestureRecognizer:oneFingerSwipeLeft];
    
    UISwipeGestureRecognizer *oneFingerSwipeRight =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(closeMenu:)];
    [oneFingerSwipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [mainView addGestureRecognizer:oneFingerSwipeRight];
    
    Library *lib;
    ((AppDelegate *)[UIApplication sharedApplication].delegate).tabIndex = 1;
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            lib = [[Library alloc] initWithNibName:@"Library" bundle:nil];
        else
            lib = [[Library alloc] initWithNibName:@"Library_Land" bundle:nil];
    }
    else  
    {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            lib = [[Library alloc] initWithNibName:@"Library_ipad" bundle:nil];
        else
            lib = [[Library alloc] initWithNibName:@"Library_Land_ipad" bundle:nil];
    }


    lib.view.frame = mainView.bounds;
    [self.mainView addSubview:lib.view];
    [self addChildViewController:lib];
    
    
    
    NSUserDefaults *defaults  = [NSUserDefaults standardUserDefaults];
    NSString *languageChoosen      = [defaults objectForKey:@"language"];
    NSString *myFile;
    if ([languageChoosen isEqualToString:@"1"])
    {
        myFile = [[NSBundle mainBundle]
                  pathForResource:@"ArabicList" ofType:@"plist"];
    }
    else
    {
        myFile = [[NSBundle mainBundle]
                  pathForResource:@"EnglishList" ofType:@"plist"];
    }
    NSDictionary *lang = [[NSDictionary alloc] initWithContentsOfFile:myFile];
   library.text   = [lang objectForKey:[NSString stringWithFormat:@"%d",1]];
    browse.text   = [lang objectForKey:[NSString stringWithFormat:@"%d",2]];
    wishlist.text   = [lang objectForKey:[NSString stringWithFormat:@"%d",3]];
    contactUs.text   = [lang objectForKey:[NSString stringWithFormat:@"%d",4]];
    logout.text   = [lang objectForKey:[NSString stringWithFormat:@"%d",5]];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)menuBtn:(id)sender
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        
        [UIView  beginAnimations: @"Showinfo"context: nil];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        if(!menuFlag)
        {
            [menuBtnOut setSelected:YES];
            [headerScroll setFrame:CGRectMake(222, 0, headerScroll.frame.size.width, headerScroll.frame.size.height)];
            [mainView setFrame:CGRectMake(222, mainView.frame.origin.y, mainView.frame.size.width, mainView.frame.size.height)];
        }
        else
        {
            [menuBtnOut setSelected:NO];
            [headerScroll setFrame:CGRectMake(0, 0,  headerScroll.frame.size.width, headerScroll.frame.size.height)];
            [mainView setFrame:CGRectMake(0, mainView.frame.origin.y, mainView.frame.size.width, mainView.frame.size.height)];
        }
        menuFlag =! menuFlag;
        [UIView commitAnimations];
    }
    else
    {
        
        [UIView  beginAnimations: @"Showinfo"context: nil];
        [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.3];
        if(!menuFlag)
        {
            [menuBtnOut setSelected:YES];
            [headerScroll setFrame:CGRectMake(585, 0, headerScroll.frame.size.width, headerScroll.frame.size.height)];
            [mainView setFrame:CGRectMake(585, mainView.frame.origin.y,mainView.frame.size.width, mainView.frame.size.height)];
        }
        else
        {
            [menuBtnOut setSelected:NO];
            [headerScroll setFrame:CGRectMake(0, 0, headerScroll.frame.size.width, headerScroll.frame.size.height)];
            [mainView setFrame:CGRectMake(0, mainView.frame.origin.y, mainView.frame.size.width, mainView.frame.size.height)];
        }
        menuFlag =! menuFlag;
        [UIView commitAnimations];
    }
        
}

- (IBAction)contactUs:(id)sender {
    
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        
        mailer.mailComposeDelegate = self;
        
        [mailer setSubject:@"support"];
        
        NSArray *toRecipients = [NSArray arrayWithObjects: @"Support@ezingel.com",nil];
        [mailer setToRecipients:toRecipients];
        [self presentModalViewController:mailer animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    if (error) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"error" message:[NSString stringWithFormat:@"error %@",[error description]] delegate:nil cancelButtonTitle:@"dismiss" otherButtonTitles:nil, nil];
        [alert show];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(IBAction)closeMenu:(id)sender
{
   
    if(!menuFlag)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {

            [UIScrollView beginAnimations:nil context:NULL];
            [UIScrollView setAnimationDuration:0.3];
            [UIScrollView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [mainView setFrame:CGRectMake(222, mainView.frame.origin.y, mainView.frame.size.width, mainView.frame.size.height)];
            [headerScroll setFrame:CGRectMake(222, 0, headerScroll.frame.size.width, headerScroll.frame.size.height)];
            menuFlag =! menuFlag;
            [UIView commitAnimations];
            
        }
        else
        {
            [UIScrollView beginAnimations:nil context:NULL];
            [UIScrollView setAnimationDuration:0.3];
            [UIScrollView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [mainView setFrame:CGRectMake(585, mainView.frame.origin.y, mainView.frame.size.width, mainView.frame.size.height
                                          )];
            [headerScroll setFrame:CGRectMake(585, 0,headerScroll.frame.size.width, headerScroll.frame.size.height)];
            menuFlag =! menuFlag;
            [UIView commitAnimations];
        }
    }
        
}

-(IBAction)showMenu:(id)sender
{
    if(menuFlag)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            
            [UIScrollView beginAnimations:nil context:NULL];
            [UIScrollView setAnimationDuration:0.3];
            [UIScrollView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [mainView setFrame:CGRectMake(0, mainView.frame.origin.y, mainView.frame.size.width, mainView.frame.size.height)];
            [headerScroll setFrame:CGRectMake(0, 0, headerScroll.frame.size.width, headerScroll.frame.size.height)];
            menuFlag =! menuFlag;
            [UIView commitAnimations];
            
        }
        else
        {
            [UIScrollView beginAnimations:nil context:NULL];
            [UIScrollView setAnimationDuration:0.3];
            [UIScrollView setAnimationCurve:UIViewAnimationCurveEaseOut];
            [mainView setFrame:CGRectMake(0, mainView.frame.origin.y, mainView.frame.size.width, mainView.frame.size.height)];
            [headerScroll setFrame:CGRectMake(0, 0, headerScroll.frame.size.width, headerScroll.frame.size.height)];
            menuFlag =! menuFlag;
            [UIView commitAnimations];
        }
    }
}

- (IBAction)goLibrary:(id)sender {
    NSArray *arr = mainView.subviews;
    for (UIView *v in arr)
        [v removeFromSuperview];
     UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    Library *lib;
    ((AppDelegate *)[UIApplication sharedApplication].delegate).tabIndex = 1;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [UIScrollView beginAnimations:nil context:NULL];
        [UIScrollView setAnimationDuration:0.3];
        [UIScrollView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [mainView setFrame:CGRectMake(0, mainView.frame.origin.y, mainView.frame.size.width, mainView.frame.size.height)];
        [headerScroll setFrame:CGRectMake(0, headerScroll.frame.origin.y, headerScroll.frame.size.width, headerScroll.frame.size.height)];
        [UIView commitAnimations];
         menuFlag =! menuFlag;
          if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
              lib = [[Library alloc] initWithNibName:@"Library" bundle:nil];
          else
              lib = [[Library alloc] initWithNibName:@"Library_Land" bundle:nil];
    }
    else
    {
        [UIScrollView beginAnimations:nil context:NULL];
        [UIScrollView setAnimationDuration:0.3];
        [UIScrollView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [mainView setFrame:CGRectMake(0, mainView.frame.origin.y, mainView.frame.size.width, mainView.frame.size.height)];
        [headerScroll setFrame:CGRectMake(0, headerScroll.frame.origin.y, headerScroll.frame.size.width, headerScroll.frame.size.height)];
        [UIView commitAnimations];
         menuFlag =! menuFlag;
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            lib = [[Library alloc] initWithNibName:@"Library_ipad" bundle:nil];
        else
            lib = [[Library alloc] initWithNibName:@"Library_Land_ipad" bundle:nil];
    }
   
    lib.view.frame = mainView.bounds;
    [self.mainView addSubview:lib.view];
    [self addChildViewController:lib];
}


- (IBAction)goBrowse:(id)sender {
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    NSArray *arr = mainView.subviews;
    for (UIView *v in arr)
        [v removeFromSuperview];
    Browse *br;
    ((AppDelegate *)[UIApplication sharedApplication].delegate).tabIndex = 2;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [UIScrollView beginAnimations:nil context:NULL];
        [UIScrollView setAnimationDuration:0.3];
        [UIScrollView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [mainView setFrame:CGRectMake(0, mainView.frame.origin.y, mainView.frame.size.width, mainView.frame.size.height)];
        [headerScroll setFrame:CGRectMake(0, 0, headerScroll.frame.size.width, headerScroll.frame.size.height)];
        menuFlag =! menuFlag;
        [UIView commitAnimations];
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
             br = [[Browse alloc] initWithNibName:@"Browse" bundle:nil];
        else
             br = [[Browse alloc] initWithNibName:@"Browse_Land" bundle:nil];
    }
    else
    {
        [UIScrollView beginAnimations:nil context:NULL];
        [UIScrollView setAnimationDuration:0.3];
        [UIScrollView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [mainView setFrame:CGRectMake(0, mainView.frame.origin.y, mainView.frame.size.width, mainView.frame.size.height)];
        [headerScroll setFrame:CGRectMake(0, 0, headerScroll.frame.size.width, headerScroll.frame.size.height)];
        menuFlag =! menuFlag;
        [UIView commitAnimations];
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            br = [[Browse alloc] initWithNibName:@"Browse_ipad" bundle:nil];
        else
            br = [[Browse alloc] initWithNibName:@"Browse_Land_ipad" bundle:nil];
    }

    br.view.frame = mainView.bounds;
    [self.mainView addSubview:br.view];
    [self addChildViewController:br];
}

- (IBAction)goWishList:(id)sender {
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    NSArray *arr = mainView.subviews;
    for (UIView *v in arr)
        [v removeFromSuperview];
    WishList *wl;
    ((AppDelegate *)[UIApplication sharedApplication].delegate).tabIndex = 3;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        [UIScrollView beginAnimations:nil context:NULL];
        [UIScrollView setAnimationDuration:0.3];
        [UIScrollView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [mainView setFrame:CGRectMake(0, mainView.frame.origin.y, mainView.frame.size.width, mainView.frame.size.height)];
        [headerScroll setFrame:CGRectMake(0, 0, headerScroll.frame.size.width, headerScroll.frame.size.height)];
        menuFlag =! menuFlag;
        [UIView commitAnimations];
        
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            wl = [[WishList alloc] initWithNibName:@"WishList" bundle:nil];
        else
            wl = [[WishList alloc] initWithNibName:@"WishList_Land" bundle:nil];
    }
    else
    {
        [UIScrollView beginAnimations:nil context:NULL];
        [UIScrollView setAnimationDuration:0.3];
        [UIScrollView setAnimationCurve:UIViewAnimationCurveEaseOut];
        [mainView setFrame:CGRectMake(0, mainView.frame.origin.y, mainView.frame.size.width, mainView.frame.size.height)];
        [headerScroll setFrame:CGRectMake(0, 0, headerScroll.frame.size.width, headerScroll.frame.size.height)];
        menuFlag =! menuFlag;
        [UIView commitAnimations];
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            wl = [[WishList alloc] initWithNibName:@"WishList_ipad" bundle:nil];
        else
            wl = [[WishList alloc] initWithNibName:@"WishList_Land_ipad" bundle:nil];
    }
    
    wl.view.frame = mainView.bounds;
    [self.mainView addSubview:wl.view];
    [self addChildViewController:wl];
}

- (IBAction)logout:(id)sender {
    Login *login;
     UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            login = [[Login alloc] initWithNibName:@"Login" bundle:nil];
        else
            login = [[Login alloc] initWithNibName:@"Login_Land" bundle:nil];
    }
    else
    {
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            login = [[Login alloc] initWithNibName:@"Login_ipad" bundle:nil];
        else
            login = [[Login alloc] initWithNibName:@"Login_Land_ipad" bundle:nil];
    }
        
    
    [UIView  beginAnimations: @"Showinfo"context: nil];
    [UIView setAnimationCurve: UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];

    [self.navigationController pushViewController:login animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
}


@end
