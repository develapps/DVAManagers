//
//  NSAttributedString+DVAImageAttachment.h
//  MyBae
//
//  Created by Pablo Romeu on 29/7/15.
//  Copyright (c) 2015 Mybæ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (DVAImageAttachment)

+(NSString*)dva_attachmentStringLocation;

// Use ü symbol as substitute
-(NSAttributedString*)dva_stringWithImage:(UIImage*)image;
-(NSAttributedString*)dva_stringWithImage:(UIImage*)image atRange:(NSRange)range;

@end
