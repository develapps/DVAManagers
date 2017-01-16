//
//  NSError+DVAPhotoPickerManager.h
//  Pods
//
//  Created by Pablo Romeu on 27/11/15.
//
//

#import <Foundation/Foundation.h>

static NSString *const kDVAPhotoPickerManagerErrorDomain;
static NSString *const kDVAPhotoPickerManagerErrorPostProcess;

typedef enum : NSUInteger {
    DVAPhotoPickerErrorGeneral                                      = 0,
    DVAPhotoPickerErrorCancelled                                    = 1,
    DVAPhotoPickerErrorPostProcessFailed                            = 2,

} DVAPhotoPickerManagerError;


@interface NSError (DVAPhotoPickerManager)
+(NSError*)dva_photoErrorWithType:(DVAPhotoPickerManagerError)errorType;
+(NSError*)dva_photoErrorWithType:(DVAPhotoPickerManagerError)errorType andData:(NSDictionary*)userData;

@end
