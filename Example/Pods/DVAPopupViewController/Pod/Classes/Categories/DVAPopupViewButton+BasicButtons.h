//
//  DVAPopupViewButton+BasicButtons.h
//  Pods
//
//  Created by Pablo Romeu on 24/11/15.
//
//

#import "DVAPopupViewButton.h"

/*!
 @author Pablo Romeu, 15-11-25 08:11:32
 
 An extension to provide simple buttons with `NSString` and `NSAttributedString`
 
 @since 1.0.0
 */

@interface DVAPopupViewButton (BasicButtons)

#pragma mark - OK and OK and CANCEL buttons

/*!
 @author Pablo Romeu, 15-11-25 12:11:23
 
 An Ok button with a completion block
 
 @param completionBlock a completion block
 
 @return a popupViewButton
 
 @since 1.1.0
 */
+(DVAPopupViewButton *)dva_okButtonWithBlock:(void (^)(DVAPopupViewButton *button))completionBlock;
/*!
 @author Pablo Romeu, 15-11-25 12:11:23
 
 An Ok and Cancel buttons with a completion block
 
 @param completionBlock a completion block
 
 @return a popupViewButton's stackView
 
 @since 1.1.0
 */
+(UIStackView *)dva_okAndCancelButtonWithBlock:(void (^)(DVAPopupViewButton *button))completionBlock;


#pragma mark - String versions

/*!
 @author Pablo Romeu, 15-11-25 12:11:23
 
 A button with the specified text with a completion block
 
 @param completionBlock a completion block
 
 @return a popupViewButton
 
 @since 1.1.0
 */

+(DVAPopupViewButton *)dva_buttonWithText:(NSString *)text
                                withBlock:(void (^)(DVAPopupViewButton *button))completionBlock;

/*!
 @author Pablo Romeu, 15-11-25 12:11:23
 
 An array of horizontally stacked buttons with a completion block
 
 @param completionBlock a completion block
 
 @return a popupViewButton's stackView
 
 @since 1.1.0
 */

+(UIStackView *)dva_buttonStackWithTexts:(NSArray<NSString *> *)texts
                                andBlock:(void (^)(DVAPopupViewButton *button))completionBlock;

#pragma mark - Attributed versions
/*!
 @author Pablo Romeu, 15-11-25 12:11:23
 
 A button with the specified text with a completion block
 
 @param completionBlock a completion block
 
 @return a popupViewButton
 
 @since 1.1.0
 */
+(DVAPopupViewButton*)dva_buttonWithAttributedString:(NSAttributedString*)attributedText
                                           withBlock:(void (^)(DVAPopupViewButton *button))completionBlock;

/*!
 @author Pablo Romeu, 15-11-25 12:11:23
 
 An array of horizontally stacked buttons with a completion block
 
 @param completionBlock a completion block
 
 @return a popupViewButton's stackView
 
 @since 1.1.0
 */
+(UIStackView*)dva_buttonStackWithAttributedArray:(NSArray <NSAttributedString *>*)attributedTexts
                                         andBlock:(void (^)(DVAPopupViewButton *buttonPressed))completionBlock;
@end
