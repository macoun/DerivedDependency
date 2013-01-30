//
//  INDerivedDependencyNode.m
//  DerivedDependency
//
//  Created by Ferhat Ayaz on 17/1/2013.
//  Copyright (c) 2013 Ferhat Ayaz. All rights reserved.
//

#import "INDerivedDependencyNode.h"

@implementation INDerivedDependencyNode

@synthesize key = mKey;
@synthesize children = mChildren;
@synthesize propertyDefinitions = mPropertyDefinitions;

- (id)initWithKey:(NSString *)aKey {
  self = [super init];
  if (self != nil) {
    self.key = aKey;
    mChildren = [[NSMutableArray alloc] init];
    mPropertyDefinitions = [[NSMutableArray alloc] init];
  }
  return self;
}

+ (id)dependencyNodeWithKey:(NSString *)aKey {
  return [[[[self class] alloc] initWithKey: aKey] autorelease];
}

- (void)addChild:(INDerivedDependencyNode *)child {
  [mChildren addObject: child];
}

- (INDerivedDependencyNode *)childForKey:(NSString *)keyPath {
  for (INDerivedDependencyNode *node in mChildren)
    if ([node.key isEqualToString: keyPath])
      return node;
  return nil;
}

- (void)addPropertyDefinition:(INDerivedPropertyDefinition *)propDef {
  [mPropertyDefinitions addObject: propDef];
}

- (void)dealloc {
  [mChildren release];
  [mPropertyDefinitions release];
  [super dealloc];
}
@end
