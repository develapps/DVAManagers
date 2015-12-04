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

@interface DVAPopupViewConfigurator: NSObject
@property (nonatomic)           BOOL dismissable;
@property (nonatomic,strong)    NSArray *views;
@property (nonatomic,strong)    UIView  *containerView;
@property (nonatomic)           CGFloat spacing;
@property (nonatomic)           DVAPopupViewBackground      background;
@property (nonatomic)           DVAPopupViewContainerMode   containerMode;
@end

