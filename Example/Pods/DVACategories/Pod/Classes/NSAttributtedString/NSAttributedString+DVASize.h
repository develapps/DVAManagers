//
//  NSAttributedString+DVASize
//  Develapps
//
//  Created by Pablo Romeu on 6/3/15.
//  Copyright (c) 2015 Develapps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSAttributedString (DVASize)
/**
 This method returns the height of a NSAttributedString in a UIView
 
 @param view the view in which the string will be drawn. This method uses it's width
 
 @return the calculated height
 
 @since 1.0
 */
-(CGFloat)dva_heightFittingWidthOnView:(UIView*)view;
@end
