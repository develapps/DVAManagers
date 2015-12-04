//
//  DVAPopupViewController+BasicAlerts.h
//  Pods
//
//  Created by Pablo Romeu on 23/11/15.
//
//

#import <DVAPopupViewController/DVAPopupViewController.h>
#import "DVAPopupViewButton+BasicButtons.h"

/*!
 @author Pablo Romeu, 15-11-24 08:11:48
 
 Basic alert strings
 
 @since 1.0
 */
@interface DVAPopupViewController (BasicAlerts)

// String

+(DVAPopupViewController*)dva_alertWithText:(NSString*)string;

+(DVAPopupViewController*)dva_alertWithText:(NSString*)string
                                   andBlock:(void (^)(DVAPopupViewButton* buttonPressed))completionBlock;

+(DVAPopupViewController*)dva_alertWithText:(NSString*)string
                               okButtonText:(NSString*)okButton
                                   andBlock:(void (^)(DVAPopupViewButton* buttonPressed))completionBlock;

+(DVAPopupViewController*)dva_alertWithText:(NSString*)string
                                buttonsText:(NSArray<NSString*>*)okButton
                                   andBlock:(void (^)(DVAPopupViewButton* buttonPressed))completionBlock;

+(DVAPopupViewController*)dva_alertWithTitle:(NSString*)string
                                     andBody:(NSString*)body
                                 buttonsText:(NSArray<NSString*>*)okButton
                                    andBlock:(void (^)(DVAPopupViewButton* buttonPressed))completionBlock;

// Attributted string

+(DVAPopupViewController*)dva_alertWithAttributedText:(NSAttributedString*)string;

+(DVAPopupViewController*)dva_alertWithAttributedText:(NSAttributedString*)string
                                             andBlock:(void (^)(DVAPopupViewButton* buttonPressed))completionBlock;

+(DVAPopupViewController*)dva_alertWithAttributedText:(NSAttributedString*)string
                                         okButtonText:(NSAttributedString*)okButton
                                             andBlock:(void (^)(DVAPopupViewButton* buttonPressed))completionBlock;

+(DVAPopupViewController*)dva_alertWithAttributedText:(NSAttributedString*)string
                                          buttonsText:(NSArray<NSAttributedString*>*)buttonsText
                                             andBlock:(void (^)(DVAPopupViewButton* buttonPressed))completionBlock;

+(DVAPopupViewController*)dva_alertWithAttributedTitle:(NSAttributedString*)string
                                               andBody:(NSAttributedString*)body
                                           buttonsText:(NSArray<NSAttributedString*>*)buttonsText
                                              andBlock:(void (^)(DVAPopupViewButton* buttonPressed))completionBlock;


@end
