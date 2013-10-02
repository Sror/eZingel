//
//  WishList.m
//  eZingel
//
//  Created by MacMini on 5/20/13.
//  Copyright (c) 2013 MacMini. All rights reserved.
//

#import "WishList.h"
#import "favModel.h"

@interface WishList ()

@end

@implementation WishList
@synthesize wishlistLblHeader,woodLibScroll,tableLibScroll,editBtn,changeBtn,favScroll,done;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        db = [[DbAccessor alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [done setHidden:YES];
    [woodLibScroll setHidden:NO];
    favScroll.showsVerticalScrollIndicator = NO;
    favScroll.delegate = self;
    [tableLibScroll setHidden:YES];
    lastOffset = 0;
    downCount = 0;
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
    wishlistLblHeader.text   = [lang objectForKey:[NSString stringWithFormat:@"%d",3]];
    [self loadPdf];
}

-(void)loadPdf
{
    indicator =[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        indicator.frame=CGRectMake(100, 120, 120, 160);
    else
        indicator.frame=CGRectMake(220, 250, 310, 384);
    
    [self.view addSubview:indicator];
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];

     UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    pdfList         = [db getFav];
    booksCount = [pdfList count];
    if(booksCount == 0)
    {
        [indicator stopAnimating];
    }
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone)
    {
    int x = 50 , y = 30;

    int i  = 0;
 
  
        for(favModel *obj in pdfList)
        {
            NSURL *url = [NSURL fileURLWithPath:[obj pdfPath] isDirectory:YES];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            UIWebView * fileThunminal;
            
            if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
                fileThunminal = [[UIWebView alloc] initWithFrame:CGRectMake(x, y, 150, 200)];
            else
                fileThunminal = [[UIWebView alloc] initWithFrame:CGRectMake(x, y, 100, 130)];
            
            fileThunminal.userInteractionEnabled = NO;
            fileThunminal.scalesPageToFit = YES;
            fileThunminal.delegate = self;
            [self.view addSubview:fileThunminal];
            [fileThunminal loadRequest:request];
            
            [self.favScroll addSubview:fileThunminal];
            
            UIButton * viewFile;
            if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
                viewFile = [[UIButton alloc] initWithFrame:CGRectMake(x,y, 150, 200)];
            else
                viewFile = [[UIButton alloc] initWithFrame:CGRectMake(x,y, 100, 130)];
            
            [viewFile setTag:(i+1)*200];
            [viewFile addTarget:self action:@selector(OpenFile:) forControlEvents:UIControlEventTouchUpInside];
            [self.favScroll addSubview:viewFile];
            
            if( (i+1)%3 == 0)
            {
                if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
                    y += 240;
                else
                    y += 170;

                x = 50;
            }
            else
                x += 210;
            i++;
        }
        
        if(booksCount % 3 != 0)
            booksCount = (booksCount / 3) + (booksCount % 3);
        else
            booksCount = booksCount / 3;
        
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            [favScroll setContentSize:CGSizeMake(700, (booksCount +1) * 200)];
        else
            [favScroll setContentSize:CGSizeMake(700, (booksCount +1) * 130)];
    }
    else
    {
        int x = 10 , y = 30;
        
        int i  = 0;
        
        
        for(favModel *obj in pdfList)
        {
            NSURL *url = [NSURL fileURLWithPath:[obj pdfPath] isDirectory:YES];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            UIWebView * fileThunminal;
            
            if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
                fileThunminal = [[UIWebView alloc] initWithFrame:CGRectMake(x, y, 70, 80)];
            else
                fileThunminal = [[UIWebView alloc] initWithFrame:CGRectMake(x, y, 40, 50)];
            
            fileThunminal.userInteractionEnabled = NO;
            fileThunminal.scalesPageToFit = YES;
            fileThunminal.delegate = self;
            [self.view addSubview:fileThunminal];
            [fileThunminal loadRequest:request];
            
            [self.favScroll addSubview:fileThunminal];
            
            UIButton * viewFile;
            
            if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
                viewFile = [[UIButton alloc] initWithFrame:CGRectMake(x,y, 70, 80)];
            else
                viewFile = [[UIButton alloc] initWithFrame:CGRectMake(x,y, 40, 50)];
            
            [viewFile setTag:(i+1)*200];
            [viewFile addTarget:self action:@selector(OpenFile:) forControlEvents:UIControlEventTouchUpInside];
            [self.favScroll addSubview:viewFile];
            
            if( (i+1)%3 == 0)
            {
                if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
                    y += 110;
                else
                    y += 80;
                x = 10;
            }
            else
                x += 100;
            i++;
        }
        
        if(booksCount % 3 != 0)
            booksCount = (booksCount / 3) + (booksCount % 3);
        else
            booksCount = booksCount / 3;
        
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            [favScroll setContentSize:CGSizeMake(282, (booksCount +1) * 80)];
        else
            [favScroll setContentSize:CGSizeMake(282, (booksCount +1) * 50)];
    }

}



