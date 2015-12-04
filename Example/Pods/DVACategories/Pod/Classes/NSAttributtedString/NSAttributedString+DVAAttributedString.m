//
//  NSAttributedString+DVAAttributedString.m
//  MyBae
//
//  Created by Pablo Romeu on 29/7/15.
//  Copyright (c) 2015 Mybæ. All rights reserved.
//

#import "NSAttributedString+DVAAttributedString.h"

@implementation NSAttributedString (DVAAttributedString)
-(NSAttributedString*)dva_attributedStringWithFont:(UIFont *)font{
    NSMutableAttributedString *att = [self mutableCopy];
    [att addAttribute:NSFontAttributeName
                value:font range:NSMakeRange(0, [self length])];
     return att;
}
@end
