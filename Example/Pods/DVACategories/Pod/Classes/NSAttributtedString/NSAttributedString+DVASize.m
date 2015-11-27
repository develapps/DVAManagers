//
//  NSAttributedString+DVASize
//  Develapps
//
//  Created by Pablo Romeu on 6/3/15.
//  Copyright (c) 2015 Develapps. All rights reserved.
//

#import "NSAttributedString+DVASize.h"

@implementation NSAttributedString (DVASize)

-(CGFloat)dva_heightFittingWidthOnView:(UIView*)view{
    CGFloat width = view.bounds.size.width;
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, 1000000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
    return rect.size.height;
}
@end
