//
//  NSString+Localized.m
//  MyBae
//
//  Created by Pablo Romeu on 29/7/15.
//  Copyright (c) 2015 Mybæ. All rights reserved.
//

#import "NSString+DVALocalized.h"

@implementation NSString (DVALocalized)
+(NSString*)dva_localizedString:(NSString*)key{
    return NSLocalizedString(key, key);
}
-(NSString*)dva_localizedString{
    return [NSString dva_localizedString:self];
}

-(NSString*)dva_localizedStringForTable:(NSString*)tableName{
    return [NSString dva_localizedString:self forTable:tableName];
}

+(NSString*)dva_localizedString:(NSString*)key forTable:(NSString*)tableName{
    return NSLocalizedStringFromTable(key, tableName, key);
}

-(NSString*)dva_localizedStringForTable:(NSString*)tableName inBundle:(NSBundle*)bundle{
    return [NSString dva_localizedString:self forTable:tableName inBundle:bundle];
}

+(NSString*)dva_localizedString:(NSString*)key forTable:(NSString*)tableName inBundle:(NSBundle*)bundle{
    return NSLocalizedStringFromTableInBundle(key, tableName, bundle, key);
}


@end
