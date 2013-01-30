//
//  Item.m
//  Example
//
//  Created by Ferhat Ayaz on 30/1/2013.
//  Copyright (c) 2013 Ferhat Ayaz. All rights reserved.
//

#import "Item.h"

@implementation Item

@synthesize quantity;
@synthesize unitPrice;
@synthesize title;

- (id)init {
  self = [super init];
  if (self) {
    self.quantity = [NSDecimalNumber zero];
    self.unitPrice = [NSDecimalNumber zero];
  }
  return self;
}

- (NSDecimalNumber *)totalPrice {
  return [quantity decimalNumberByMultiplyingBy: unitPrice];
}

+ (NSSet *)keyPathsForValuesAffectingTotalPrice {
  return [NSSet setWithObjects: @"quantity", @"unitPrice", nil];
}

- (void)dealloc {
  [quantity release];
  [unitPrice release];
  [title release];
  [super dealloc];
}

@end
