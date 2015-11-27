//
//  NSAttributedString+DVAImageAttachment.m
//  MyBae
//
//  Created by Pablo Romeu on 29/7/15.
//  Copyright (c) 2015 Mybæ. All rights reserved.
//

#import "NSAttributedString+DVAImageAttachment.h"

@implementation NSAttributedString (DVAImageAttachment)

+(NSString*)dva_attachmentStringLocation{
    return [NSString stringWithFormat:@"%c",NSAttachmentCharacter];
}
-(NSAttributedString*)dva_stringWithImage:(UIImage*)image{
    // NSAttachmentCharacter
    NSRange range=[[self string] rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:[NSAttributedString dva_attachmentStringLocation]]];
    if (range.location==NSNotFound) return self;
    return [self dva_stringWithImage:image atRange:range];
}

-(NSAttributedString*)dva_stringWithImage:(UIImage*)image atRange:(NSRange)range{
    NSMutableAttributedString*attributedString=[[NSMutableAttributedString alloc] initWithAttributedString:self];
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = image;

    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    [attributedString replaceCharactersInRange:range withAttributedString:attrStringWithImage];
    textAttachment.bounds = CGRectMake(0, [self fontAttribute].descender/2, textAttachment.image.size.width, textAttachment.image.size.height);
    return attributedString;
}

-(UIFont*)fontAttribute{
    __block UIFont*font=[UIFont systemFontOfSize:16];
    [self enumerateAttributesInRange:NSMakeRange(0, self.length) options:NSAttributedStringEnumerationLongestEffectiveRangeNotRequired usingBlock:^(NSDictionary *attrs, NSRange range, BOOL *stop) {
        UIFont*newFont=attrs[NSFontAttributeName];
        if (newFont) {
            font=newFont;
        }
    }];
    
    return font;
}

@end
