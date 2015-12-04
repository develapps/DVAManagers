//
//  DVAPopupViewConfigurator+PredefinedConfigurators.h
//  Pods
//
//  Created by Pablo Romeu on 23/11/15.
//
//

#import <DVAPopupViewController/DVAPopupViewController.h>

@interface DVAPopupViewConfigurator (PredefinedConfigurators)

+(DVAPopupViewConfigurator*)dva_configuratorClearContainerView;
+(DVAPopupViewConfigurator*)dva_configuratorClearContainerViewAndViews:(NSArray*)array;
+(DVAPopupViewConfigurator*)dva_configuratorRoundedCorners;
+(DVAPopupViewConfigurator*)dva_configuratorRoundedCornersAndViews:(NSArray*)array;
#pragma mark - blur

+(DVAPopupViewConfigurator*)dva_configuratorRoundedCornersNoBackground;
+(DVAPopupViewConfigurator *)dva_configuratorRoundedCornersLightBlur;
+(DVAPopupViewConfigurator *)dva_configuratorRoundedCornersExtraLightBlur;
+(DVAPopupViewConfigurator *)dva_configuratorRoundedCornersDarkBlur;

+(DVAPopupViewConfigurator*)dva_configuratorRoundedCornersNoBackgroundAndViews:(NSArray*)array;
+(DVAPopupViewConfigurator *)dva_configuratorRoundedCornersLightBlurAndViews:(NSArray*)array;
+(DVAPopupViewConfigurator *)dva_configuratorRoundedCornersExtraLightBlurAndViews:(NSArray*)array;
+(DVAPopupViewConfigurator *)dva_configuratorRoundedCornersDarkBlurAndViews:(NSArray*)array;


@end
