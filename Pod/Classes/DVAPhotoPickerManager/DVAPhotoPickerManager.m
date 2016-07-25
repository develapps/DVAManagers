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
#import "DVAPhotoPickerPostProcessAction.h"


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

+(instancetype)dva_showPhotoPickerOnViewController:(UIViewController *)controller
                                             withType:(DVAPhotoPickerManagerSourceType)type
                                  withCompletionBlock:(photoPickerCompletion)completion{
    if (![UIImagePickerController isSourceTypeAvailable:type==DVAPhotoPickerManagerSourceTypeCamera ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary]) {
        return nil;
    }
    
    DVAPhotoPickerManager* manager = [[DVAPhotoPickerManager alloc] initWithViewController:controller andCompletionBlock:completion];

    
    
    if (type==DVAPhotoPickerManagerSourceTypeAsk) {
        [manager dva_showActionSheetPhotoOptions];
    }
    else{
        [manager dva_presentPhotoPickerOnViewController:controller withType:type];
    }
    return manager;
}

-(void)dva_presentPhotoPickerOnViewController:(UIViewController *)controller
                                     withType:(DVAPhotoPickerManagerSourceType)type{
    if (![UIImagePickerController isSourceTypeAvailable:type==DVAPhotoPickerManagerSourceTypeCamera ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary]) {
        return;
    }
    self.sourceType = type;
    self.imagePicker = [self createImagePickerController];
    [controller presentViewController:self.imagePicker animated:YES completion:nil];
}



#pragma mark - Main methods


-(void)dva_showActionSheetPhotoOptions{
    NSAssert(self.viewController, @"No view controller configured");
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:[@"select_choice" dva_localizedStringForTable:@"PhotoPicker"
                                                                              inBundle:[NSBundle bundleForClass:[self class]]]
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* takePhoto = [UIAlertAction
                                actionWithTitle:[@"take_photo"  dva_localizedStringForTable:@"PhotoPicker"
                                                                                   inBundle:[NSBundle bundleForClass:[self class]]]
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    [self dva_presentPhotoPickerOnViewController:self.viewController
                                                                                         withType:DVAPhotoPickerManagerSourceTypeCamera];
                                    
                                }];
    
    
    UIAlertAction* gallery = [UIAlertAction
                              actionWithTitle:[@"gallery_action" dva_localizedStringForTable:@"PhotoPicker"
                                                                                    inBundle:[NSBundle bundleForClass:[self class]]]
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [self dva_presentPhotoPickerOnViewController:self.viewController
                                                                                       withType:DVAPhotoPickerManagerSourceTypePhotoLibrary];
                                  
                              }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:[@"cancel_button" dva_localizedStringForTable:@"PhotoPicker"
                                                                                  inBundle:[NSBundle bundleForClass:[self class]]]
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

    // This might be other media types
    self.imagePicker.mediaTypes = [NSArray arrayWithObjects:
                                   (NSString *) kUTTypeImage,
                                   nil];
    self.imagePicker.modalPresentationStyle = UIModalPresentationOverCurrentContext;

    if (self.sourceType==DVAPhotoPickerManagerSourceTypeCamera) {
        self.imagePicker.allowsEditing          = self.dva_allowsEditing;
        self.imagePicker.showsCameraControls    = self.dva_showsControlls;
    }
    return self.imagePicker;
}


#pragma mark - UIImagePickerController delegate methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    if (self.debug) NSLog(@"-- %s -- \n Picker did end taking media %@",__PRETTY_FUNCTION__,info);
    NSString * mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    UIImage *theFinalImage;
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage * image;
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        
        if (!image) {
            image = [info objectForKey:UIImagePickerControllerOriginalImage];
        }

        UIImage *processedImage = image;
        for (id<DVAPhotoPickerPostProcessAction>postProcessor in self.dva_postProcessActions) {
            if (self.debug) NSLog(@"-- %s -- \n Picker processing media with processor %@",__PRETTY_FUNCTION__,postProcessor);
            [postProcessor setDebug:self.debug];
            processedImage = [postProcessor dva_processPhoto:processedImage];
            if (!processedImage)
            {
                [picker dismissViewControllerAnimated:YES completion:^{
                    if (self.completionBlock) self.completionBlock(nil,[NSError dva_photoErrorWithType:DVALocationManagerErrorPostProcessFailed andData:@{kDVAPhotoPickerManagerErrorPostProcess:postProcessor}]);
                }];
                return;
            }
            
        }

        theFinalImage = [UIImage imageWithData:UIImageJPEGRepresentation(processedImage, 1.0)];
        if (self.dva_savesToPhotoAlbum) UIImageWriteToSavedPhotosAlbum(theFinalImage, nil, nil, nil);
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.completionBlock) self.completionBlock(theFinalImage,nil);
    }];
}


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (self.debug) NSLog(@"-- %s -- \n Picker did cancel taking media %@",__PRETTY_FUNCTION__,picker);
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.completionBlock)  self.completionBlock(nil,[NSError dva_photoErrorWithType:DVALocationManagerErrorCancelled]);
    }];
}


@end
