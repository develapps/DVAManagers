//
//  NSArray+FP.h
//  GastroGuia
//
//  Created by Rafa Barberá on 20/04/15.
//  Copyright (c) 2015 develapps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (FP)

- (NSArray *)dva_map:(id(^)(id item))mapping;
- (NSArray *)dva_filterNullValues ;
@end
