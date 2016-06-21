//
//  Run+CoreDataProperties.h
//  Runner
//
//  Created by liuwq on 16/6/2.
//  Copyright © 2016年 liuwq. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Run.h"
#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@interface Run (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *distance;
@property (nullable, nonatomic, retain) NSNumber *duration;
@property (nullable, nonatomic, retain) NSDate *timestamp;
@property (nullable, nonatomic, retain) NSSet<Location*> *locations;

@end

@interface Run (CoreDataGeneratedAccessors)

- (void)addLocationsObject:(NSManagedObject *)value;
- (void)removeLocationsObject:(NSManagedObject *)value;
- (void)addLocations:(NSSet<NSManagedObject *> *)values;
- (void)removeLocations:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
