//
//  BaseObject.m
//  Example
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

- (id)init {
  self = [super init];
  if (self) {
    [self startObservingForDerivedProperties];
  }
  return self;
}

- (void)dealloc {
  [self stopObservingForDerivedProperties];
  [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  [self observeDerivedValueForKeyPath: keyPath ofObject: object change: change context: context];
}

@end
