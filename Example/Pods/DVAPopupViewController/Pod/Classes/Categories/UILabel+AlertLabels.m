//
//  UILabel+AlertLabels.m
//  Pods
//
//  Created by Pablo Romeu on 24/11/15.
//
//

#import "UILabel+AlertLabels.h"

@implementation UILabel (AlertLabels)

+(UILabel*)dva_titleLabelWithText:(NSString*)text{
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentCenter;
    style.firstLineHeadIndent = 10;
    style.headIndent = 10;
    style.tailIndent = -10;
    
    NSAttributedString*attributedString = [[NSAttributedString alloc]
                                           initWithString:text
                                           attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3],
                                                        NSForegroundColorAttributeName : [UIColor darkGrayColor],
                                                        NSParagraphStyleAttributeName : style}];
    return [UILabel dva_titleLabelWithAttributedString:attributedString];
}

+(UILabel*)dva_bodyLabelWithText:(NSString*)text{
    NSMutableParagraphStyle *style =  [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.alignment = NSTextAlignmentJustified;
    style.lineBreakMode = NSLineBreakByWordWrapping;
    style.firstLineHeadIndent = 10;
    style.headIndent = 10;
    style.tailIndent = -10;
    
    NSAttributedString*attributedString = [[NSAttributedString alloc]
                                           initWithString:text
                                           attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
                                                        NSForegroundColorAttributeName : [UIColor blackColor],
                                                        NSParagraphStyleAttributeName : style}];
    UILabel *label = [UILabel dva_bodyLabelWithAttributedString:attributedString];
    [label setNumberOfLines:0];
    return label;
}

+(UILabel*)dva_titleLabelWithAttributedString:(NSAttributedString*)text{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [label setAttributedText:text];
    [label setTextAlignment:NSTextAlignmentCenter];
    return label;
}

+(UILabel*)dva_bodyLabelWithAttributedString:(NSAttributedString*)text{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [label setAttributedText:text];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setNumberOfLines:0];
    return label;
}

@end
