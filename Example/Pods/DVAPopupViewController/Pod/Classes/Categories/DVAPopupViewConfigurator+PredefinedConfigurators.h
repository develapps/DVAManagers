//
//  DVAPopupViewConfigurator+PredefinedConfigurators.h
//  Pods
//
//  Created by Pablo Romeu on 23/11/15.
//
//

#import <DVAPopupViewController/DVAPopupViewController.h>

@interface DVAPopupViewConfigurator (PredefinedConfigurators)

/*!
 @author Pablo Romeu, 15-11-25 12:11:37
 
 A configurator with no container view and no background (clear) view.
 
 @return A Configurator for the PopupController
 
 @since 1.1.0
 */
+(DVAPopupViewConfigurator*)dva_configuratorClearContainerView;
/*!
 @author Pablo Romeu, 15-11-25 12:11:37
 
 A configurator with no container view and no background (clear) view.
 
 @return A Configurator for the PopupController
 
 @param array an array of views to be layed out
 
 @since 1.1.0
 */
+(DVAPopupViewConfigurator*)dva_configuratorClearContainerViewAndViews:(NSArray*)array;
/*!
 @author Pablo Romeu, 15-11-25 12:11:37
 
 A rounded corner configurator.
 
 @return A Configurator for the PopupController
 
 @since 1.1.0
 */
+(DVAPopupViewConfigurator*)dva_configuratorRoundedCorners;
/*!
 @author Pablo Romeu, 15-11-25 12:11:49
 
 A rounded corner configurator.
 
 @return A Configurator for the PopupController
 
 @param array an array of views to be layed out
 
 @since 1.1.0
 
 */
+(DVAPopupViewConfigurator*)dva_configuratorRoundedCornersAndViews:(NSArray*)array;
#pragma mark - blur
/*!
 @author Pablo Romeu, 15-11-25 12:11:37
 
 A rounded corner configurator with no background view.
 
 @return A Configurator for the PopupController
 
 @since 1.1.0
 */
+(DVAPopupViewConfigurator*)dva_configuratorRoundedCornersNoBackground;
/*!
 @author Pablo Romeu, 15-11-25 12:11:37
 
 A rounded corner configurator with light blur background view.
 
 @return A Configurator for the PopupController
 
 @since 1.1.0
 */

+(DVAPopupViewConfigurator *)dva_configuratorRoundedCornersLightBlur;
/*!
 @author Pablo Romeu, 15-11-25 12:11:37
 
 A rounded corner configurator with extra light blur background view.
 
 @return A Configurator for the PopupController
 
 @since 1.1.0
 */
+(DVAPopupViewConfigurator *)dva_configuratorRoundedCornersExtraLightBlur;
/*!
 @author Pablo Romeu, 15-11-25 12:11:37
 
 A rounded corner configurator with dark blur background view.
 
 @return A Configurator for the PopupController
 
 @since 1.1.0
 */
+(DVAPopupViewConfigurator *)dva_configuratorRoundedCornersDarkBlur;
/*!
 @author Pablo Romeu, 15-11-25 12:11:30
 
 A rounded corner configurator with no background and views.
 
 @param array the array of views to be layed out
 
 @return A Configurator for the PopupController
 
 @since 1.1.0
 */
+(DVAPopupViewConfigurator*)dva_configuratorRoundedCornersNoBackgroundAndViews:(NSArray*)array;
/*!
 @author Pablo Romeu, 15-11-25 12:11:30
 
 A rounded corner configurator with light blur and views.
 
 @param array the array of views to be layed out
 
 @return A Configurator for the PopupController
 
 @since 1.1.0
 */
+(DVAPopupViewConfigurator *)dva_configuratorRoundedCornersLightBlurAndViews:(NSArray*)array;
/*!
 @author Pablo Romeu, 15-11-25 12:11:30
 
 A rounded corner configurator with extra light blur and views.
 
 @param array the array of views to be layed out
 
 @return A Configurator for the PopupController
 
 @since 1.1.0
 */
+(DVAPopupViewConfigurator *)dva_configuratorRoundedCornersExtraLightBlurAndViews:(NSArray*)array;
/*!
 @author Pablo Romeu, 15-11-25 12:11:30
 
 A rounded corner configurator with dark blur and views.
 
 @param array the array of views to be layed out
 
 @return A Configurator for the PopupController
 
 @since 1.1.0
 */
+(DVAPopupViewConfigurator *)dva_configuratorRoundedCornersDarkBlurAndViews:(NSArray*)array;


@end
