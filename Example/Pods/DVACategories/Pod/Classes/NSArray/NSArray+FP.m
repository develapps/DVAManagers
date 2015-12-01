//
//  NSArray+FP.m
//  GastroGuia
//
//  Created by Rafa Barberá on 20/04/15.
//  Copyright (c) 2015 develapps. All rights reserved.
//

#import "NSArray+FP.h"

@implementation NSArray (FP)

- (NSArray *)dva_map:(id(^)(id item))mapping {
    NSMutableArray *mappedArray = [NSMutableArray new];
    for (id oldItem in self) {
        if ([oldItem isKindOfClass:[NSNull class]]) {
            continue;
        }
        id newItem = mapping(oldItem);
        if (newItem) {
            [mappedArray addObject:newItem];
        }
    }
    return [mappedArray copy];
}


- (NSArray *)dva_filterNullValues {
    NSPredicate *nilPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        return ![evaluatedObject isKindOfClass:[NSNull class]];
    }];
    return [self filteredArrayUsingPredicate:nilPredicate];
}


@end
