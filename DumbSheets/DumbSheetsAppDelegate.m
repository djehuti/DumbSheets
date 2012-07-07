//
//  DumbSheetsAppDelegate.m
//  DumbSheets
//
//  Created by Ben Cox on 7/7/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//

#import "DumbSheetsAppDelegate.h"
#import "NSWindow+LongRunningChunkedWork.h"
#import "MyWork.h"


#pragma mark Private Interface

@interface DumbSheetsAppDelegate ()
{
  NSWindow* mWindow;
  NSWindow* mProgressSheet;
  NSProgressIndicator* mProgressIndicator;
  NSTextField* mStatusLabel;
  NSTextField* mTimeRemainingLabel;
  dispatch_queue_t mWorkQueue;
}

@end

#pragma mark - Implementation

@implementation DumbSheetsAppDelegate

#pragma mark Properties

@synthesize window = mWindow;
@synthesize progressSheet = mProgressSheet;
@synthesize progressIndicator = mProgressIndicator;
@synthesize statusLabel = mStatusLabel;
@synthesize timeRemainingLabel = mTimeRemainingLabel;

#pragma mark Methods

- (void) applicationDidFinishLaunching:(NSNotification*)aNotification
{
  mWorkQueue = dispatch_queue_create("com.djehuti.DumbSheets.WorkQueue", DISPATCH_QUEUE_CONCURRENT);
}

- (BOOL) applicationShouldTerminateAfterLastWindowClosed:(NSApplication*)sender
{
  return YES;
}

- (void) dealloc
{
  dispatch_release(mWorkQueue);
  mWorkQueue = NULL;
  [super dealloc];
}

#pragma mark Actions

- (IBAction) go:(id)sender
{
  MyWork* myWork = [[MyWork alloc] init];
  [mWindow processLongRunningWork:myWork
                          onQueue:mWorkQueue
                        withSheet:mProgressSheet
                progressIndicator:mProgressIndicator
                      statusLabel:mStatusLabel
               timeRemainingLabel:mTimeRemainingLabel];
}

@end
