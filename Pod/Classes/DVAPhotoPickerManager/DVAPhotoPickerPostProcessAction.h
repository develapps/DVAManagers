//
//  DVAPhotoPickerPostProcessAction.h
//  Pods
//
//  Created by Pablo Romeu on 27/11/15.
//
//

#import <UIKit/UIKit.h>

@protocol DVAPhotoPickerPostProcessAction <NSObject>
-(UIImage*)dva_processPhoto:(UIImage*)photo;
@property (nonatomic) BOOL debug;

@end
