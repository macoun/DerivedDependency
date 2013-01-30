//
//  Invoice.m
//  ExampleCached
//
//  Created by Ferhat Ayaz on 30/1/2013.
//  Copyright (c) 2013 Ferhat Ayaz. All rights reserved.
//

#import "Invoice.h"

@implementation Invoice

@synthesize nr;
@synthesize items;
@dynamic totalPrice;

- (id)init {
  self = [super init];
  if (self) {
    self.items = [NSArray array];
  }
  return self;
}

- (NSDecimalNumber *)updateDerivedTotalPrice {
  return [items valueForKeyPath: @"@sum.totalPrice"];
}

+ (NSSet *)keyPathsForValuesAffectingDerivedTotalPrice {
  return [NSSet setWithObject: @"items.totalPrice"];
}

- (void)dealloc {
  [nr release];
  [items release];
  [super dealloc];
}

@end
