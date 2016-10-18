//
//  NSError+DVAFacebookManager.h
//  Pods
//
//  Created by Pablo Romeu on 1/12/15.
//
//

#import <Foundation/Foundation.h>

static NSString *const kDVAFacebookManagerErrorDomain   = @"kDVAFacebookManagerErrorDomain";
static NSString *const kDVAFBKeyOriginalError   = @"kDVAFBKeyOriginalError";
static NSString *const kDVAFBKeyFailingPermission = @"kDVAFBKeyFailingPermission";
static NSString *const kDVAFBKeyResponseObject = @"kDVAFBKeyResponseObject";

typedef enum : NSUInteger {
    kDVAFBEErrorGeneral                         = 0,
    kDVAFBEErrorOperationCancelled              = 1,
    kDVAFBEMinimumPermissionsNotAcquired        = 2,
    kDVAFBENotSharedContent                     = 3,
    kDVAFBEErrorNoPermission                    = 4,
} DVAFacebookManagerError;

/*!
 @author Pablo Romeu, 15-12-01 13:12:48
 
 Extension for facebook manager errors
 
 @since 1.0.0
 */
@interface NSError (DVAFacebookManager)
+(NSError*)dva_facebookErrorWithType:(DVAFacebookManagerError)errorType;
+(NSError*)dva_facebookErrorWithType:(DVAFacebookManagerError)errorType andData:(NSDictionary*)userData;

@end
