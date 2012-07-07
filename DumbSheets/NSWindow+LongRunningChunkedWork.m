//
//  NSWindow+LongRunningWork.m
//  DumbSheets
//
//  Created by Ben Cox on 7/7/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//

#import "NSWindow+LongRunningChunkedWork.h"

#pragma mark Implementation

@implementation NSWindow (LongRunningChunkedWork)

- (void) processLongRunningWork:(id<LongRunningChunkedWork>)longRunningWork
                        onQueue:(dispatch_queue_t)queue
                      withSheet:(NSWindow*)progressSheet
              progressIndicator:(NSProgressIndicator*)progressIndicator
                    statusLabel:(NSTextField *)statusLabel
             timeRemainingLabel:(NSTextField *)timeRemainingLabel
{
  // Set up the progress indicator. It may be set up like this in the nib,
  // but it might have values left over from a previous use.
  progressIndicator.minValue = 0.0;
  progressIndicator.maxValue = 100.0;
  progressIndicator.doubleValue = 0.0;
  [progressIndicator setIndeterminate:YES];
  [statusLabel setHidden:YES];
  [timeRemainingLabel setHidden:YES];
  
  // Put up the sheet.
  [NSApp beginSheet:progressSheet modalForWindow:self modalDelegate:self didEndSelector:NULL contextInfo:NULL];
  
  // Arrange for the work to be done on the mWorkQueue, which is very likely on another thread.
  __block BOOL blockDone = NO; // Used to signal us when the work is finished.
  dispatch_async(queue, ^{
    // Repeatedly run the work chunks in a loop until they say we're finished.
    BOOL workDone = NO; // We only want to update blockDone on the main thread; use this variable locally.
    while (!workDone) {
      // Do a piece of work.
      workDone = [longRunningWork processChunk];
      // Get the status of the work.
      double percentComplete = -1.0;
      NSString* status = nil;
      double timeRemaining = -1.0;
      if ([longRunningWork respondsToSelector:@selector(percentComplete)]) {
        percentComplete = [longRunningWork percentComplete];
      }
      if ([longRunningWork respondsToSelector:@selector(status)]) {
        status = [longRunningWork status];
      }
      if ([longRunningWork respondsToSelector:@selector(timeRemaining)]) {
        timeRemaining = [longRunningWork timeRemaining];
      }
      // Back on the main thread, update the progress indicator and the blockDone indicator.
      // This will cause the main run loop to return from -runMode:beforeDate:.
      dispatch_async(dispatch_get_main_queue(), ^{
        if (percentComplete < 0.0) {
          [progressIndicator setIndeterminate:YES];
        } else {
          [progressIndicator setIndeterminate:NO];
          progressIndicator.doubleValue = percentComplete;
        }
        if ([status length] == 0) {
          [statusLabel setHidden:YES];
        } else {
          [statusLabel setStringValue:status];
          [statusLabel setHidden:NO];
        }
        if (timeRemaining < 0.0) {
          [timeRemainingLabel setHidden:YES];
        } else {
          double remainder = ceil(timeRemaining);
          int hours = remainder / 3600.0;
          remainder -= hours * 3600.0;
          int minutes = remainder / 60.0;
          remainder -= minutes * 60.0;
          int secs = remainder;
          NSString* timeString = (hours == 0) ? [NSString stringWithFormat:@"%d:%02d", minutes, secs] :
                                                [NSString stringWithFormat:@"%d:%02d:%02d", hours, minutes, secs];
          [timeRemainingLabel setStringValue:timeString];
          [timeRemainingLabel setHidden:NO];
        }
        blockDone = workDone;
      });
    }
  });
  
  // Now we've put up the sheet and arranged for the work to be done on the other thread.
  // We don't want to return from this method until the work is done, but we want to turn
  // the main run loop so that the progress indicator gets updated and we don't see the
  // beach ball. So just keep turning the main run loop in NSModalPanelRunLoopMode until
  // we get the signal that we're done (via blockDone).
  NSRunLoop* mainRunLoop = [NSRunLoop mainRunLoop];
  while (!blockDone) {
    // If you get the beach ball while this loop runs, try using a time interval
    // like [NSDate dateWithTimeIntervalSinceNow:0.1] instead of [NSDate distantFuture].
    // You shouldn't see it, though, because events ought to cause this to return
    // frequently enough that this returns several times per second anyway.
    // (Especially if your work chunks are sufficiently small-grained.)
    [mainRunLoop runMode:NSModalPanelRunLoopMode beforeDate:[NSDate distantFuture]];
  }
  
  // The work is all done now. End the sheet, remove it from the screen, and return.
  [NSApp endSheet:progressSheet];
  [progressSheet orderOut:self];
}

@end
