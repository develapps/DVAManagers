//
//  DVAPopupViewConfigurator.h
//  Pods
//
//  Created by Pablo Romeu on 20/11/15.
//
//

#import <Foundation/Foundation.h>



typedef enum : NSUInteger {
    DVAPopupViewOpaqueBackground    = 0,
    DVAPopupViewNoBackground,
    DVAPopupViewAlphaBackground,
    DVAPopupViewDarkBlurBackground,
    DVAPopupViewLightBlurBackground,
    DVAPopupViewExtraLightBlurBackground,
    
} DVAPopupViewBackground;

typedef enum :NSUInteger{
    DVAPopupViewContainerModeNormal     = 0,
    DVAPopupViewContainerModeRoundedCorner,
    
} DVAPopupViewContainerMode;

/*!
 @author Pablo Romeu, 15-11-25 11:11:15
 
 This class is a configurator for the Controller. The Controller needs to be initialized with this configurator
 
 @since 1.1.0
 @see DVAPopupViewController
 */

@interface DVAPopupViewConfigurator: NSObject

/*!
 @author Pablo Romeu, 15-11-25 11:11:50
 
 If this is YES, the view is dismissed if the user taps anywhere in the screen. Defaults to NO.
 
 @since 1.1.0
 */
@property (nonatomic)           BOOL dismissable;

/*!
 @author Pablo Romeu, 15-11-25 11:11:24
 
 The views to be setup in the `containerView` in the correct order.
 
 @since 1.1.0
 */
@property (nonatomic,strong)    NSArray *views;

/*!
 @author Pablo Romeu, 15-11-25 11:11:01
 
 The container view of the views. If not initialized, it is automatically initialized with a white view. By Default, it is setup to grow until it reaches 10 points from the edge of the controller's view.
 
 @since 1.1.0
 */
@property (nonatomic,strong)    UIView  *containerView;
/*!
 @author Pablo Romeu, 15-11-25 11:11:58
 
 The spacing between the views to be setup by the stackView. This property can be modified later.
 
 @since 1.1.0
 */
@property (nonatomic)           CGFloat spacing;
/*!
 @author Pablo Romeu, 15-11-25 11:11:30
 
 The background mode of the controller's view. It can be set to opaque (default), no backgroud, translucid, dark blur, light blur and extra light blur.
 
 It can be controlled after by changing the controller's view.
 
 @since 1.1.0
 */
@property (nonatomic)           DVAPopupViewBackground      background;
/*!
 @author Pablo Romeu, 15-11-25 11:11:53
 
 The mode of the border for the `containerView`. It can be normal or rounded with shadow.
 
 @since 1.1.0
 */
@property (nonatomic)           DVAPopupViewContainerMode   containerMode;
@end

