//
//  INDerivedDependencyNode.h
//  DerivedDependency
//
//  Created by Ferhat Ayaz on 17/1/2013.
//  Copyright (c) 2013 Ferhat Ayaz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class INDerivedPropertyDefinition;

@interface INDerivedDependencyNode : NSObject {
@private
  NSString *mKey;
  NSMutableArray *mChildren;
  NSMutableArray *mPropertyDefinitions;
}

@property (copy) NSString *key;
@property (retain) NSArray *children;
@property (retain) NSArray *propertyDefinitions;

- (id)initWithKey:(NSString *)aKey;
+ (id)dependencyNodeWithKey:(NSString *)key;

- (void)addChild:(INDerivedDependencyNode *)child;
- (INDerivedDependencyNode *)childForKey:(NSString *)keyPath;
- (void)addPropertyDefinition:(INDerivedPropertyDefinition *)propDef;

@end
