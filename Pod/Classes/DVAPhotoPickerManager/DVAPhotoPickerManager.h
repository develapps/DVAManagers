//
//  DVAPhotoPickerManager.h
//  Pods
//
//  Created by Pablo Romeu on 24/11/15.
//
//

#import <Foundation/Foundation.h>

#import <MobileCoreServices/MobileCoreServices.h>
#import <UIKit/UIKit.h>

@protocol DVAPhotoPickerManagerDelegate;

@interface DVAPhotoPickerManager : NSObject

@property (weak, nonatomic) id<DVAPhotoPickerManagerDelegate> delegate;
@property (assign, nonatomic) BOOL allowsEditing;

- (void) setDataToHandlerWithView:(UIView *)view;
- (void) showActionSheetPhotoOptionsInController:(UIViewController *)controller;
- (void) useCamera;
- (void) useCameraRoll;

@end

@protocol DVAPhotoPickerManagerDelegate <NSObject>

- (void) pickerManagerPresentSelectPictureViewController:(UIViewController *)viewControllerToPresent WithAnimation: (BOOL) animation;
- (void) pickerManagerDismissSelectPictureViewController:(UIViewController *)viewControllerToPresent WithAnimation: (BOOL) animation;
- (void) pickerManagerImageSelected:(UIImage *)imageSelected;

@end

