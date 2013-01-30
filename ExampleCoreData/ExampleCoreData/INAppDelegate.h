//
//  INAppDelegate.h
//  ExampleCoreData
//
//  Created by Ferhat Ayaz on 30/1/2013.
//  Copyright (c) 2013 Ferhat Ayaz. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface INAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction)saveAction:(id)sender;

@end
