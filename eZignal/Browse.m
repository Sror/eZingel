//
//  Browse.m
//  eZignal
//
//  Created by MacMini on 5/19/13.
//  Copyright (c) 2013 MacMini. All rights reserved.
//

#import "Browse.h"
#import "ASIHTTPRequest.h"
#import "ZipArchive.h"
#import "Dashboard.h"
#import "SVProgressHUD.h"
#import "Library.h"
#import "AppDelegate.h"
#import "DbAccessor.h"
@interface Browse ()

@end

@implementation Browse
@synthesize browseLblHeader,storeWebView;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        db = [[DbAccessor alloc] init];
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];
}
-(void)loadWeb
{
    [SVProgressHUD show];
   // NSURL *targetURL = [NSURL URLWithString:@"http://www.memoware.com"];
    NSURL *targetURL = [NSURL URLWithString:@"https://www.ezingel.com/7-e-books"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    storeWebView.delegate = self;
    [storeWebView setScalesPageToFit:YES];
    [storeWebView loadRequest:request];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if(navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSURL *requestedURL = [request URL];
        NSString * str = requestedURL.absoluteString;
        NSLog(@"%@",requestedURL.absoluteString);
        NSRange range = [str rangeOfString:@".pdf"];
       // NSRange range2 = [str rangeOfString:@"doc"];
        if (range.location != NSNotFound )
        {
            NSArray *fileName = [requestedURL.absoluteString componentsSeparatedByString:@"/"];
            NSString * fileNameWithExtention = [fileName objectAtIndex:fileName.count-1];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            
            NSString *documentsDir = [paths objectAtIndex:0];
            NSString *tempPath     = [documentsDir stringByAppendingPathComponent:@"Temp"];
            NSFileManager * fileMan = [[NSFileManager alloc] init];
            NSArray * files = [fileMan contentsOfDirectoryAtPath:tempPath error:nil];
            int i;
            for(i = 0 ; i <files.count;i++)
            {
                if([fileNameWithExtention isEqualToString:[files objectAtIndex:i]])
                {
                    break;
                }
            }
            if(i == files.count)
            {
                if([self DownloadFile:requestedURL.absoluteString])
                {
                    ((AppDelegate *)[UIApplication sharedApplication].delegate).fileType = 1;
                }
            }
            else
            {
                [[[UIAlertView alloc] initWithTitle:@"warning" message:@"This file is already downloaded !" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil] show];
            }
        }
       /* else if (range2.location != NSNotFound)
        {
            if([self DownloadFile:requestedURL.absoluteString])
            {
                ((AppDelegate *)[UIApplication sharedApplication].delegate).fileType = 0;
            }
        }*/
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [SVProgressHUD dismiss];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
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
    browseLblHeader.text   = [lang objectForKey:[NSString stringWithFormat:@"%d",2]];
    
   [self loadWeb];
    
}
-(BOOL) DownloadFile:(NSString*) downloadLink
{
    ASIHTTPRequest *request;
    UIProgressView *theProgressView;
    progressAlert = [[UIAlertView alloc] initWithTitle:@"Downloading"  message: @"Please wait..." delegate: self cancelButtonTitle: nil otherButtonTitles: nil];
    theProgressView = [[UIProgressView alloc] initWithFrame:CGRectMake(20.0f, 100.0f, 220.0f, 9.0f)];
    
    [progressAlert addSubview:theProgressView];
    
    
    [theProgressView setProgressViewStyle: UIProgressViewStyleBar];
    
    [progressAlert show];
    
    
  
        NSURL *theURL= [NSURL URLWithString:downloadLink] ;
        request = [ASIHTTPRequest requestWithURL:theURL];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains
        (NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [paths objectAtIndex:0];
        NSString *tempPath = [documentsDir stringByAppendingPathComponent:@"Temp"];
        
        BOOL isDir;
        
        BOOL success;
        
        if (![fileManager fileExistsAtPath: tempPath isDirectory:&isDir])
        {
            success =  [fileManager createDirectoryAtPath:tempPath withIntermediateDirectories:YES attributes:Nil error:&error];
            if (success) {
                // NSLog(@"Success  %@",tempPath);
            }
            else
            {
                
                   // NSLog(@"Error   %@    %@",tempPath, [error description]);
                
                return FALSE;
            }
        }
        NSArray *fileName = [downloadLink componentsSeparatedByString:@"/"];
        NSString * fileNameWithExtention = [fileName objectAtIndex:fileName.count-1];
        NSString *fileNameWithDownload = [NSString stringWithFormat:@"%@.download",fileNameWithExtention];
    
        destination = [tempPath stringByAppendingPathComponent:fileNameWithExtention];
        NSString *   temporaryFileDownloadPath=[tempPath stringByAppendingPathComponent:fileNameWithDownload];
        [UIApplication sharedApplication].idleTimerDisabled=YES;
        [request setDownloadDestinationPath:destination];
        [request setTemporaryFileDownloadPath:temporaryFileDownloadPath];
        [request setAllowResumeForFileDownloads:YES];
        
        
        [progressAlert show];
        
        
        
        [request setDownloadProgressDelegate:theProgressView];
        
        request.showAccurateProgress=YES;
        [request setDelegate:self];
        
                
        [request setRequestMethod:@"GET"];
        [request startAsynchronous];
         
    
    return TRUE;
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    NSError *requestError = [request error];
    if (!requestError)
    {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        
        NSString *documentsDir = [paths objectAtIndex:0];
        NSString *tempPath     = [documentsDir stringByAppendingPathComponent:@"Temp"];
       // NSArray *filePathPdf = [[NSBundle bundleWithPath:tempPath] pathsForResourcesOfType:@"pdf" inDirectory:nil];
        
        
        
        NSFileManager * fileMan = [[NSFileManager alloc] init];
        NSArray * files = [fileMan contentsOfDirectoryAtPath:tempPath error:nil];
        
        if (files)
        {
            int count = 0;
            for(int index=0;index<files.count;index++)
            {
                NSString * file = [files objectAtIndex:files.count-1];
                
                if( [[file pathExtension] compare: @"pdf"] == NSOrderedSame )
                {
                    if(count == 0)
                    {
                        NSString *filePath =[NSString stringWithFormat:@"%@/%@",tempPath,file];
                        [db savePdf:filePath];
                        count++;
                    }
                }
            }
        }
        
       /* NSLog(@"%d",filePathPdf.count);
       
        NSLog(@"%@       %@",[filePathPdf objectAtIndex:0],[filePathPdf objectAtIndex:filePathPdf.count-1]);
        [db savePdf:[filePathPdf objectAtIndex:filePathPdf.count-1]];
*/
        
        UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
        [progressAlert dismissWithClickedButtonIndex:0 animated:YES];
        [UIApplication sharedApplication].idleTimerDisabled=NO;
        Library *lib;
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
        lib.view.frame = self.view.bounds;
        [self.view addSubview:lib.view];
        [self addChildViewController:lib];
    }
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
