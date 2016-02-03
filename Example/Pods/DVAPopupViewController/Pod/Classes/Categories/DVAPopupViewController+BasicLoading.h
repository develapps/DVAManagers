//
//  DVAPopupViewController+BasicLoading.h
//  Pods
//
//  Created by Pablo Romeu on 24/11/15.
//
//

#import <DVAPopupViewController/DVAPopupViewController.h>
#import "DVAPopupViewButton+BasicButtons.h"

@interface DVAPopupViewController (BasicLoading)


/*!
 @author Pablo Romeu, 15-11-25 12:11:23
 
 Basic loading controller with spinner with no background and no contentView
 
 @param style the spinner style
 
 @return a controller
 
 @since 1.1.0
 */
+(DVAPopupViewController *)dva_loadingSpinnerAlertWithStyle:(UIActivityIndicatorViewStyle)style;
/*!
 @author Pablo Romeu, 15-11-25 12:11:23
 
 Basic loading controller with spinner with no background
 
 @param text the text for the loading view

 @return a controller
 
 @since 1.1.0
 */
+(DVAPopupViewController*)dva_loadingSpinnerAlertWithText:(NSString*)text;
/*!
 @author Pablo Romeu, 15-11-25 12:11:23
 
 Basic loading controller with spinner with no background
 
 @param text the text for the loading view
 @param button the text for a cancel button

 @return a controller
 
 @since 1.1.0
 */
+(DVAPopupViewController*)dva_loadingSpinnerAlertWithText:(NSString*)text
                                                andButton:(DVAPopupViewButton*)button;
/*!
 @author Pablo Romeu, 15-11-25 12:11:47
 
 Basic loading alert progress view
 
 @param observedProgress the observed progress
 
 @return a controller
 
 @since 1.1.0
 */
+(DVAPopupViewController*)dva_loadingAlertProgress:(NSProgress*)observedProgress;

/*!
 @author Pablo Romeu, 15-11-25 12:11:47
 
 Basic loading alert progress view
 
 @param observedProgress the observed progress
 @param text the text to be shown

 @return a controller
 
 @since 1.1.0
 */
+(DVAPopupViewController*)dva_loadingAlertProgress:(NSProgress*)observedProgress
                                          withText:(NSString*)text;

/*!
 @author Pablo Romeu, 15-11-25 12:11:47
 
 Basic loading alert progress view
 
 @param observedProgress the observed progress
 @param text the text to be shown
 @param button a cancel button
 @return a controller
 
 @since 1.1.0
 */
+(DVAPopupViewController*)dva_loadingAlertProgress:(NSProgress*)observedProgress
                                          withText:(NSString*)text
                                         andButton:(DVAPopupViewButton*)button;

@end
