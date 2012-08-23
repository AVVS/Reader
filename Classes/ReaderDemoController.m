//
//	ReaderDemoController.m
//	Reader v2.5.4
//
//	Created by Julius Oklamcak on 2011-07-01.
//	Copyright © 2011-2012 Julius Oklamcak. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights to
//	use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
//	of the Software, and to permit persons to whom the Software is furnished to
//	do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//	OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//	WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
//	CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

#import "ReaderDemoController.h"
#import "AudioFilesTableViewController.h"

@implementation ReaderDemoController

#pragma mark Constants

#define kBottomToolbarHeight 44.0f
#define kBottomButtonWidth 200.0f
#define kBottomButtonHeight 30.0f

#define UI_USER_INTERFACE_IDIOM() \
([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] ? \
[[UIDevice currentDevice] userInterfaceIdiom] : \
UIUserInterfaceIdiomPhone)

#pragma mark UIViewController methods


- (void)viewDidLoad
{
#ifdef DEBUGX
	NSLog(@"%s %@", __FUNCTION__, NSStringFromCGRect(self.view.bounds));
#endif

	[super viewDidLoad];

	self.view.backgroundColor = [UIColor clearColor]; // Transparent

	self.title = NSLocalizedString(@"main_title", nil); //изменять название программы здесь, используется локализация - менять название нужно в Localizable.strings

	CGSize viewSize = self.view.bounds.size;
    
    UIImage *centralImage = nil;
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ) {
        centralImage = [UIImage imageNamed:@"texture_iphone"]; // to support retina - add @2x of the image with twice the size
    } else {
        centralImage = [UIImage imageNamed:@"texture_ipad"]; // to support retina - add @2x of the image with twice the size
    }
    
    
    
    UIButton *centralButton = [[UIButton alloc] initWithFrame:CGRectMake(0, kBottomToolbarHeight, viewSize.width, viewSize.height-2*kBottomToolbarHeight)];
    [centralButton setAutoresizesSubviews:YES];
    [centralButton setContentMode:UIViewContentModeScaleAspectFill];
    [centralButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [centralButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [centralButton setBackgroundImage:centralImage forState:UIControlStateNormal];
    [centralButton setAdjustsImageWhenDisabled:NO];
    [centralButton setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin];
    [centralButton addTarget:self action:@selector(handleSingleTap:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIToolbar *bottomToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, centralButton.frame.origin.y + centralButton.frame.size.height, centralButton.frame.size.width, kBottomToolbarHeight)];
    [bottomToolbar setBarStyle:UIBarStyleBlackTranslucent];
    
    UIButton *goToAudioFilesTableView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [goToAudioFilesTableView setTitle:NSLocalizedString(@"audiobook", nil) forState:UIControlStateNormal];
    [goToAudioFilesTableView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [goToAudioFilesTableView addTarget:self action:@selector(showAudiobookController) forControlEvents:UIControlEventTouchUpInside];
    [goToAudioFilesTableView setFrame:CGRectMake(0, 0, kBottomButtonWidth, kBottomButtonHeight)];
    
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithCustomView:goToAudioFilesTableView];
    
    [bottomToolbar setItems:[NSArray arrayWithObjects:spacer, btn, spacer, nil]];
    [spacer release], [btn release];
    
	[self.view addSubview:centralButton];
    [self.view addSubview:bottomToolbar];
    [centralButton release];
    [bottomToolbar release];
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
#ifdef DEBUGX
	NSLog(@"%s (%d)", __FUNCTION__, interfaceOrientation);
#endif

	if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) // See README
		return UIInterfaceOrientationIsPortrait(interfaceOrientation);
	else
		return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
#ifdef DEBUGX
	NSLog(@"%s %@ (%d)", __FUNCTION__, NSStringFromCGRect(self.view.bounds), toInterfaceOrientation);
#endif
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
#ifdef DEBUGX
	NSLog(@"%s %@ (%d)", __FUNCTION__, NSStringFromCGRect(self.view.bounds), interfaceOrientation);
#endif
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
#ifdef DEBUGX
	NSLog(@"%s %@ (%d to %d)", __FUNCTION__, NSStringFromCGRect(self.view.bounds), fromInterfaceOrientation, self.interfaceOrientation);
#endif
	//if (fromInterfaceOrientation == self.interfaceOrientation) return;
}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (void)dealloc
{
	[super dealloc];
}

#pragma mark audio book table view

- (void)showAudiobookController
{
    AudioFilesTableViewController *controller = [[AudioFilesTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

#pragma mark pdf reader opening

- (void)handleSingleTap:(UIButton *)sender
{
	NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)

	/*
    NSArray *pdfs = [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil];
    //здесь у тебя массив со всеми pdf файлами
    
	NSString *filePath = [pdfs lastObject]; assert(filePath != nil); // Path to last PDF file
    //здесь выбирается последний из них, можно поменять
    */
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"helloworld" ofType:@"pdf"];
    
	ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
		ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
		readerViewController.delegate = self; // Set the ReaderViewController delegate to self
        
        
		readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;

		[self presentModalViewController:readerViewController animated:YES];

		[readerViewController release]; // Release the ReaderViewController
	}
}

#pragma mark ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
	[self dismissModalViewControllerAnimated:YES];
}

@end
