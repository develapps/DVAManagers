//
//  DVAPhotoPickerPostProcessScale.h
//  Pods
//
//  Created by Pablo Romeu on 30/11/15.
//
//

#import "DVAPhotoPickerPostProcessAction.h"

@interface DVAPhotoPickerPostProcessScale : NSObject <DVAPhotoPickerPostProcessAction>
@property (nonatomic) BOOL debug;
+(instancetype)dva_actionWithScale:(double)scale;
@end
