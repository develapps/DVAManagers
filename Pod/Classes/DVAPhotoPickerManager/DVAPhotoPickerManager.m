//
//  DVAPhotoPickerManager.m
//  Pods
//
//  Created by Pablo Romeu on 24/11/15.
//
//

#import "DVAPhotoPickerManager.h"

static inline double radians (double degrees) {return degrees * M_PI/180;}

@interface DVAPhotoPickerManager() <UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong)   UIImage *imageSelected;
@property (nonatomic, strong)   UIView  *view;
@property (nonatomic, strong)   UIImagePickerController *imagePicker;
@property (nonatomic)           BOOL                    usingCamera;

@end

@implementation DVAPhotoPickerManager

- (instancetype)init {
    if (self = [super init]) {
        _allowsEditing = YES;
    }
    
    return self;
}

#pragma mark - Set helper

- (void) setDataToHandlerWithView:(UIView *) view {
    self.view = view;
}

#pragma mark - UIImagePickerController delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage * image;
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        if (!image) {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }
        
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
        UIImage *jpgImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 1.0)];
        
        self.imageSelected = jpgImage;
        
        UIImageWriteToSavedPhotosAlbum(self.imageSelected, nil, nil, nil);
        
        [self.delegate pickerManagerImageSelected:self.imageSelected];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

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

-(UIImage *)compraseImage:(UIImage *)largeImage {
    double compressionRatio = 1;
    int resizeAttempts = 5;
    
    NSData * imgData = UIImageJPEGRepresentation(largeImage,compressionRatio);
    
    NSLog(@"Starting Size: %lu", (unsigned long)[imgData length]);
    
    //Trying to push it below around about 0.4 meg
    while ([imgData length] > 124000 && resizeAttempts > 0) {
        resizeAttempts -= 1;
        
        NSLog(@"Image was bigger than 400000 Bytes. Resizing.");
        NSLog(@"%i Attempts Remaining",resizeAttempts);
        
        //Increase the compression amount
        compressionRatio = compressionRatio*0.5;
        NSLog(@"compressionRatio %f",compressionRatio);
        //Test size before compression
        NSLog(@"Current Size: %lu",(unsigned long)[imgData length]);
        imgData = UIImageJPEGRepresentation(largeImage,compressionRatio);
        
        //Test size after compression
        NSLog(@"New Size: %lu",(unsigned long)[imgData length]);
    }
    
    return [UIImage imageWithData:imgData];
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        
    }
}

//Cancel
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}



/* Method to create a UIImagePickerController (for Camera o PhotoLibrary) */
- (UIImagePickerController *) createImagePickerControllerWithTypeCamera:(BOOL) typeCamera AndAllowsEditing: (BOOL) allowsEditing {
    self.usingCamera = typeCamera;
    self.imagePicker = [[UIImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.sourceType = typeCamera ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
    self.imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                   (NSString *) kUTTypeImage,
                                   nil];
    self.imagePicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    
    self.imagePicker.allowsEditing = allowsEditing;
    
    return self.imagePicker;
}

- (void) useCamera {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *imagePicker = [self createImagePickerControllerWithTypeCamera:YES AndAllowsEditing:self.allowsEditing];
        
        [self.delegate pickerManagerPresentSelectPictureViewController:imagePicker WithAnimation:YES];
    }
}

- (void) useCameraRoll {
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeSavedPhotosAlbum]){
        UIImagePickerController *imagePicker = [self createImagePickerControllerWithTypeCamera:NO AndAllowsEditing:self.allowsEditing];
        
        [self.delegate pickerManagerPresentSelectPictureViewController:imagePicker WithAnimation:YES];
    }
}

- (void) showActionSheetPhotoOptionsInController:(UIViewController *)controller {
//    
//    UIAlertController * view=   [UIAlertController
//                                 alertControllerWithTitle:nil
//                                 message:[self.language languageSelectedStringForKey:@"select_choice"]
//                                 preferredStyle:UIAlertControllerStyleActionSheet];
//    
//    UIAlertAction* takePhoto = [UIAlertAction
//                                actionWithTitle:[self.language languageSelectedStringForKey:@"take_photo"]
//                                style:UIAlertActionStyleDefault
//                                handler:^(UIAlertAction * action)
//                                {
//                                    [self useCamera];
//                                    
//                                    
//                                }];
//    
//    
//    UIAlertAction* gallery = [UIAlertAction
//                              actionWithTitle:[self.language languageSelectedStringForKey:@"gallery_action"]
//                              style:UIAlertActionStyleDefault
//                              handler:^(UIAlertAction * action)
//                              {
//                                  [self useCameraRoll];
//                                  
//                              }];
//    
//    UIAlertAction* cancel = [UIAlertAction
//                             actionWithTitle:[self.language languageSelectedStringForKey:@"cancel_button"]
//                             style:UIAlertActionStyleCancel
//                             handler:^(UIAlertAction * action)
//                             {
//                                 [view dismissViewControllerAnimated:YES completion:nil];
//                                 
//                             }];
//    
//    
//    
//    [view addAction:takePhoto];
//    [view addAction:gallery];
//    [view addAction:cancel];
//    
//    [controller presentViewController:view animated:YES completion:nil];
//    
    
}


@end
