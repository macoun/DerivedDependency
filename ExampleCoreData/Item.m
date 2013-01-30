//
//  Item.m
//  ExampleCoreData
//
//  Created by Ferhat Ayaz on 30/1/2013.
//  Copyright (c) 2013 Ferhat Ayaz. All rights reserved.
//

#import "Item.h"

@implementation Item

@dynamic quantity;
@dynamic unitPrice;
@dynamic totalPrice;

- (NSDecimalNumber *)updateDerivedTotalPrice {
  return [self.quantity decimalNumberByMultiplyingBy: self.unitPrice];
}

+ (NSSet *)keyPathsForValuesAffectingDerivedTotalPrice {
  return [NSSet setWithObjects: @"quantity", @"unitPrice", nil];
}

@end
