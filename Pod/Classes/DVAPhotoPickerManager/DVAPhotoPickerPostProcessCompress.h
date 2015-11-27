//
//  DVAPhotoPickerPostProcessCompress.h
//  Pods
//
//  Created by Pablo Romeu on 27/11/15.
//
//

#import "DVAPhotoPickerPostProcessAction.h"

@interface DVAPhotoPickerPostProcessCompress : NSObject <DVAPhotoPickerPostProcessAction>
@property (nonatomic) BOOL debug;
+(instancetype)dva_actionWithCompresion:(double)compression;
@end
