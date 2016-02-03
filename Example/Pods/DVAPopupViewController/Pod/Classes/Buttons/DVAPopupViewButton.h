//
//  DVAPopupViewButton
//  DVAPopupViewButton
//
//  Created by Pablo Romeu on 23/10/15.
//  Copyright © 2015 DVAPopupViewButton. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 @author Pablo Romeu, 15-11-25 08:11:18
 
 A simple subclass of `UIButton` that adds a completionBlock. It will be called if the button is pressed
 
 @since 1.0.0
 */
@interface DVAPopupViewButton : UIButton

/*!
 @author Pablo Romeu, 15-11-25 08:11:12
 
 A completion block to be called when a button is pressed
 
 @since 1.0.0
 */
@property (nonatomic, copy) void (^completionBlock)();
@end
