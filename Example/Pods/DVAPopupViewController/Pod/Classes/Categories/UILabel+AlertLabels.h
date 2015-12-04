//
//  UILabel+AlertLabels.h
//  Pods
//
//  Created by Pablo Romeu on 24/11/15.
//
//

#import <UIKit/UIKit.h>

@interface UILabel (AlertLabels)
+(UILabel*)dva_titleLabelWithText:(NSString*)text;
+(UILabel*)dva_bodyLabelWithText:(NSString*)text;
+(UILabel*)dva_titleLabelWithAttributedString:(NSAttributedString*)text;
+(UILabel*)dva_bodyLabelWithAttributedString:(NSAttributedString*)text;
@end
