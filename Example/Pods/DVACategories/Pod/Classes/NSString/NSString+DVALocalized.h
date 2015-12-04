//
//  NSString+Localized.h
//  MyBae
//
//  Created by Pablo Romeu on 29/7/15.
//  Copyright (c) 2015 Mybæ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DVALocalized)
-(NSString*)dva_localizedString;
+(NSString*)dva_localizedString:(NSString*)key;

-(NSString*)dva_localizedStringForTable:(NSString*)tableName;
+(NSString*)dva_localizedString:(NSString*)key forTable:(NSString*)tableName;

-(NSString*)dva_localizedStringForTable:(NSString*)tableName inBundle:(NSBundle*)bundle;
+(NSString*)dva_localizedString:(NSString*)key forTable:(NSString*)tableName inBundle:(NSBundle*)bundle;
@end
