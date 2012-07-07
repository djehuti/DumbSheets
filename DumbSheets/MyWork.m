//
//  MyWork.m
//  DumbSheets
//
//  Created by Ben Cox on 7/7/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//
//  This is an example class adopting the LongRunningChunkedWork protocol.
//  It performs a chunk of "work" in -processChunk, and keeps state in ivars.
//

#import "MyWork.h"

#pragma mark Private Interface

@interface MyWork ()
{
  // Our internal work state.
  int mChunksDone;
}
@end

#pragma mark - Implementation

@implementation MyWork

- (id)init
{
  if ((self = [super init])) {
    mChunksDone = 0;
  }
  return self;
}

// Do a chunk of work.
- (BOOL) processChunk
{
  usleep(5000); // 5ms
  ++mChunksDone;
  return mChunksDone < 1000 ? NO : YES; 
}

- (double) percentComplete
{
  double percentComplete = -1.0; // A negative value indicates indeterminate status.
  if (mChunksDone < 350 || mChunksDone >= 500) {
    percentComplete = mChunksDone / 10.0;
  }
  return percentComplete;
}

- (NSString*) status
{
  NSString* status = nil;
  if (mChunksDone < 100) {
    status = @"Starting up...";
  } else if (mChunksDone < 350) {
    status = @"First phase...";
  } else if (mChunksDone < 400) {
    status = nil; // Nil or empty status hides the status field.
  } else if (mChunksDone < 500) {
    status = @"Indeterminate phase...";
  } else if (mChunksDone < 800) {
    status = @"Don't you wish I was done?";
  } else {
    status = @"Finishing up...";
  }
  return status;
}

- (double) timeRemaining
{
  double timeRemaining = -1.0; // A negative value hides the time-remaining field.
  if (mChunksDone < 350 || mChunksDone >= 500) {
    // For us, this is easy to calculate since each chunk takes 5ms.
    timeRemaining = (1000 - mChunksDone) * 0.005;
  }
  return timeRemaining;
}

@end
