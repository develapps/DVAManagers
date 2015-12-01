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

+(DVAPopupViewController *)dva_loadingSpinnerAlertWithStyle:(UIActivityIndicatorViewStyle)style;

+(DVAPopupViewController*)dva_loadingSpinnerAlertWithText:(NSString*)text;
+(DVAPopupViewController*)dva_loadingSpinnerAlertWithText:(NSString*)text
                                                andButton:(DVAPopupViewButton*)button;

+(DVAPopupViewController*)dva_loadingAlertProgress:(NSProgress*)observedProgress;
+(DVAPopupViewController*)dva_loadingAlertProgress:(NSProgress*)observedProgress
                                          withText:(NSString*)text;
+(DVAPopupViewController*)dva_loadingAlertProgress:(NSProgress*)observedProgress
                                          withText:(NSString*)text
                                         andButton:(DVAPopupViewButton*)button;

@end
