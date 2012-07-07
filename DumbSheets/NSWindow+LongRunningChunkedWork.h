//
//  NSWindow+LongRunningChunkedWork.h
//  DumbSheets
//
//  Created by Ben Cox on 7/7/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//

#import <AppKit/AppKit.h>

#pragma mark LongRunningChunkedWork Protocol

@protocol LongRunningChunkedWork <NSObject>

@required
// Subclasses should implement this method to do a chunk of their work,
// returning YES to indicate that the work is finished, or NO to indicate
// that is it not finished.
//
// You should cut your work up into small enough chunks that a work chunk
// should complete in somewhere between 1-20ms, to give the user sufficiently
// fine-grained feedback about the progress of your long-running operation.
- (BOOL) processChunk;

@optional

// If you implement this method, and it returns a value between 0 and 100,
// the progress indicator will be updated after each chunk to indicate the
// estimated completion percentage.
// If you don't implement the method, or it returns a value outside the
// 0-100 range, the progress indicator will indicate indeterminate status.
- (double) percentComplete;

// If you implement this method and it returns a non-nil non-empty string,
// the progress sheet may include an indication of this status. (It may not.)
- (NSString*) status;

// If you implement this method and it returns a non-negative value,
// the progress sheet may include an indication of the time remaining
// until completion. (It may not.) If you return a negative value (or
// don't implement the method), the progress sheet will not indicate
// the time remaining.
- (double) timeRemaining;

@end

#pragma mark - LongRunningChunkedWork NSWindow Category

@interface NSWindow (LongRunningChunkedWork)

- (void) processLongRunningWork:(id<LongRunningChunkedWork>)longRunningWork
                        onQueue:(dispatch_queue_t)queue
                      withSheet:(NSWindow*)progressSheet
              progressIndicator:(NSProgressIndicator*)progressIndicator
                    statusLabel:(NSTextField*)statusLabel
             timeRemainingLabel:(NSTextField*)timeRemainingLabel;

@end
