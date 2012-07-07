//
//  DumbSheetsAppDelegate.h
//  DumbSheets
//
//  Created by Ben Cox on 7/7/12.
//  Copyright 2012 Ben Cox. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface DumbSheetsAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow* window;
@property (assign) IBOutlet NSWindow* progressSheet;
@property (assign) IBOutlet NSProgressIndicator* progressIndicator;
@property (assign) IBOutlet NSTextField* statusLabel;
@property (assign) IBOutlet NSTextField* timeRemainingLabel;

- (IBAction) go:(id)sender;

@end
