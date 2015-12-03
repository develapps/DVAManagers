//
//  NSError+DVAPhotoPickerManager.m
//  Pods
//
//  Created by Pablo Romeu on 27/11/15.
//
//

#import "NSError+DVAPhotoPickerManager.h"

static NSString *const kDVAPhotoPickerManagerErrorDomain        = @"kDVAPhotoPickerManagerErrorDomain";
static NSString *const kDVAPhotoPickerManagerErrorPostProcess   = @"kDVAPhotoPickerManagerErrorPostProcess";

@implementation NSError (DVAPhotoPickerManager)

+(NSError*)dva_photoErrorWithType:(DVAPhotoPickerManagerError)errorType{
    return [NSError dva_photoErrorWithType:errorType andData:nil];
}


+(NSError*)dva_photoErrorWithType:(DVAPhotoPickerManagerError)errorType
                          andData:(NSDictionary *)userData{
    return [NSError errorWithDomain:kDVAPhotoPickerManagerErrorDomain code:errorType userInfo:userData];
}
@end