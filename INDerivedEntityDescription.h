//
//  INDerivedEntityDescription.h
//  DerivedDependency
//
//  Created by Ferhat Ayaz on 17/1/2013.
//  Copyright (c) 2013 Ferhat Ayaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class INDerivedDependencyNode;

@interface INDerivedEntityDescription : NSObject {
  NSDictionary *mDerivedPropertyDefinitionsByName;
  INDerivedDependencyNode *mDerivedDependencyNode;
}

@property (retain, readonly) NSDictionary *derivedPropertyDefinitionsByName;
@property (retain, readonly) INDerivedDependencyNode *derivedDependencyNode;

- (id)initWithClass:(Class)aClass;
+ (INDerivedEntityDescription *)entityDescriptionForClass:(Class)aClass;

@end
