//
//  DVAPopupViewController+BasicAlerts.m
//  Pods
//
//  Created by Pablo Romeu on 23/11/15.
//
//

#import "DVAPopupViewController+BasicAlerts.h"

// Caetegories

#import "DVAPopupViewConfigurator+PredefinedConfigurators.h"
#import "DVAPopupViewButton+BasicButtons.h"
#import "UILabel+AlertLabels.h"
#import "NSString+DVALocalized.h"

@implementation DVAPopupViewController (BasicAlerts)

// String

+(DVAPopupViewController*)dva_alertWithText:(NSString*)string{
    DVAPopupViewConfigurator*configurator = [DVAPopupViewConfigurator dva_configuratorRoundedCornersNoBackground];
    UILabel *label = [UILabel dva_bodyLabelWithText:string];
    DVAPopupViewController *controller = [DVAPopupViewController new];
    configurator.views = @[label,
                           [DVAPopupViewButton dva_okButtonWithBlock:^(DVAPopupViewButton *button) {
                               [controller.presentingViewController dismissViewControllerAnimated:YES
                                                                                       completion:nil];
                           }]];
    [controller setupWithConfigurator:configurator];
    return controller;
}
+(DVAPopupViewController*)dva_alertWithText:(NSString*)string
                                   andBlock:(DVAPopupButtonBlock)completionBlock;
{
    return [DVAPopupViewController dva_alertWithText:string okButtonText:[@"DVAPopupController_CANCEL_BUTTON" dva_localizedStringForTable:@"DVAPopupController" inBundle:[NSBundle bundleForClass:[DVAPopupViewController class]]] andBlock:completionBlock];
}

+(DVAPopupViewController *)dva_alertWithText:(NSString *)string
                                okButtonText:(NSString *)okButton
                                    andBlock:(void (^)(DVAPopupViewButton *))completionBlock{
    DVAPopupViewButton *button = [DVAPopupViewButton dva_buttonWithText:okButton withBlock:completionBlock];
    UILabel *label = [UILabel dva_bodyLabelWithText:string];
    return [[DVAPopupViewController alloc] initWithConfigurator:[DVAPopupViewConfigurator dva_configuratorRoundedCornersNoBackgroundAndViews:@[label,button]]];
}

+(DVAPopupViewController*)dva_alertWithText:(NSString*)string
                                buttonsText:(NSArray<NSString *> *)okButton
                                   andBlock:(void (^)(DVAPopupViewButton *))completionBlock{
    UIStackView *stackView = [DVAPopupViewButton dva_buttonStackWithTexts:okButton andBlock:completionBlock];
    UILabel *label = [UILabel dva_bodyLabelWithText:string];
    return [[DVAPopupViewController alloc] initWithConfigurator:[DVAPopupViewConfigurator dva_configuratorRoundedCornersNoBackgroundAndViews:@[label,stackView]]];
}
+(DVAPopupViewController *)dva_alertWithTitle:(NSString *)string
                                      andBody:(NSString *)body
                                  buttonsText:(NSArray<NSString *> *)okButton
                                     andBlock:(void (^)(DVAPopupViewButton *))completionBlock{
    UIStackView *stackView = [DVAPopupViewButton dva_buttonStackWithTexts:okButton andBlock:completionBlock];
    UILabel *label = [UILabel dva_titleLabelWithText:string];
    UILabel *bodyLabel = [UILabel dva_bodyLabelWithText:body];
    return [[DVAPopupViewController alloc] initWithConfigurator:[DVAPopupViewConfigurator dva_configuratorRoundedCornersNoBackgroundAndViews:@[label,bodyLabel,stackView]]];

}


// Attributted string

+(DVAPopupViewController*)dva_alertWithAttributedText:(NSAttributedString *)string{
    DVAPopupViewConfigurator*configurator = [DVAPopupViewConfigurator dva_configuratorRoundedCornersNoBackground];
    UILabel *label = [UILabel dva_bodyLabelWithAttributedString:string];
    DVAPopupViewController *controller = [DVAPopupViewController new];
    configurator.views = @[label,
                           [DVAPopupViewButton dva_okButtonWithBlock:^(DVAPopupViewButton *button) {
                               [controller.presentingViewController dismissViewControllerAnimated:YES
                                                                                       completion:nil];
                           }]];
    [controller setupWithConfigurator:configurator];
    return controller;
}

+(DVAPopupViewController *)dva_alertWithAttributedText:(NSAttributedString *)string
                                              andBlock:(void (^)(DVAPopupViewButton *))completionBlock{
    NSAttributedString *okString = [[NSAttributedString alloc] initWithString:[@"DVAPopupController_CANCEL_BUTTON" dva_localizedStringForTable:@"DVAPopupController" inBundle:[NSBundle bundleForClass:[DVAPopupViewController class]]]];
    return [DVAPopupViewController dva_alertWithAttributedText:string okButtonText:okString andBlock:completionBlock];
}

+(DVAPopupViewController *)dva_alertWithAttributedText:(NSAttributedString *)string
                                          okButtonText:(NSAttributedString *)okButton
                                              andBlock:(void (^)(DVAPopupViewButton *))completionBlock{
    UILabel *label = [UILabel dva_bodyLabelWithAttributedString:string];
    DVAPopupViewButton *button = [DVAPopupViewButton dva_buttonWithAttributedString:okButton withBlock:completionBlock];
    return [DVAPopupViewController controllerWithConfigurator:[DVAPopupViewConfigurator dva_configuratorRoundedCornersNoBackgroundAndViews:@[label,button]]];
}

+(DVAPopupViewController *)dva_alertWithAttributedText:(NSAttributedString *)string
                                           buttonsText:(NSArray<NSAttributedString *> *)buttonsText
                                              andBlock:(void (^)(DVAPopupViewButton *))completionBlock{
    UILabel *label = [UILabel dva_bodyLabelWithAttributedString:string];
    UIStackView *stackView = [DVAPopupViewButton dva_buttonStackWithAttributedArray:buttonsText andBlock:completionBlock];
    return [DVAPopupViewController controllerWithConfigurator:[DVAPopupViewConfigurator dva_configuratorRoundedCornersNoBackgroundAndViews:@[label,stackView]]];
}

+(DVAPopupViewController *)dva_alertWithAttributedTitle:(NSAttributedString *)string
                                                andBody:(NSAttributedString *)body
                                            buttonsText:(NSArray<NSAttributedString *> *)buttonsText
                                               andBlock:(void (^)(DVAPopupViewButton *))completionBlock{
    UILabel *label = [UILabel dva_titleLabelWithAttributedString:string];
    UILabel *bodyLabel = [UILabel dva_bodyLabelWithAttributedString:body];
    UIStackView *stackView = [DVAPopupViewButton dva_buttonStackWithAttributedArray:buttonsText andBlock:completionBlock];
    return [DVAPopupViewController controllerWithConfigurator:[DVAPopupViewConfigurator dva_configuratorRoundedCornersNoBackgroundAndViews:@[label,bodyLabel,stackView]]];

}

@end
