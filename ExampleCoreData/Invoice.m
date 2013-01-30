//
//  Invoice.m
//  ExampleCoreData
//
//  Created by Ferhat Ayaz on 30/1/2013.
//  Copyright (c) 2013 Ferhat Ayaz. All rights reserved.
//

#import "Invoice.h"

@implementation Invoice

@dynamic totalPrice;

- (NSDecimalNumber *)updateDerivedTotalPrice {
  return [self valueForKeyPath: @"items.@sum.totalPrice"];
}

+ (NSSet *)keyPathsForValuesAffectingDerivedTotalPrice {
  return [NSSet setWithObject: @"items.totalPrice"];
}

@end
