//
//  UIActivityIndicatorView+LoadingSpinners.m
//  Pods
//
//  Created by Pablo Romeu on 24/11/15.
//
//

#import "UIActivityIndicatorView+LoadingSpinners.h"

@implementation UIActivityIndicatorView (LoadingSpinners)
+(UIStackView*)dva_spinner{
    return [UIActivityIndicatorView dva_spinnerWithStyle:UIActivityIndicatorViewStyleGray];
}
+(UIStackView*)dva_spinnerWithStyle:(UIActivityIndicatorViewStyle)style{
    UIActivityIndicatorView*av =[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    [av startAnimating];
    UIStackView *stackView = [[UIStackView alloc] initWithArrangedSubviews:@[[UIView new],av,[UIView new]]];
    [stackView setAxis:UILayoutConstraintAxisHorizontal];
    stackView.alignment = UIStackViewAlignmentCenter;
    stackView.distribution = UIStackViewDistributionFillEqually;
    return stackView;
}
@end