-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone)
    {
        if(lastOffset < scrollView.contentOffset.y)
        {
            if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            {
                if(lastOffset < 230 * reminder)
                {
                    downCount++;
                    lastOffset = 230*downCount;
                }
            }
            else
            {
                if(lastOffset < 160 * reminder)
                {
                    downCount++;
                    lastOffset = 160*downCount;
                }
                
            }
            
        }
        else if(lastOffset > scrollView.contentOffset.y)
        {
            
            if(lastOffset > booksCount)
            {
                downCount--;
                if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
                    lastOffset = (230 * (downCount + 1)) - 230;
                else
                    lastOffset = (160 * (downCount + 1)) - 160;
            }
        }
    }
    else
    {
        if(lastOffset < scrollView.contentOffset.y)
        {
            if(lastOffset < 110 * reminder)
            {
                downCount++;
                lastOffset = 110*downCount;
            }
            
        }
        else if(lastOffset > scrollView.contentOffset.y)
        {
            
            if(lastOffset > booksCount)
            {
                downCount--;
                lastOffset = (110 * (downCount + 1)) - 110;
            }
        }
    }
    [scrollView setContentOffset:CGPointMake(0, lastOffset) animated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [indicator stopAnimating];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeBtn:(id)sender {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        if(!chngeFlag)
        {
            [changeBtn setBackgroundImage:[UIImage imageNamed:@"lib_ipad7.png"] forState:UIControlStateNormal];
            [woodLibScroll setHidden:YES];
            [tableLibScroll setHidden:NO];
            
        }
        else
        {
            [changeBtn setBackgroundImage:[UIImage imageNamed:@"lib_ipad6.png"] forState:UIControlStateNormal];
            [woodLibScroll setHidden:NO];
            [tableLibScroll setHidden:YES];
        }
        chngeFlag =! chngeFlag;
    }
    
    else
    {
        
        if(!chngeFlag)
        {
            [changeBtn setBackgroundImage:[UIImage imageNamed:@"lib Grid button.png"] forState:UIControlStateNormal];
            [woodLibScroll setHidden:YES];
            [tableLibScroll setHidden:NO];
            
        }
        else
        {
            [changeBtn setBackgroundImage:[UIImage imageNamed:@"lib Shelf button.png"] forState:UIControlStateNormal];
            [woodLibScroll setHidden:NO];
            [tableLibScroll setHidden:YES];
        }
        chngeFlag =! chngeFlag;
    }
}

