//
//  DVAPhotoPickerPostProcessRotate.h
//  Pods
//
//  Created by Pablo Romeu on 30/11/15.
//
//

#import "DVAPhotoPickerPostProcessAction.h"

@interface DVAPhotoPickerPostProcessRotate : NSObject<DVAPhotoPickerPostProcessAction>
@property (nonatomic) BOOL debug;
+(instancetype)dva_actionWithFixRotation;
@end
