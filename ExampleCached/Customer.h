//
//  Customer.h
//  ExampleCached
//
//  Created by Ferhat Ayaz on 30/1/2013.
//  Copyright (c) 2013 Ferhat Ayaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface Customer : BaseObject

@property (copy) NSString *name;
@property (strong) NSArray *invoices;
@property (nonatomic, readonly) NSDecimalNumber *soldItemCount;

@end
