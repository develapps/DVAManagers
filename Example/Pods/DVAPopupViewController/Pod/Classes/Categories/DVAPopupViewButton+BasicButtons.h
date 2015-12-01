//
//  DVAPopupViewButton+BasicButtons.h
//  Pods
//
//  Created by Pablo Romeu on 24/11/15.
//
//

#import "DVAPopupViewButton.h"

@interface DVAPopupViewButton (BasicButtons)

+(DVAPopupViewButton *)dva_okButtonWithBlock:(void (^)(DVAPopupViewButton *button))completionBlock;
+(UIStackView *)dva_okAndCancelButtonWithBlock:(void (^)(DVAPopupViewButton *button))completionBlock;


#pragma mark - String versions
+(DVAPopupViewButton *)dva_buttonWithText:(NSString *)text
                                withBlock:(void (^)(DVAPopupViewButton *button))completionBlock;
+(UIStackView *)dva_buttonStackWithTexts:(NSArray<NSString *> *)texts
                                andBlock:(void (^)(DVAPopupViewButton *button))completionBlock;

#pragma mark - Attributed versions

+(DVAPopupViewButton*)dva_buttonWithAttributedString:(NSAttributedString*)attributedText
                                           withBlock:(void (^)(DVAPopupViewButton *button))completionBlock;
+(UIStackView*)dva_buttonStackWithAttributedArray:(NSArray <NSAttributedString *>*)attributedTexts
                                         andBlock:(void (^)(DVAPopupViewButton *buttonPressed))completionBlock;
@end
