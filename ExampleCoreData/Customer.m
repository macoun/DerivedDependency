//
//  Customer.m
//  ExampleCoreData
//
//  Created by Ferhat Ayaz on 30/1/2013.
//  Copyright (c) 2013 Ferhat Ayaz. All rights reserved.
//

#import "Customer.h"

@implementation Customer

@dynamic soldItemCount;

- (NSDecimalNumber *)updateDerivedSoldItemCount {
  return [self valueForKeyPath: @"invoices.@sum.items.@sum.quantity"];
}

+ (NSSet *)keyPathsForValuesAffectingDerivedSoldItemCount {
  return [NSSet setWithObject: @"invoices.items.quantity"];
}

@end
