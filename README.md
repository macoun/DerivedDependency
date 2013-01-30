Derived Dependency 
=================

## Intro

Adds dependency key paths for to-many relationships. 

As you know Apple's support for dependency paths in KVO does not include to-many relationships. The following example for calculating the total price of an invoice will not work out of the box.

	- (NSDecimalNumber *)totalPrice {
		return [items valueForKeyPath: @"@sum.totalPrice"];
	}
	
	+ (NSSet *)keyPathsForValuesAffectingTotalPrice {
    	return [NSSet setWithObject: @"items.totalPrice"];
	}

This will not work because `items` is a to-many relation. Adding the classes beginning with `INDerived*` from this project will add the missing support for to-many relationships.

## How to use

The changes you need to make in your code to suport dependencies for to-many relations are minimal. This library does __not__ override or extend Apple's KVO. It just __uses__ the wonderful world of KVO. The derived property __must__ be a declared property.

	@property (nonatomic, readonly) NSDecimalNumber *totalPrice;
	
The library recognizes class methods starting with `keyPathsForValuesAffectingDerived*` and registers observers to be notified about the changes.

	- (NSDecimalNumber *)totalPrice {
		return [items valueForKeyPath: @"@sum.totalPrice"];
	}
	
	+ (NSSet *)keyPathsForValuesAffectingDerivedTotalPrice {
    	return [NSSet setWithObject: @"items.totalPrice"];
	}

### Calculated Properties

Most of the time you want to cache values to avoid unnecessary recalculations. It is simply done by appending `updateDerived*` to the getter method you want to cache its value.

	@dynamic totalPrice;
	
	- (NSDecimalNumber *)updateDerivedTotalPrice {
		return [items valueForKeyPath: @"@sum.totalPrice"];
	}
	
Here you don't need the method `totalPrice` anymore. It will be added dynamically to the class.

## Setup

There are 3 steps to setup the environment for derived properties.

1. Register the __Class__.
2. Start/Stop observing for each __Instance__.
3. Forward `observeValueForKeyPath:ofObject:change:context:`

The skeleton for a class that supports derived property dependencies could look like:

	@implementation BaseObject

	+ (void)initialize {
	  [self registerDynamicDerivedProperties];
	}

	- (id)init {
	  self = [super init];
	  if (self) {
	    [self startObservingForDerivedProperties];
	  }
	  return self;
	}
	
	- (void)dealloc {
	  [self stopObservingForDerivedProperties];
	  [super dealloc];
	}
	
	- (void)observeValueForKeyPath:(NSString *)keyPath 
		ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	  [self observeDerivedValueForKeyPath: keyPath ofObject: object 
	  	change: change context: context];
	}
	
	@end



Caching calcuated properties is optional. If you want to use it you must call `setupDynamicDerivedProperties` and `clearDynamicDerivedProperties`.

	- (id)init {
	  self = [super init];
	  if (self) {
	    [self setupDynamicDerivedProperties];
	    [self startObservingForDerivedProperties];
	  }
	  return self;
	}
	
	- (void)dealloc {
	  [self stopObservingForDerivedProperties];
	  [self clearDynamicDerivedProperties];
	  [super dealloc];
	}

## Bonus - Core Data

It works also with `NSManagedObject` instances. The _ExampleCoreData_ project covers what you need to do when you work with CoreData.

## License
MIT-License
