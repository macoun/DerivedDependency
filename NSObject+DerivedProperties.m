//
//  NSObject+DerivedProperties.m
//  DerivedDependency
//
//  Created by Ferhat Ayaz on 17/1/2013.
//  Copyright (c) 2013 Ferhat Ayaz. All rights reserved.
//

#import "NSObject+DerivedProperties.h"
#import "INDerivedEntityDescription.h"
#import "INDerivedDependencyNode.h"
#import "INDerivedPropertyDefinition.h"
#import <objc/runtime.h>

static NSString *INUncalculatedValueMarker = @"";

@implementation NSObject (DerivedProperties)

- (void)registerObjects:(id)arrayOrSet forDerivedDependencyNodes:(NSArray *)nodes {
  for (INDerivedDependencyNode *node in nodes) {
    for (id item in arrayOrSet) {
      //DLog(@"REGISTER (%@) KEY (%@) [%@]", [item class], node.key, [item identifier]);
      [item addObserver: self forKeyPath: node.key options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context: node];
      id value = [item valueForKey: node.key];
      if (value != nil) {
        if ([value isKindOfClass: [NSSet class]] || [value isKindOfClass: [NSArray class]])
          [self registerObjects: value forDerivedDependencyNodes: node.children];
        else
          [self registerObjects: @[value] forDerivedDependencyNodes: node.children];
      }
    }
  }
}

- (void)unregisterObjects:(id)arrayOrSet forDerivedDependencyNodes:(NSArray *)nodes {
  for (INDerivedDependencyNode *node in nodes) {
    for (id item in arrayOrSet) {
      //DLog(@"UNREGISTER (%@) KEY (%@) [%@]", [item class], node.key, [item identifier]);
      [item removeObserver: self forKeyPath: node.key context: node];
      id value = [item valueForKey: node.key];
      if (value != nil) {
        if ([value isKindOfClass: [NSSet class]] || [value isKindOfClass: [NSArray class]])
          [self unregisterObjects: value forDerivedDependencyNodes: node.children];
        else
          [self unregisterObjects: @[value] forDerivedDependencyNodes: node.children];
      }
    }
  }
}

- (void)startObservingForDerivedProperties {
  INDerivedEntityDescription *entity = [INDerivedEntityDescription entityDescriptionForClass: [self class]];
  [self registerObjects: @[self] forDerivedDependencyNodes: entity.derivedDependencyNode.children];
}

- (void)stopObservingForDerivedProperties {
  @autoreleasepool {
    INDerivedEntityDescription *entity = [INDerivedEntityDescription entityDescriptionForClass: [self class]];
    [self unregisterObjects: @[self] forDerivedDependencyNodes: entity.derivedDependencyNode.children];
  }
}


- (void)invalidateDerivedPropertyDefinitionsForDependencyNode:(INDerivedDependencyNode *)node {
  for (INDerivedPropertyDefinition *property in node.propertyDefinitions) {
    [self willChangeValueForKey: property.name];
    if (property.updateSelector)
      objc_setAssociatedObject(self, property, INUncalculatedValueMarker, OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey: property.name];
  }
  
  for (INDerivedDependencyNode *childNode in node.children)
    [self invalidateDerivedPropertyDefinitionsForDependencyNode: childNode];
}


- (void)observeDerivedValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
  if ([(id)context isKindOfClass: [INDerivedDependencyNode class]]) {
    //DLog(@"%@ - %@", keyPath, change);
    INDerivedDependencyNode *node = (id)context;
    id newValue = [change objectForKey: NSKeyValueChangeNewKey];
    id oldValue = [change objectForKey: NSKeyValueChangeOldKey];
    if ([newValue isKindOfClass: [NSSet class]] || [newValue isKindOfClass: [NSArray class]] ||
        [oldValue isKindOfClass: [NSSet class]] || [oldValue isKindOfClass: [NSArray class]]) {
      
      NSSet *newObjects = [newValue isEqual: [NSNull null]] ? nil : newValue;
      NSSet *oldObjects = [oldValue isEqual: [NSNull null]] ? nil : oldValue;
      
      if ([newObjects isKindOfClass: [NSArray class]])
        newObjects = [NSSet setWithArray: (NSArray *)newObjects];
      if ([oldObjects isKindOfClass: [NSArray class]])
        oldObjects = [NSSet setWithArray: (NSArray *)oldObjects];
      
      NSSet *addedObjects = [newObjects objectsPassingTest: ^BOOL(id obj, BOOL *stop) {
        return ![oldObjects containsObject: obj];
      }];
      
      NSSet *removedObjects = [oldObjects objectsPassingTest: ^BOOL(id obj, BOOL *stop) {
        return ![newObjects containsObject: obj];
      }];
      
      if (addedObjects.count > 0) {
        [self registerObjects: addedObjects forDerivedDependencyNodes: node.children];
      }
      if (removedObjects.count > 0) {
        [self unregisterObjects: removedObjects forDerivedDependencyNodes: node.children];
      }
    }
    [self invalidateDerivedPropertyDefinitionsForDependencyNode: node];
  }
}


@end

@interface NSObject (DynamicDerivedPropertiesPrivate)
- (void)setValueForAllDerivedProperties:(id)value;
- (id)updateValueForDerivedProperty:(INDerivedPropertyDefinition *)property;
@end

static id get_derived(id self, SEL cmd) {
  NSString *propertyName = NSStringFromSelector(cmd);
  INDerivedEntityDescription *entity = [INDerivedEntityDescription entityDescriptionForClass: [self class]];
  INDerivedPropertyDefinition *property = [entity.derivedPropertyDefinitionsByName objectForKey: propertyName];
  
  id value = objc_getAssociatedObject(self, property);
  if (value != INUncalculatedValueMarker)
    return value;
  
  return [self updateValueForDerivedProperty: property];
}

@implementation NSObject (DynamicDerivedProperties)

+ (void)registerDynamicDerivedProperties {
  INDerivedEntityDescription *entity = [INDerivedEntityDescription entityDescriptionForClass: self];
  for (INDerivedPropertyDefinition *property in [entity.derivedPropertyDefinitionsByName allValues]) {
    if (property.updateSelector)
      class_addMethod([self class], NSSelectorFromString(property.name), (IMP)get_derived, "@@:");
  }
}

- (void)setValueForAllDerivedProperties:(id)value {
  INDerivedEntityDescription *entity = [INDerivedEntityDescription entityDescriptionForClass: [self class]];
  for (INDerivedPropertyDefinition *property in [entity.derivedPropertyDefinitionsByName allValues]) {
    if (property.updateSelector)
      objc_setAssociatedObject(self, property, value, OBJC_ASSOCIATION_RETAIN);
  }
}

- (void)setupDynamicDerivedProperties {
  [self setValueForAllDerivedProperties: INUncalculatedValueMarker];
}

- (void)clearDynamicDerivedProperties {
  [self setValueForAllDerivedProperties: nil];
}

- (id)updateValueForDerivedProperty:(INDerivedPropertyDefinition *)property {
  id value = [self performSelector: property.updateSelector];
  objc_setAssociatedObject(self, property, value, OBJC_ASSOCIATION_RETAIN);
  return value;
}

@end
