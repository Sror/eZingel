//
//  Library.m
//  eZignal
//
//  Created by Mona Qora on 5/16/13.
//  Copyright (c) 2013 MacMini. All rights reserved.
//

#import "Library.h"
#import "ReaderThumbRender.h"
#import "ReaderThumbCache.h"
#import "ReaderThumbView.h"
#import <ImageIO/ImageIO.h>
#import "AppDelegate.h"
#import "pdfModel.h"
#import "favModel.h"
#import "AppDelegate.h"
#import "PSCKioskPDFViewController.h"
#import "PSCImageGridViewCell.h"
#import "PSCMagazine.h"
#import "PSCMagazineFolder.h"
#import "PSCKioskPDFViewController.h"
#import "PSCSettingsController.h"
#import "PSCShadowView.h"
#import "SDURLCache.h"

@interface Library ()

@end

@implementation Library 
@synthesize woodLibScroll,libraryLblHeader,shelfScrol,done;

ReaderThumbRequest *request;
static NSString * const kCellReuseIdentifier = @"collectionViewCell";

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        db = [[DbAccessor alloc] init];
        
    }
    return self;
}




-(void) loadWord
{
    indicator =[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        indicator.frame=CGRectMake(100, 120, 120, 160);
    else
        indicator.frame=CGRectMake(220, 250, 310, 384);
    
    [self.view addSubview:indicator];
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    NSString *tempPath = [documentsDir stringByAppendingPathComponent:@"Temp"];
    filePathWord = [[NSBundle bundleWithPath:tempPath] pathsForResourcesOfType:@"docx" inDirectory:nil];
    
  //  NSString *FilePath = [[NSBundle mainBundle] pathForResource:@"T2 Maroutah The book" ofType:@"docx"];
    

    int x = 50 , y = 30,count = filePathWord.count;
    
    booksCount= count;
    if(booksCount %3 == 0)
        reminder=(booksCount /3)-3;
    else
        reminder=(booksCount/3)-2;
    
    //if(count > 1)
    if(filePathWord.count > 0)
    {
        for(int i = 0 ; i < count ; i++)
        {
             NSURL *url = [NSURL fileURLWithPath:[filePathWord objectAtIndex:i] isDirectory:YES];
          //  NSURL *url = [NSURL fileURLWithPath:filePath];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            UIWebView * fileThunminal = [[UIWebView alloc] initWithFrame:CGRectMake(x, y, 150, 200)];
            fileThunminal.userInteractionEnabled = NO;
            fileThunminal.scalesPageToFit = YES;
            fileThunminal.delegate = self;
            [self.view addSubview:fileThunminal];
            [fileThunminal loadRequest:request];
            
            [self.shelfScrol addSubview:fileThunminal];
            
            UIButton * viewFile = [[UIButton alloc] initWithFrame:CGRectMake(x,y, 150, 200)];
            [viewFile setTag:(i+1)*200];
            [viewFile addTarget:self action:@selector(OpenFile:) forControlEvents:UIControlEventTouchUpInside];
            [self.shelfScrol addSubview:viewFile];
            
            if( (i+1)%3 == 0)
            {
                y += 240;
                x = 50;
            }
            else
                x += 210;
        }
        
        if(count % 3 != 0)
            count = (count / 3) + (count % 3);
        else
            count = count / 3;
        
        [shelfScrol setContentSize:CGSizeMake(700, (count +1) * 200)];
    }
    else
        [indicator stopAnimating];

}

-(void) loadPdf
{
    indicator =[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        indicator.frame=CGRectMake(100, 120, 120, 160);
    else
        indicator.frame=CGRectMake(220, 250, 310, 384);
    
    [self.view addSubview:indicator];
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    
     NSString *FilePath = [[NSBundle mainBundle] pathForResource:@"T2 Maroutah The book" ofType:@"pdf"];
    
    
    
    
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone)
    {
        int x = 50 , y = 30;
        int i  = 0;
       
            NSURL *url = [NSURL fileURLWithPath:FilePath isDirectory:YES];
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
            
            [self.shelfScrol addSubview:fileThunminal];
            
            UIButton * viewFile;
            
            if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
                viewFile = [[UIButton alloc] initWithFrame:CGRectMake(x,y, 150, 200)];
            else
                viewFile = [[UIButton alloc] initWithFrame:CGRectMake(x,y, 100, 130)];
        
            [viewFile setTag:(i+1)*200];
            [viewFile addTarget:self action:@selector(OpenFile:) forControlEvents:UIControlEventTouchUpInside];
            [self.shelfScrol addSubview:viewFile];
            
    }
    else
    {
        int x = 10 , y = 30;
        int i  = 0;
           NSURL *url = [NSURL fileURLWithPath:FilePath isDirectory:YES];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            UIWebView * fileThunminal;
            
            if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
                fileThunminal = [[UIWebView alloc] initWithFrame:CGRectMake(x, y, 70, 80)];
            else
                fileThunminal = [[UIWebView alloc] initWithFrame:CGRectMake(x, y-25, 40, 50)];
            
            fileThunminal.userInteractionEnabled = NO;
            fileThunminal.scalesPageToFit = YES;
            fileThunminal.delegate = self;
            [self.view addSubview:fileThunminal];
            [fileThunminal loadRequest:request];
            
            [self.shelfScrol addSubview:fileThunminal];
            
            UIButton * viewFile;
            
            if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
                viewFile = [[UIButton alloc] initWithFrame:CGRectMake(x,y, 70, 80)];
            else
                viewFile = [[UIButton alloc] initWithFrame:CGRectMake(x,y, 40, 50)];
            
            [viewFile setTag:(i+1)*200];
            [viewFile addTarget:self action:@selector(OpenFile:) forControlEvents:UIControlEventTouchUpInside];
            [self.shelfScrol addSubview:viewFile];
            
          
    }
}
/*-(void)loadPdf
{
    
    indicator =[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        indicator.frame=CGRectMake(100, 120, 120, 160);
    else
        indicator.frame=CGRectMake(220, 250, 310, 384);
    
    [self.view addSubview:indicator];
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    
   
    
   // NSString *FilePath = [[NSBundle mainBundle] pathForResource:@"T2 Maroutah The book" ofType:@"pdf"];
    
    
    pdfList         = [db getPdfs];
    booksCount = [pdfList count];
    if(booksCount == 0)
    {
        [indicator stopAnimating];
    }
    
     UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone)
    {
    int x = 50 , y = 30;
    int i  = 0;

    for(pdfModel *obj in pdfList)
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
        
        [self.shelfScrol addSubview:fileThunminal];
        
        UIButton * viewFile;
        
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            viewFile = [[UIButton alloc] initWithFrame:CGRectMake(x,y, 150, 200)];
        else
            viewFile = [[UIButton alloc] initWithFrame:CGRectMake(x,y, 100, 130)];
        
        [viewFile setTag:(i+1)*200];
        [viewFile addTarget:self action:@selector(OpenFile:) forControlEvents:UIControlEventTouchUpInside];
        [self.shelfScrol addSubview:viewFile];
        
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
        [shelfScrol setContentSize:CGSizeMake(700, (booksCount +1) * 200)];
    else
        [shelfScrol setContentSize:CGSizeMake(700, (booksCount +1) * 130)];
    
    }
    else
    {
        int x = 10 , y = 30;
        int i  = 0;
        
        for(pdfModel *obj in pdfList)
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
            
            [self.shelfScrol addSubview:fileThunminal];
            
            UIButton * viewFile;
            
            if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
                viewFile = [[UIButton alloc] initWithFrame:CGRectMake(x,y, 70, 80)];
            else
                viewFile = [[UIButton alloc] initWithFrame:CGRectMake(x,y, 40, 50)];
            
            [viewFile setTag:(i+1)*200];
            [viewFile addTarget:self action:@selector(OpenFile:) forControlEvents:UIControlEventTouchUpInside];
            [self.shelfScrol addSubview:viewFile];
            
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
            [shelfScrol setContentSize:CGSizeMake(282, (booksCount +1) * 80)];
        else
            [shelfScrol setContentSize:CGSizeMake(282, (booksCount +1) * 50)];
    }
}
*/
-(IBAction)OpenFile:(id)sender
{
    NSString *phrase = nil;
    ReaderDocument *document;
   
    NSString *FilePath = [[NSBundle mainBundle] pathForResource:@"T2 Maroutah The book" ofType:@"pdf"];

    document = [ReaderDocument withDocumentFilePath:FilePath password:phrase];
    
  /*  int i = 0;
    for(pdfModel *obj in pdfList)
    {
        if(i == (([sender tag]/200)-1))
        {
            document = [ReaderDocument withDocumentFilePath:[obj pdfPath] password:phrase];
            break;
        }
        i++;
    }*/
    
    NSURL *samplesURL = [NSURL fileURLWithPath:FilePath isDirectory:YES];
    
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
    
   // PSCKioskPDFViewController *pdfController = [[PSCKioskPDFViewController alloc] initWithDocument:document];
	/*if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
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
	}
*/
}

- (UIImage *)imageForMagazine:(PSCMagazine *)magazine {
    if (!magazine) return nil;
    
    NSUInteger lastPage = magazine.lastViewState.page;
    UIImage *coverImage = [PSPDFCache.sharedCache imageFromDocument:magazine page:lastPage size:UIScreen.mainScreen.bounds.size options:PSPDFCacheOptionDiskLoadSync|PSPDFCacheOptionRenderSync|PSPDFCacheOptionMemoryStoreAlways];
    return coverImage;
}

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
	[self.navigationController popViewControllerAnimated:YES];
    
#else // dismiss the modal view controller
    
	[self dismissModalViewControllerAnimated:YES];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [indicator stopAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];


    
    [done setHidden:YES];

    shelfScrol.showsVerticalScrollIndicator = NO;
    shelfScrol.delegate = self;
   /* if(((AppDelegate *)[UIApplication sharedApplication].delegate).fileType == 0)
    {
        [self loadWord];
        segmentSwitcher.selectedSegmentIndex = 1;
    }
    else
    {
        [self loadPdf];
        segmentSwitcher.selectedSegmentIndex = 0;
    }*/
    
    [self loadPdf];
    
    [woodLibScroll setHidden:NO];
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
    libraryLblHeader.text   = [lang objectForKey:[NSString stringWithFormat:@"%d",1]];
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (IBAction)editBtn:(id)sender {
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
     [done setHidden:NO];
    
    if(booksCount >0)
        [done setHidden:NO];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
    {
        int x = 8 , y = 30;
             UIButton *delete,*fav;
            if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
                delete = [[UIButton alloc] initWithFrame:CGRectMake(x-2,y-10, 21, 21)];
            else
                delete = [[UIButton alloc] initWithFrame:CGRectMake(x,y-30, 21, 21)];
            
            [delete setTag:2000];
            [delete setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
            [delete addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
            [self.shelfScrol addSubview:delete];
            
            if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
                fav = [[UIButton alloc] initWithFrame:CGRectMake(x+60,y+70, 21, 21)];
            else
                fav = [[UIButton alloc] initWithFrame:CGRectMake(x+30,y+10, 21, 21)];
            
            [fav setTag:2000];
            [fav setBackgroundImage:[UIImage imageNamed:@"Fav Star.png"] forState:UIControlStateNormal];
            [fav addTarget:self action:@selector(fav:) forControlEvents:UIControlEventTouchUpInside];
            [self.shelfScrol addSubview:fav];
            
     
        
    }
    else
    {
        int x = 50 , y = 30;
       
            UIButton *delete,*fav;
            if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
                delete = [[UIButton alloc] initWithFrame:CGRectMake(x,y, 30, 30)];
            else
                delete = [[UIButton alloc] initWithFrame:CGRectMake(x-3,y-4, 30, 30)];
            
            
            [delete setTag:2000];
            [delete setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
            [delete addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
            [self.shelfScrol addSubview:delete];
            
            if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
                fav = [[UIButton alloc] initWithFrame:CGRectMake(x+130,y+170, 30, 30)];
            else
                fav = [[UIButton alloc] initWithFrame:CGRectMake(x+75,y+110, 30, 30)];
            
            
            [fav setTag:2000];
            [fav setBackgroundImage:[UIImage imageNamed:@"Fav Star.png"] forState:UIControlStateNormal];
            [fav addTarget:self action:@selector(fav:) forControlEvents:UIControlEventTouchUpInside];
            [self.shelfScrol addSubview:fav];
            
       
    }
}

/*- (IBAction)editBtn:(id)sender {
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(booksCount >0)
       [done setHidden:NO];
     if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
     {
    int x = 8 , y = 30;
    for(int i = 0 ; i < booksCount ; i++)
    {
        UIButton *delete,*fav;
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            delete = [[UIButton alloc] initWithFrame:CGRectMake(x-2,y-10, 21, 21)];
        else
            delete = [[UIButton alloc] initWithFrame:CGRectMake(x,y-5, 21, 21)];
        
        [delete setTag:(i+1)*2000];
        [delete setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [delete addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        [self.shelfScrol addSubview:delete];
        
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            fav = [[UIButton alloc] initWithFrame:CGRectMake(x+20,y+10, 21, 21)];
        else
            fav = [[UIButton alloc] initWithFrame:CGRectMake(x+50,y+60, 21, 21)];
        
        [fav setTag:(i+1)*2000];
        [fav setBackgroundImage:[UIImage imageNamed:@"Fav Star.png"] forState:UIControlStateNormal];
        [fav addTarget:self action:@selector(fav:) forControlEvents:UIControlEventTouchUpInside];
        [self.shelfScrol addSubview:fav];
        
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
        UIButton *delete,*fav;
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            delete = [[UIButton alloc] initWithFrame:CGRectMake(x,y, 30, 30)];
        else
            delete = [[UIButton alloc] initWithFrame:CGRectMake(x-3,y-4, 30, 30)];
            
        
        [delete setTag:(i+1)*2000];
        [delete setBackgroundImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
        [delete addTarget:self action:@selector(delete:) forControlEvents:UIControlEventTouchUpInside];
        [self.shelfScrol addSubview:delete];
        
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation))
            fav = [[UIButton alloc] initWithFrame:CGRectMake(x+130,y+170, 30, 30)];
        else
            fav = [[UIButton alloc] initWithFrame:CGRectMake(x+75,y+110, 30, 30)];
            
        
        [fav setTag:(i+1)*2000];
        [fav setBackgroundImage:[UIImage imageNamed:@"Fav Star.png"] forState:UIControlStateNormal];
        [fav addTarget:self action:@selector(fav:) forControlEvents:UIControlEventTouchUpInside];
        [self.shelfScrol addSubview:fav];
        
        if( (i+1)%3 == 0)
        {
            y += 240;
            x = 50;
        }
        else
            x += 210;
    }
    }
}*/

-(IBAction)delete:(id)sender
{
    pdfList         = [db getPdfs];
    NSMutableArray *favList         = [db getFav];
    booksCount = [pdfList count];
    NSString *str;
    for(favModel *obj in favList)
    {
        str = [obj pdfPath];
    }
    
    if(booksCount == 0)
    {
        [indicator stopAnimating];
    }
    else
    {
        int indx = 0;
        for(pdfModel *obj in pdfList)
        {
            if((([sender tag]/2000)-1) == indx)
            {
                [db deletePdf:[obj pdfPath]];
                break;
            }
            indx++;
        }
    }
    NSArray *arr = [shelfScrol subviews];
    for(UIView *v in arr)
        [v removeFromSuperview];
    [self loadPdf];

}
-(IBAction)fav:(id)sender
{
    pdfList         = [db getPdfs];
    NSMutableArray *favList         = [db getFav];
    booksCount = [pdfList count];
    NSString *str;
    for(favModel *obj in favList)
    {
        str = [obj pdfPath];
    }
    
    if(booksCount == 0)
    {
        [indicator stopAnimating];
    }
    else
    {
        int indx = 0;
        for(pdfModel *obj in pdfList)
        {
            if((([sender tag]/2000)-1) == indx)
            {
                if(![[obj pdfPath] isEqualToString:str])
                {
                    [db addToFav:[obj pdfPath]];
                    break;
                }
            }
            indx++;
        }
    }
}

- (IBAction)done:(id)sender {
    NSArray *arr = [self.shelfScrol subviews];
    for(UIView *v in arr)
        [v removeFromSuperview];
    
    [self loadPdf];
    [done setHidden:YES];
    lastOffset = 0;
    downCount = 0;
}
@end
