//
//  DVAPhotoPickerManager.h
//  Pods
//
//  Created by Pablo Romeu on 24/11/15.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "NSError+DVAPhotoPickerManager.h"

@protocol DVAPhotoPickerPostProcessAction;

typedef enum : NSUInteger {
    DVAPhotoPickerManagerSourceTypeAsk           = 0,
    DVAPhotoPickerManagerSourceTypePhotoLibrary  = 1,
    DVAPhotoPickerManagerSourceTypeCamera        = 2,
    DVAPhotoPickerManagerSourceTypeSavedPhotos   = 3,
} DVAPhotoPickerManagerSourceType;

typedef void(^photoPickerCompletion)(UIImage*image,NSError*error);

@interface DVAPhotoPickerManager : NSObject

-(instancetype)initWithViewController:(UIViewController*)controller
                   andCompletionBlock:(photoPickerCompletion)completion;

+(instancetype)dva_showPhotoPickerOnViewController:(UIViewController*)controller
                                             withType:(DVAPhotoPickerManagerSourceType)type
                                  withCompletionBlock:(photoPickerCompletion)completion;

@property (nonatomic,copy) NSArray < id<DVAPhotoPickerPostProcessAction> > *dva_postProcessActions;
@property (nonatomic) BOOL dva_allowsEditing;
@property (nonatomic) BOOL dva_showsControlls;
@property (nonatomic) BOOL dva_savesToPhotoAlbum;
@property (nonatomic) BOOL debug;

-(void)dva_showActionSheetPhotoOptions;

@end

