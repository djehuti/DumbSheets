//
//  DumbSheetsAppDelegate.h
//  DumbSheets
//
//  Created by Ben Cox on 7/7/12.
//  Copyright 2012 Apple Inc. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DumbSheetsAppDelegate : NSObject <NSApplicationDelegate> {
  NSWindow *window;
}

@property (assign) IBOutlet NSWindow *window;

@end
