//
//  BaseObject.m
//  ExampleCoreData
//
//  Created by Ferhat Ayaz on 30/1/2013.
//  Copyright (c) 2013 Ferhat Ayaz. All rights reserved.
//

#import "BaseObject.h"
#import "NSObject+DerivedProperties.h"

@implementation BaseObject

+ (void)initialize {
  [self registerDynamicDerivedProperties];
}

- (void)awakeFromInsert {
	[super awakeFromInsert];
  [self setupDynamicDerivedProperties];
  [self startObservingForDerivedProperties];
}

- (void)awakeFromFetch {
  [super awakeFromFetch];
  [self setupDynamicDerivedProperties];
  [self startObservingForDerivedProperties];
}

- (void)awakeFromUndo {
  [self setupDynamicDerivedProperties];
  [self startObservingForDerivedProperties];
}

- (void)willTurnIntoFault {
  [self stopObservingForDerivedProperties];
  [self clearDynamicDerivedProperties];
  [super willTurnIntoFault];
}

- (void)prepareForDeletion {
  [[[[self managedObjectContext] undoManager] prepareWithInvocationTarget: self] awakeFromUndo];
  [super prepareForDeletion];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  [self observeDerivedValueForKeyPath: keyPath ofObject: object change: change context: context];
}

@end
