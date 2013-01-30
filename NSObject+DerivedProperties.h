//
//  NSObject+DerivedProperties.h
//  DerivedDependency
//
//  Created by Ferhat Ayaz on 17/1/2013.
//  Copyright (c) 2013 Ferhat Ayaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (DerivedProperties)

- (void)startObservingForDerivedProperties;
- (void)stopObservingForDerivedProperties;

- (void)observeDerivedValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;
@end


@interface NSObject (DynamicDerivedProperties)
- (void)setupDynamicDerivedProperties;
- (void)clearDynamicDerivedProperties;
+ (void)registerDynamicDerivedProperties;
@end
