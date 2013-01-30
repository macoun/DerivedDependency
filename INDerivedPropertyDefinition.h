//
//  INDerivedPropertyDefinition.h
//  DerivedDependency
//
//  Created by Ferhat Ayaz on 17/1/2013.
//  Copyright (c) 2013 Ferhat Ayaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface INDerivedPropertyDefinition : NSObject {
  NSString *mName;
  SEL mUpdateSelector;
}

@property (copy) NSString *name;
@property (assign) SEL updateSelector;
@end
