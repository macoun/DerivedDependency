//
//  Invoice.h
//  ExampleCoreData
//
//  Created by Ferhat Ayaz on 30/1/2013.
//  Copyright (c) 2013 Ferhat Ayaz. All rights reserved.
//

#import "BaseObject.h"

@interface Invoice : BaseObject

@property (nonatomic, readonly) NSDecimalNumber *totalPrice;

@end
