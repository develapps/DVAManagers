//
//  NSString+MyBae.h
//  MyBae
//
//  Created by Pablo Romeu on 29/7/15.
//  Copyright (c) 2015 Mybæ. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (DVAAttributedString)
-(NSAttributedString*)dva_attributedStringWithFont:(UIFont*)font;

+(NSAttributedString*)dva_attributedStringWithFont:(UIFont*)size
                                         andImages:(NSArray*)imagesNames
                                        withFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(3,4);
+(NSAttributedString*)dva_attributedStringWithFont:(UIFont *)font
                                         andFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(2,3);
-(NSAttributedString*)dva_attributedStringWithFont:(UIFont *)font andColor:(UIColor*)color;
@end
