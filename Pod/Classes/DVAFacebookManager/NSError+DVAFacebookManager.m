//
//  NSError+DVAFacebookManager.m
//  Pods
//
//  Created by Pablo Romeu on 1/12/15.
//
//

#import "NSError+DVAFacebookManager.h"

static NSString *const kDVAFacebookManagerErrorDomain   = @"kDVAFacebookManagerErrorDomain";
static NSString *const kDVAFBKeyOriginalError   = @"kDVAFBKeyOriginalError";
static NSString *const kDVAFBKeyFailingPermission = @"kDVAFBKeyFailingPermission";
static NSString *const kDVAFBKeyResponseObject = @"kDVAFBKeyResponseObject";
@implementation NSError (DVAPhotoPickerManager)

+(NSError*)dva_facebookErrorWithType:(DVAFacebookManagerError)errorType{
    return [NSError dva_facebookErrorWithType:errorType andData:nil];
}

+(NSError*)dva_facebookErrorWithType:(DVAFacebookManagerError)errorType
                             andData:(NSDictionary *)userData{
    return [NSError errorWithDomain:kDVAFacebookManagerErrorDomain code:errorType userInfo:userData];
}
@end