//
//  Invoice.h
//  ExampleCached
//
//  Created by Ferhat Ayaz on 30/1/2013.
//  Copyright (c) 2013 Ferhat Ayaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface Invoice : BaseObject

@property (copy) NSString *nr;
@property (strong) NSArray *items;
@property (nonatomic, readonly) NSDecimalNumber *totalPrice;

@end
