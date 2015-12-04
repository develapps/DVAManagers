//
//  DVAPopupViewConfigurator+PredefinedConfigurators.m
//  Pods
//
//  Created by Pablo Romeu on 23/11/15.
//
//

#import "DVAPopupViewConfigurator+PredefinedConfigurators.h"

@implementation DVAPopupViewConfigurator (PredefinedConfigurators)

+(DVAPopupViewConfigurator *)dva_configuratorClearContainerView{
    DVAPopupViewConfigurator *configurator=[[DVAPopupViewConfigurator alloc] init];
    configurator.spacing = 10;
    configurator.containerMode = DVAPopupViewContainerModeRoundedCorner;
    configurator.background = DVAPopupViewNoBackground;
    configurator.containerView = [UIView new];
    configurator.containerView.backgroundColor = [UIColor clearColor];
    return configurator;
}

+(DVAPopupViewConfigurator *)dva_configuratorRoundedCorners{
    DVAPopupViewConfigurator *configurator=[[DVAPopupViewConfigurator alloc] init];
    configurator.spacing = 10;
    configurator.containerMode = DVAPopupViewContainerModeRoundedCorner;
    configurator.background = DVAPopupViewNoBackground;
    return configurator;
}

#pragma mark - backgrounds

+(DVAPopupViewConfigurator *)dva_configuratorRoundedCornersNoBackground{
    DVAPopupViewConfigurator *configurator=[DVAPopupViewConfigurator dva_configuratorRoundedCorners];
    configurator.background = DVAPopupViewNoBackground;
    return configurator;
}
+(DVAPopupViewConfigurator *)dva_configuratorRoundedCornersLightBlur{
    DVAPopupViewConfigurator *configurator=[DVAPopupViewConfigurator dva_configuratorRoundedCorners];
    configurator.background = DVAPopupViewLightBlurBackground;
    return configurator;
}

+(DVAPopupViewConfigurator *)dva_configuratorRoundedCornersExtraLightBlur{
    DVAPopupViewConfigurator *configurator=[DVAPopupViewConfigurator dva_configuratorRoundedCorners];
    configurator.background = DVAPopupViewExtraLightBlurBackground;
    return configurator;
}

+(DVAPopupViewConfigurator *)dva_configuratorRoundedCornersDarkBlur{
    DVAPopupViewConfigurator *configurator=[DVAPopupViewConfigurator dva_configuratorRoundedCorners];
    configurator.background = DVAPopupViewDarkBlurBackground;
    return configurator;
}

#pragma mark - with views

+(DVAPopupViewConfigurator *)dva_configuratorClearContainerViewAndViews:(NSArray*)array{
    DVAPopupViewConfigurator *configurator = [DVAPopupViewConfigurator dva_configuratorClearContainerView];
    configurator.views = array;
    return configurator;
}
+(DVAPopupViewConfigurator*)dva_configuratorRoundedCornersAndViews:(NSArray*)array{
    DVAPopupViewConfigurator *configurator = [DVAPopupViewConfigurator dva_configuratorRoundedCorners];
    configurator.views = array;
    return configurator;
}

+(DVAPopupViewConfigurator*)dva_configuratorRoundedCornersNoBackgroundAndViews:(NSArray*)array{
    DVAPopupViewConfigurator *configurator = [DVAPopupViewConfigurator dva_configuratorRoundedCornersNoBackground];
    configurator.views = array;
    return configurator;
}
+(DVAPopupViewConfigurator *)dva_configuratorRoundedCornersLightBlurAndViews:(NSArray*)array{
    DVAPopupViewConfigurator *configurator = [DVAPopupViewConfigurator dva_configuratorRoundedCornersLightBlur];
    configurator.views = array;
    return configurator;

}
+(DVAPopupViewConfigurator *)dva_configuratorRoundedCornersExtraLightBlurAndViews:(NSArray*)array{
    DVAPopupViewConfigurator *configurator = [DVAPopupViewConfigurator dva_configuratorRoundedCornersExtraLightBlur];
    configurator.views = array;
    return configurator;

}
+(DVAPopupViewConfigurator *)dva_configuratorRoundedCornersDarkBlurAndViews:(NSArray*)array{
    DVAPopupViewConfigurator *configurator = [DVAPopupViewConfigurator dva_configuratorRoundedCornersDarkBlur];
    configurator.views = array;
    return configurator;

}



@end
