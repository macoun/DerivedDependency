//
//  INDerivedEntityDescription.m
//  DerivedDependency
//
//  Created by Ferhat Ayaz on 17/1/2013.
//  Copyright (c) 2013 Ferhat Ayaz. All rights reserved.
//

#import "INDerivedEntityDescription.h"
#import <objc/runtime.h>
#import "INDerivedPropertyDefinition.h"
#import "INDerivedDependencyNode.h"


@interface INDerivedEntityDescription ()

@property (retain) NSDictionary *derivedPropertyDefinitionsByName;
@property (retain) INDerivedDependencyNode *derivedDependencyNode;

- (void)setupDerivedPropertyDefinitionsWithClass:(Class)aClass;
- (void)setupDerivedDependencyNodesByKeyPathWithClass:(Class)aClass;
- (SEL)selectorForKeyPathsForProperty:(NSString *)propertyName;
- (SEL)selectorForUpdateForProperty:(NSString *)propertyName;
@end

@implementation INDerivedEntityDescription

static NSMutableDictionary *entityDescriptionsByClassName = nil;

@synthesize derivedPropertyDefinitionsByName = mDerivedPropertyDefinitionsByName;
@synthesize derivedDependencyNode = mDerivedDependencyNode;

+ (void)initialize {
  if ([INDerivedEntityDescription class] == self)
    entityDescriptionsByClassName = [[NSMutableDictionary alloc] init];
}

- (id)initWithClass:(Class)aClass {
  self = [super init];
  if (self != nil) {
    [self setupDerivedPropertyDefinitionsWithClass: aClass];
    [self setupDerivedDependencyNodesByKeyPathWithClass: aClass];
  }
  return self;
}

+ (INDerivedEntityDescription *)entityDescriptionForClass:(Class)aClass {
  NSString *className = NSStringFromClass(aClass);
  INDerivedEntityDescription *result = [entityDescriptionsByClassName objectForKey: className];
  if (result != nil)
    return result;
  
  result = [[self alloc] initWithClass: aClass];
  [entityDescriptionsByClassName setObject: result forKey: className];
  return [result autorelease];
}

- (void)setupDerivedDependencyNodesByKeyPathWithClass:(Class)aClass {
  INDerivedDependencyNode *rootNode = [INDerivedDependencyNode dependencyNodeWithKey: nil];
  for (NSString *propertyName in self.derivedPropertyDefinitionsByName) {
    INDerivedPropertyDefinition *propertyDef =
      [self.derivedPropertyDefinitionsByName objectForKey: propertyName];
    SEL keyPathsSel = [self selectorForKeyPathsForProperty: propertyName];
    NSSet *keyPaths = [aClass performSelector: keyPathsSel];
    for (NSString *keyPath in keyPaths) {
      INDerivedDependencyNode *currentNode = rootNode;
      NSArray *keyPathComponents = [keyPath componentsSeparatedByString: @"."];
      for (NSString *keyPathComponent in keyPathComponents) {
        INDerivedDependencyNode *node = [currentNode childForKey: keyPathComponent];
        if (node == nil) {
          node = [INDerivedDependencyNode dependencyNodeWithKey: keyPathComponent];
          [currentNode addChild: node];
        }
        currentNode = node;
      }
      [currentNode addPropertyDefinition: propertyDef];
    }
  }
  self.derivedDependencyNode = rootNode;
}

- (void)addPropertyDefinitionsToDictionary:(NSMutableDictionary *)propertyDict forClass:(Class)aClass {
  unsigned int propertyCount = 0;
  objc_property_t *properties = class_copyPropertyList(aClass, &propertyCount);
  unsigned int methodCount = 0;
  Method *methods = class_copyMethodList(aClass, &methodCount);
  for (int i = 0; i < propertyCount; i++) {
    NSString *propertyName = [NSString stringWithFormat: @"%s", property_getName(properties[i])];
    
    SEL keyPathsSelector = [self selectorForKeyPathsForProperty: propertyName];
    Method keyPathsMethod = class_getClassMethod(aClass, keyPathsSelector);
    if (keyPathsMethod == NULL)
      continue;

    SEL updateSelector = [self selectorForUpdateForProperty: propertyName];
    // Finding manually. Using class_getInstanceMethod will cause a infinit loop
    Method updateMethod = NULL;
    for (int i = 0; i < methodCount; i++) {
      if (method_getName(methods[i]) == updateSelector)
        updateMethod = methods[i];
    }
    
    INDerivedPropertyDefinition *propDef = [[INDerivedPropertyDefinition alloc] init];
    propDef.name = propertyName;
    if (updateMethod != NULL)
      propDef.updateSelector = updateSelector;
    [propertyDict setObject: propDef forKey: propertyName];
    [propDef release];
  }
}

- (void)setupDerivedPropertyDefinitionsWithClass:(Class)aClass {
  NSMutableDictionary *propertyDict = [NSMutableDictionary dictionary];
  for (Class currentClass = aClass; currentClass != NULL; currentClass = [currentClass superclass])
    [self addPropertyDefinitionsToDictionary: propertyDict forClass: currentClass];
  self.derivedPropertyDefinitionsByName = propertyDict;
}

- (NSString *)capitalizedString:(NSString *)string {
  return [string stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                         withString:[[string substringToIndex:1] uppercaseString]];
}

- (SEL)selectorForUpdateForProperty:(NSString *)propertyName {
  
  NSString *selectorName = [NSString stringWithFormat: @"updateDerived%@", [self capitalizedString: propertyName]];
  return NSSelectorFromString(selectorName);
}

- (SEL)selectorForKeyPathsForProperty:(NSString *)propertyName {
  NSString *selectorName = [NSString stringWithFormat: @"keyPathsForValuesAffectingDerived%@",
                            [self capitalizedString: propertyName]];
  return NSSelectorFromString(selectorName);
}

@end
