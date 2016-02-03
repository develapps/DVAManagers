//
//  DVAPopupViewButton+BasicButtons.m
//  Pods
//
//  Created by Pablo Romeu on 24/11/15.
//
//

#import "DVAPopupViewButton+BasicButtons.h"
#import "NSArray+DVALib.h"
#import "NSString+DVALocalized.h"

@implementation DVAPopupViewButton (BasicButtons)

#pragma mark - Default OK and Cancel buttons

+(DVAPopupViewButton *)dva_okButtonWithBlock:(void (^)(DVAPopupViewButton *button))completionBlock{
    return [DVAPopupViewButton dva_buttonWithText:[@"DVAPopupController_OK_BUTTON" dva_localizedStringForTable:@"DVAPopupController" inBundle:[NSBundle bundleForClass:[self class]]] withBlock:completionBlock];
}

+(UIStackView *)dva_okAndCancelButtonWithBlock:(void (^)(DVAPopupViewButton *))completionBlock{
    NSAttributedString*attributedString = [[NSAttributedString alloc]
                                           initWithString:[@"DVAPopupController_OK_BUTTON" dva_localizedStringForTable:@"DVAPopupController" inBundle:[NSBundle bundleForClass:[self class]]]
                                           attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3],
                                                        NSForegroundColorAttributeName : [UIColor blueColor]}];
    NSAttributedString*cancelAttributedString = [[NSAttributedString alloc]
                                                 initWithString:[@"DVAPopupController_CANCEL_BUTTON" dva_localizedStringForTable:@"DVAPopupController" inBundle:[NSBundle bundleForClass:[self class]]]
                                                 attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3],
                                                              NSForegroundColorAttributeName : [UIColor grayColor]}];
    return [DVAPopupViewButton dva_buttonStackWithAttributedArray:@[attributedString,cancelAttributedString] andBlock:completionBlock];
}



#pragma mark - String versions

+(DVAPopupViewButton *)dva_buttonWithText:(NSString *)text withBlock:(void (^)(DVAPopupViewButton *))completionBlock{
    NSAttributedString*attributedString = [[NSAttributedString alloc]
                                           initWithString:text
                                           attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3],
                                                        NSForegroundColorAttributeName : [UIColor blueColor]}];
    
    return [DVAPopupViewButton dva_buttonWithAttributedString:attributedString withBlock:completionBlock];
}

+(UIStackView *)dva_buttonStackWithTexts:(NSArray<NSString *> *)texts andBlock:(void (^)(DVAPopupViewButton *))completionBlock{
    NSArray <NSAttributedString*> * attributedTexts = [texts dva_map:^NSAttributedString*(NSString* item) {
        return  [[NSAttributedString alloc]
                 initWithString:item
                 attributes:@{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleTitle3],
                              NSForegroundColorAttributeName : [UIColor blueColor]}];
    }];
    return [DVAPopupViewButton dva_buttonStackWithAttributedArray:attributedTexts andBlock:completionBlock];
}

#pragma mark - Attributed versions

+(DVAPopupViewButton*)dva_buttonWithAttributedString:(NSAttributedString*)attributedText withBlock:(void (^)(DVAPopupViewButton *))completionBlock{
    DVAPopupViewButton *button =[DVAPopupViewButton new];
    [button setAttributedTitle:attributedText forState:UIControlStateNormal];
    __weak typeof(button) weakButton = button;
    [button setCompletionBlock:^{
        __strong typeof(weakButton) strongButton = weakButton;
        if (completionBlock) completionBlock(strongButton);
    }];
    return button;
}

+(UIStackView*)dva_buttonStackWithAttributedArray:(NSArray <NSAttributedString *>*)attributedTexts
                                      andBlock:(void (^)(DVAPopupViewButton *buttonPressed))completionBlock{
    
    UIStackView *stackView = [[UIStackView alloc] init];
//    NSArray *color =@[[UIColor redColor],[UIColor blueColor]];
    [attributedTexts enumerateObjectsUsingBlock:^(NSAttributedString * _Nonnull attributedText, NSUInteger idx, BOOL * _Nonnull stop) {
        DVAPopupViewButton*button=[self dva_buttonWithAttributedString:attributedText withBlock:completionBlock];
        [stackView addArrangedSubview:button];
//        [button setBackgroundColor:[color objectAtIndex:idx]];
    }];
    [stackView setAxis:UILayoutConstraintAxisHorizontal];
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.distribution = UIStackViewDistributionFillEqually;
    return stackView;
    
}


@end
