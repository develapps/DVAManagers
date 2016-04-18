//
//  NSError+DVALocationManager.m
//  Pods
//
//  Created by Pablo Maria Romeu Guallart on 26/11/15.
//
//

#import "NSError+DVALocationManager.h"


@implementation NSError (DVALocationManager)

+(NSError*)dva_locationErrorWithType:(DVALocationManagerError)errorType{
    return [NSError dva_locationErrorWithType:errorType andData:nil];
}


+(NSError*)dva_locationErrorWithType:(DVALocationManagerError)errorType
                     andData:(NSDictionary*)userData{
    return [NSError errorWithDomain:kDVALocationManagerErrorDomain code:errorType userInfo:userData];
}
@end
