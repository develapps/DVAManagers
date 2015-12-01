//
//  DVAPopupViewController
//  DVAPopupViewController
//
//  Created by Pablo Romeu on 23/10/15.
//  Copyright © 2015 DVAPopupViewButton. All rights reserved.
//

#import "DVAPopupViewController.h"

@interface DVAPopupViewController ()
@property (nonatomic,copy)      NSArray                 *views;
@property (nonatomic)           CGFloat                 spacing;
@property (nonatomic)           DVAPopupViewBackground  backgroundType;

@property (nonatomic,strong)    UIVisualEffectView      *blurEffectView;
@end

@implementation DVAPopupViewController

- (instancetype)initWithConfigurator:(DVAPopupViewConfigurator *)configurator
{
    self = [super init];
    if (self) {
        [self setupWithConfigurator:configurator];
    }
    return self;
}
+(instancetype)controllerWithConfigurator:(DVAPopupViewConfigurator*)configurator{
    return [[DVAPopupViewController alloc] initWithConfigurator:configurator];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}


#pragma mark - setup

-(void)setupWithConfigurator:(DVAPopupViewConfigurator*)configurator{
    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self setViewBackground:configurator.background];
    if (configurator.containerView) _containerView = configurator.containerView;
    [self setupContainerView];
    self.spacing = configurator.spacing;
    [self setContainerMode:configurator.containerMode];
    [self setViews:configurator.views];
    if (configurator.dismissable){
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dissmisView)];
        [self.view addGestureRecognizer:recognizer];
    }

}

-(void)dissmisView{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - containerView

-(void)setupContainerView{
    if (!_containerView) {
        _containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
        [_containerView setBackgroundColor:[UIColor whiteColor]];
    }
    [self.view addSubview:_containerView];
    [_containerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_containerView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.f constant:0.f]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_containerView
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.f constant:0.f]];
    [_containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[_containerView(>=200)]"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(_containerView)]];
    [_containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[_containerView(>=50)]"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:NSDictionaryOfVariableBindings(_containerView)]];
    
    [self.view  addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|->=10-[_containerView]->=10-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(_containerView)]];
    [self.view  addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|->=10-[_containerView]->=10-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:NSDictionaryOfVariableBindings(_containerView)]];
    
}


-(void)setContainerMode:(DVAPopupViewContainerMode)mode{
    switch (mode) {
        case DVAPopupViewContainerModeNormal:
            self.containerView.layer.shadowRadius  = 5.0;
            self.containerView.layer.shadowOpacity = 0.5;
            break;
        case DVAPopupViewContainerModeRoundedCorner:
        {
            self.containerView.layer.cornerRadius  = 8.0;
            self.containerView.layer.shadowOffset  = CGSizeMake(7, 7);
            self.containerView.layer.shadowRadius  = 5.0;
            self.containerView.layer.shadowOpacity = 0.5;
            break;
        }
        default:
            break;
    }
}

#pragma mark - StackView

-(UIStackView*)stackView{
    if (_stackView) {
        return _stackView;
    }
    _stackView = [[UIStackView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [_stackView setBackgroundColor:[UIColor blueColor]];
    [_stackView setAlignment:UIStackViewAlignmentCenter];
    [_stackView setDistribution:UIStackViewDistributionEqualSpacing];
    [_stackView setAxis:UILayoutConstraintAxisVertical];
    [_stackView setSpacing:self.spacing];
    [self.containerView addSubview:_stackView];
    return _stackView;
}

#pragma mark - Set view  background

-(void)setViewBackground:(DVAPopupViewBackground)background{
    _backgroundType = background;
    if (self.blurEffectView){
        [self.blurEffectView removeFromSuperview];
        self.blurEffectView = nil;
    }
    
    void (^setupBlur)(UIBlurEffectStyle) = ^void(UIBlurEffectStyle style) {
        [self.view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0 ]];
        UIBlurEffect*effect = [UIBlurEffect effectWithStyle:style];
        self.blurEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        [self.blurEffectView setFrame:self.view.bounds];
        [self.blurEffectView setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth ];
        [self.blurEffectView setTranslatesAutoresizingMaskIntoConstraints:YES];
        [self.view addSubview:self.blurEffectView];
    };
    if (background==DVAPopupViewOpaqueBackground) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
        return;
    }
    switch (background) {
        case DVAPopupViewNoBackground:
            [self.view setBackgroundColor:[UIColor clearColor]];
            break;
        case DVAPopupViewAlphaBackground:
            [self.view setBackgroundColor:[UIColor colorWithWhite:0.0 alpha:0.8]];
            break;
        case DVAPopupViewLightBlurBackground:
            setupBlur(UIBlurEffectStyleLight);
            break;
        case DVAPopupViewDarkBlurBackground:
            setupBlur(UIBlurEffectStyleDark);
            break;
        case DVAPopupViewExtraLightBlurBackground:
            setupBlur(UIBlurEffectStyleExtraLight);
        default:
            break;
    }
}

#pragma mark - Setup views

-(void)setViews:(NSArray*)views{
    [_stackView removeFromSuperview];
    _views = views;
    
    _stackView = [[UIStackView alloc] initWithArrangedSubviews:views];
    [self.containerView addSubview:_stackView];
    [_stackView setAxis:UILayoutConstraintAxisVertical];
    [_stackView setAlignment:UIStackViewAlignmentFill];
    [_stackView setDistribution:UIStackViewDistributionFillProportionally];
    [_stackView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_stackView setSpacing:self.spacing];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[_stackView]-|"
                                                                      options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stackView)]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[_stackView]-|"
                                                                      options:0 metrics:nil views:NSDictionaryOfVariableBindings(_stackView)]];
}

@end