- (IBAction)editBtn:(id)sender {
     UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    if(booksCount >0)
        [done setHidden:NO];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        int x = 8 , y = 30;
        for(int i = 0 ; i < booksCount ; i++)
        {
            UIButton * delete = [[UIButton alloc] initWithFrame:CGRectMake(x,y-5, 21, 21)];
            [delete setTag:(i+1)*2000];
            [delete setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
            [delete addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
            [self.favScroll addSubview:delete];
            
            
            if( (i+1)%3 == 0)
            {
                y += 110;
                x = 8;
            }
            else
                x += 100;
        }

    }
    else
    {
    int x = 50 , y = 30;
    for(int i = 0 ; i < booksCount ; i++)
    {
        UIButton *delete;
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            delete = [[UIButton alloc] initWithFrame:CGRectMake(x,y, 30, 30)];
        else
            delete = [[UIButton alloc] initWithFrame:CGRectMake(x-3,y-4, 30, 30)];

        
        [delete setTag:(i+1)*2000];
        [delete setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [delete addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        [self.favScroll addSubview:delete];
        
        
        if( (i+1)%3 == 0)
        {
            y += 240;
            x = 50;
        }
        else
            x += 210;
    }
    }

}
-(IBAction)OpenFile:(id)sender
{
    NSString *phrase = nil;
    ReaderDocument *document;
    
    // if(segmentSwitcher.selectedSegmentIndex == 1)
    //   document = [ReaderDocument withDocumentFilePath:[filePathWord objectAtIndex:([sender tag]/200)-1] password:phrase];
    //else
    int i = 0;
   /* for(favModel *obj in pdfList)
    {
        if(i == (([sender tag]/200)-1))
        {
            document = [ReaderDocument withDocumentFilePath:[obj pdfPath] password:phrase];
            break;
        }
        i++;
    }*/
    
    for(favModel *obj in pdfList)
    {
        if(i == (([sender tag]/200)-1))
        {
            NSURL *samplesURL = [NSURL fileURLWithPath:[obj pdfPath] isDirectory:YES];
            
            PSPDFViewController *controller = [[PSPDFViewController alloc] initWithDocument:[PSPDFDocument documentWithURL:samplesURL]];
            // Starting with iOS7, we usually don't want to include an internal brightness control.
            // Since PSPDFKit optionally uses an additional software darkener, it can still be useful for certain places like a Pilot's Cockpit.
            BOOL includeBrightnessButton = YES;
            PSC_IF_IOS7_OR_GREATER(includeBrightnessButton = NO;)
            controller.rightBarButtonItems = includeBrightnessButton ? @[controller.annotationButtonItem, controller.brightnessButtonItem,controller.bookmarkButtonItem, controller.searchButtonItem, controller.viewModeButtonItem] : @[controller.annotationButtonItem, controller.searchButtonItem, controller.viewModeButtonItem];
            PSCGoToPageButtonItem *goToPageButton = [[PSCGoToPageButtonItem alloc] initWithPDFViewController:controller];

            controller.pageTransition = PSPDFPageTransitionScrollContinuous;
            controller.scrollDirection = PSPDFScrollDirectionHorizontal;
            controller.fitToWidthEnabled = YES;
            controller.pagePadding = 5.f;
            controller.renderAnimationEnabled = NO;
            controller.statusBarStyleSetting = PSPDFStatusBarStyleDefault;
            [self.navigationController setNavigationBarHidden:NO];
            [self.navigationController pushViewController:controller animated:YES];
            break;
        }
        i++;
    }
   
    
    /*
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
        
        
		ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
		readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
        
		[self.navigationController pushViewController:readerViewController animated:YES];
        
#else // present in a modal view controller
        
		readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
		[self presentModalViewController:readerViewController animated:YES];
        
#endif // DEMO_VIEW_CONTROLLER_PUSH
	}*/
    
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
	[self.navigationController popViewControllerAnimated:YES];
    
#else // dismiss the modal view controller
    
	[self dismissModalViewControllerAnimated:YES];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
}


-(IBAction)delete:(id)sender
{
    NSMutableArray *favList         = [db getFav];
    booksCount = [favList count];

    if(booksCount == 0)
    {
        [indicator stopAnimating];
    }
    else
    {
        int indx = 0;
        for(favModel *obj in favList)
        {
            if((([sender tag]/2000)-1) == indx)
            {
                [db deleteFav:[obj pdfPath]];
                break;
            }
            indx++;
        }
    }
    NSArray *arr = [favScroll subviews];
    for(UIView *v in arr)
        [v removeFromSuperview];
    [self loadPdf];
    
}


- (IBAction)done:(id)sender {
    NSArray *arr = [self.favScroll subviews];
    for(UIView *v in arr)
        [v removeFromSuperview];
    
    [self loadPdf];
    [done setHidden:YES];
    lastOffset = 0;
    downCount = 0;
}
@end
