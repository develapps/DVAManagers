//
//  DVAPopupViewController+BasicLoading.m
//  Pods
//
//  Created by Pablo Romeu on 24/11/15.
//
//

#import "DVAPopupViewController+BasicLoading.h"
#import "UIActivityIndicatorView+LoadingSpinners.h"
#import "DVAPopupViewConfigurator+PredefinedConfigurators.h"
#import "UILabel+AlertLabels.h"
#import "DVAPopupViewButton+BasicButtons.h"

@implementation DVAPopupViewController (BasicLoading)

+(DVAPopupViewController *)dva_loadingSpinnerAlertWithStyle:(UIActivityIndicatorViewStyle)style{
    UIStackView*spinner = [UIActivityIndicatorView dva_spinnerWithStyle:style];
    return [DVAPopupViewController controllerWithConfigurator:[DVAPopupViewConfigurator dva_configuratorClearContainerViewAndViews:@[spinner]]];
}


+(DVAPopupViewController*)dva_loadingSpinnerAlertWithText:(NSString*)text{
    UIStackView*spinner = [UIActivityIndicatorView dva_spinnerWithStyle:UIActivityIndicatorViewStyleGray];
    UILabel *label = [UILabel dva_bodyLabelWithText:text];
    DVAPopupViewController*controller = [DVAPopupViewController controllerWithConfigurator:[DVAPopupViewConfigurator dva_configuratorRoundedCornersAndViews:@[label,spinner]]];
    
    return controller;
}

+(DVAPopupViewController*)dva_loadingSpinnerAlertWithText:(NSString*)text
                                                andButton:(DVAPopupViewButton*)button{
    DVAPopupViewController*controller = [self dva_loadingSpinnerAlertWithText:text];
    [controller.stackView addArrangedSubview:button];
    return controller;
}

#pragma mark - progress

+(DVAPopupViewController*)dva_loadingAlertProgress:(NSProgress*)observedProgress{
    UIProgressView *progressView= [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.observedProgress = observedProgress;
    DVAPopupViewController*controller = [DVAPopupViewController controllerWithConfigurator:[DVAPopupViewConfigurator dva_configuratorRoundedCornersAndViews:@[progressView]]];
    return controller;

}
+(DVAPopupViewController*)dva_loadingAlertProgress:(NSProgress*)observedProgress
                                          withText:(NSString*)text{
    UILabel *label = [UILabel dva_bodyLabelWithText:text];
    UIProgressView *progressView= [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
    progressView.observedProgress = observedProgress;
    DVAPopupViewController*controller = [DVAPopupViewController controllerWithConfigurator:[DVAPopupViewConfigurator dva_configuratorRoundedCornersAndViews:@[label,progressView]]];
    return controller;
}
+(DVAPopupViewController*)dva_loadingAlertProgress:(NSProgress*)observedProgress
                                          withText:(NSString*)text
                                         andButton:(DVAPopupViewButton *)button{
    DVAPopupViewController*controller = [DVAPopupViewController dva_loadingAlertProgress:observedProgress withText:text];
    [controller.stackView addArrangedSubview:button];
    return controller;
}


@end
