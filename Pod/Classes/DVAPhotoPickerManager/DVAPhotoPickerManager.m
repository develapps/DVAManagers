//
//  DVAPhotoPickerManager.m
//  Pods
//
//  Created by Pablo Romeu on 24/11/15.
//
//

#import "DVAPhotoPickerManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <DVACategories/NSString+DVALocalized.h>

static inline double radians (double degrees) {return degrees * M_PI/180;}

@interface DVAPhotoPickerManager() <UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

@property (nonatomic,weak)      UIViewController                *viewController;
@property (nonatomic)           DVAPhotoPickerManagerSourceType sourceType;
@property (nonatomic, strong)   UIImagePickerController         *imagePicker;
@property (nonatomic, copy)     photoPickerCompletion           completionBlock;

@end

@implementation DVAPhotoPickerManager

-(instancetype)initWithViewController:(UIViewController*)controller andCompletionBlock:(photoPickerCompletion)completion
{
    self = [super init];
    if (self) {
        _dva_allowsEditing      = NO;
        _dva_showsControlls     = YES;
        _completionBlock        = completion;
        _viewController         = controller;
    }
    return self;
}

+(void)dva_presentPhotoPickerOnViewController:(UIViewController *)controller
                                             withType:(DVAPhotoPickerManagerSourceType)type
                                  withCompletionBlock:(photoPickerCompletion)completion{
    DVAPhotoPickerManager*manager = [[DVAPhotoPickerManager alloc] initWithViewController:controller andCompletionBlock:completion];
    manager.sourceType = type;
    manager.imagePicker = [manager createImagePickerController];
    [controller presentViewController:manager.imagePicker animated:YES completion:nil];
}

#pragma mark - Main methods


-(void)dva_showActionSheetPhotoOptions{
    NSAssert(self.viewController, @"No view controller configured");
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:[@"select_choice" dva_localizedString]
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* takePhoto = [UIAlertAction
                                actionWithTitle:[@"take_photo"  dva_localizedString]
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [DVAPhotoPickerManager dva_presentPhotoPickerOnViewController:self.viewController
                                                                                         withType:DVAPhotoPickerManagerSourceTypeCamera
                                                                              withCompletionBlock:self.completionBlock];
                                    
                                }];
    
    
    UIAlertAction* gallery = [UIAlertAction
                              actionWithTitle:[@"gallery_action" dva_localizedString]
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [DVAPhotoPickerManager dva_presentPhotoPickerOnViewController:self.viewController
                                                                                       withType:DVAPhotoPickerManagerSourceTypePhotoLibrary
                                                                            withCompletionBlock:self.completionBlock];
                                  
                              }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:[@"cancel_button" dva_localizedString]
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                                 
                             }];
    
    
    
    [view addAction:takePhoto];
    [view addAction:gallery];
    [view addAction:cancel];
    
    [self.viewController presentViewController:view animated:YES completion:nil];
    
}

#pragma mark - Helper

- (UIImagePickerController *)createImagePickerController{
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = self.sourceType==DVAPhotoPickerManagerSourceTypeCamera ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                   (NSString *) kUTTypeImage,
                                   nil];
    self.imagePicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    self.imagePicker.allowsEditing          = self.dva_allowsEditing;
    self.imagePicker.showsCameraControls    = self.dva_showsControlls;
    return self.imagePicker;
}

#pragma mark - PostProcessing options

UIImage* rotate(UIImage* src, UIImageOrientation orientation)
{
    UIGraphicsBeginImageContext(src.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if (orientation == UIImageOrientationRight) {
        CGContextRotateCTM (context, radians(90));
    } else if (orientation == UIImageOrientationLeft) {
        CGContextRotateCTM (context, radians(-90));
    } else if (orientation == UIImageOrientationDown) {
        // NOTHING
    } else if (orientation == UIImageOrientationUp) {
        CGContextRotateCTM (context, radians(90));
    }
    
    [src drawAtPoint:CGPointMake(0, 0)];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



#pragma mark - UIImagePickerController delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *theImage;
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage * image;
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        if (!image) {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
#warning transformations
        
        //        if (image.imageOrientation != UIImageOrientationUp) {
        //            image = [image fixOrientation];
        //        }
        //
        //        //__ Fix orientation in the image (only in camera)
        //        if (self.usingCamera) {
        //            image = [image fixOrientation];
        //        }
        
        //__ Reduce image to screen size
        //        CGSize screenSize=[[UIScreen mainScreen] bounds].size;
        //        CGSize reducedSize;
        //        if (image.size.width>image.size.height) {
        //            reducedSize=CGSizeMake(screenSize.width, screenSize.width*image.size.height/image.size.width);
        //        }
        //        else{
        //            reducedSize=CGSizeMake(screenSize.height*image.size.width/image.size.height, screenSize.height);
        //        }
        //        image = [UIImage imageWithImage:image scaledToSize:reducedSize];
        
        
        //----------------------//
        //__ Transform the png into jpg image
        theImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 1.0)];
        if (self.dva_savesToPhotoAlbum) UIImageWriteToSavedPhotosAlbum(theImage, nil, nil, nil);
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.completionBlock) self.completionBlock(theImage,nil);
    }];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.completionBlock)  self.completionBlock(nil,[NSError dva_photoErrorWithType:DVALocationManagerErrorCancelled]);
    }];
}



@end
