//
//  DVAPopupViewController+BasicAlerts.h
//  Pods
//
//  Created by Pablo Romeu on 23/11/15.
//
//

#import <DVAPopupViewController/DVAPopupViewController.h>
#import "DVAPopupViewButton+BasicButtons.h"

typedef void (^DVAPopupButtonBlock)(DVAPopupViewButton* buttonPressed);

/*!
 @author Pablo Romeu, 15-11-24 08:11:48
 
 Basic alert strings
 
 @since 1.0
 */
@interface DVAPopupViewController (BasicAlerts)

// String

/*!
 @author Pablo Romeu, 15-11-25 13:11:56
 
 Basic alert with a custom text and ok button
 
 @param string the text to be shown
 
 @return the controller
 
 @since 1.1.0
 */
+(DVAPopupViewController*)dva_alertWithText:(NSString*)string;
/*!
 @author Pablo Romeu, 15-11-25 13:11:56
 
 Basic alert with a custom text and ok button and a completion block
 
 @param string the text to be shown
 @param completionBlock a completion block
 
 @return the controller
 
 @since 1.1.0
 */
+(DVAPopupViewController*)dva_alertWithText:(NSString*)string
                                   andBlock:(DVAPopupButtonBlock)completionBlock;

/*!
 @author Pablo Romeu, 15-11-25 13:11:56
 
 Basic alert with a custom text and custom button and a completion block
 
 @param string the text to be shown
 @param okButton the text for the button
 @param completionBlock a completion block
 
 @return the controller
 
 @since 1.1.0
 */

+(DVAPopupViewController*)dva_alertWithText:(NSString*)string
                               okButtonText:(NSString*)okButton
                                   andBlock:(DVAPopupButtonBlock)completionBlock;
/*!
 @author Pablo Romeu, 15-11-25 13:11:56
 
 Basic alert with a custom buttons and a completion block
 
 @param string the text to be shown
 @param okButton an array of button texts
 @param completionBlock a completion block
 
 @return the controller
 
 @since 1.1.0
 */


+(DVAPopupViewController*)dva_alertWithText:(NSString*)string
                                buttonsText:(NSArray<NSString*>*)okButton
                                   andBlock:(DVAPopupButtonBlock)completionBlock;

/*!
 @author Pablo Romeu, 15-11-25 13:11:56
 
 Basic alert with a custom text and custom button and a completion block
 
 @param string the text to be shown
 @param body a text for the body
 @param okButton an array of button's text
 @param completionBlock a completion block
 
 @return the controller
 
 @since 1.1.0
 */

+(DVAPopupViewController*)dva_alertWithTitle:(NSString*)string
                                     andBody:(NSString*)body
                                 buttonsText:(NSArray<NSString*>*)okButton
                                    andBlock:(DVAPopupButtonBlock)completionBlock;

// Attributted string

/*!
 @author Pablo Romeu, 15-11-25 13:11:56
 
 Basic alert with a custom text and ok button
 
 @param string the text to be shown
 
 @return the controller
 
 @since 1.1.0
 */
+(DVAPopupViewController*)dva_alertWithAttributedText:(NSAttributedString*)string;

/*!
 @author Pablo Romeu, 15-11-25 13:11:56
 
 Basic alert with a custom text and ok button and a completion block
 
 @param string the text to be shown
 @param completionBlock a completion block
 
 @return the controller
 
 @since 1.1.0
 */
+(DVAPopupViewController*)dva_alertWithAttributedText:(NSAttributedString*)string
                                             andBlock:(DVAPopupButtonBlock)completionBlock;
/*!
 @author Pablo Romeu, 15-11-25 13:11:56
 
 Basic alert with a custom text and custom button and a completion block
 
 @param string the text to be shown
 @param okButton the text for the button
 @param completionBlock a completion block
 
 @return the controller
 
 @since 1.1.0
 */

+(DVAPopupViewController*)dva_alertWithAttributedText:(NSAttributedString*)string
                                         okButtonText:(NSAttributedString*)okButton
                                             andBlock:(DVAPopupButtonBlock)completionBlock;
/*!
 @author Pablo Romeu, 15-11-25 13:11:56
 
 Basic alert with a custom buttons and a completion block
 
 @param string the text to be shown
 @param buttonsText an array of button texts
 @param completionBlock a completion block
 
 @return the controller
 
 @since 1.1.0
 */

+(DVAPopupViewController*)dva_alertWithAttributedText:(NSAttributedString*)string
                                          buttonsText:(NSArray<NSAttributedString*>*)buttonsText
                                             andBlock:(DVAPopupButtonBlock)completionBlock;
/*!
 @author Pablo Romeu, 15-11-25 13:11:56
 
 Basic alert with a custom text and custom button and a completion block
 
 @param string the text to be shown
 @param body a text for the body
 @param buttonsText an array of button's text
 @param completionBlock a completion block
 
 @return the controller
 
 @since 1.1.0
 */
+(DVAPopupViewController*)dva_alertWithAttributedTitle:(NSAttributedString*)string
                                               andBody:(NSAttributedString*)body
                                           buttonsText:(NSArray<NSAttributedString*>*)buttonsText
                                              andBlock:(DVAPopupButtonBlock)completionBlock;


@end
