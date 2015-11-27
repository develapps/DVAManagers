//
//  NSError+DVALocationManager.h
//  Pods
//
//  Created by Pablo Maria Romeu Guallart on 26/11/15.
//
//

#import <Foundation/Foundation.h>

static NSString *const kDVALocationManagerErrorDomain;
static NSString *const kDVALocationManagerAuthStatusKey;

typedef enum : NSUInteger {
    DVALocationManagerErrorGeneral              = 0,
    DVALocationManagerErrorLocationDisabled     = 1,
    DVALocationManagerErrorLocationDenied       = 2,
    DVALocationManagerErrorLocationRestricted   = 3,
    DVALocationManagerErrorAuthUnknown          = 4,
    DVALocationManagerErrorAuthBelowRequired    = 5,

} DVALocationManagerError;


@interface NSError (DVALocationManager)
+(NSError*)dva_errorWithType:(DVALocationManagerError)errorType;
+(NSError*)dva_errorWithType:(DVALocationManagerError)errorType andData:(NSDictionary*)userData;

@end
