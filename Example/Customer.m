//
//  Customer.m
//  Example
//
//  Created by Ferhat Ayaz on 30/1/2013.
//  Copyright (c) 2013 Ferhat Ayaz. All rights reserved.
//

#import "Customer.h"
#import "Invoice.h"

@implementation Customer

@synthesize name;
@synthesize invoices;

- (id)init {
  self = [super init];
  if (self) {
    self.invoices = [NSArray array];
  }
  return self;
}

- (NSDecimalNumber *)soldItemCount {
  return [invoices valueForKeyPath: @"@sum.items.@sum.quantity"];
}

+ (NSSet *)keyPathsForValuesAffectingDerivedSoldItemCount {
  return [NSSet setWithObject: @"invoices.items.quantity"];
}

- (void)dealloc {
  [name release];
  [invoices release];
  [super dealloc];
}

@end
