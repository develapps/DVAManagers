//
//  DVAPhotoPickerPostProcessCompress.m
//  Pods
//
//  Created by Pablo Romeu on 27/11/15.
//
//

#import "DVAPhotoPickerPostProcessCompress.h"

@interface DVAPhotoPickerPostProcessCompress ()
@property (nonatomic) double compression;
@end

@implementation DVAPhotoPickerPostProcessCompress
+(instancetype)dva_actionWithCompresion:(double)compression{
    DVAPhotoPickerPostProcessCompress *compress = [DVAPhotoPickerPostProcessCompress new];
    compress.compression = compression;
    return compress;
}

-(UIImage *)dva_processPhoto:(UIImage *)photo{
    if (self.compression ==0) {
        return photo;
    }
    if (_debug) NSLog(@"Starting resize");
    NSData * imgData = UIImageJPEGRepresentation(photo,self.compression);
    if (_debug) NSLog(@"New Size: %lu",(unsigned long)[imgData length]);
    return [UIImage imageWithData:imgData];
    
}
@end
