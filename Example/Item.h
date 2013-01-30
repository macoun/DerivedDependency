//
//  Item.h
//  Example
//
//  Created by Ferhat Ayaz on 30/1/2013.
//  Copyright (c) 2013 Ferhat Ayaz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseObject.h"

@interface Item : BaseObject

@property (copy) NSString *title;
@property (strong) NSDecimalNumber *quantity;
@property (strong) NSDecimalNumber *unitPrice;
@property (nonatomic, readonly) NSDecimalNumber *totalPrice;

@end
