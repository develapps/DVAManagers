//
//  DVAPhotoPickerPostProcessScale.m
//  Pods
//
//  Created by Pablo Romeu on 30/11/15.
//
//

#import "DVAPhotoPickerPostProcessScale.h"
@interface DVAPhotoPickerPostProcessScale ()
@property (nonatomic) double scale;
@end

@implementation DVAPhotoPickerPostProcessScale

+(instancetype)dva_actionWithScale:(double)scale{
    DVAPhotoPickerPostProcessScale *scaleAction = [DVAPhotoPickerPostProcessScale new];
    scaleAction.scale = scale;
    return scaleAction;
}

-(UIImage *)dva_processPhoto:(UIImage *)photo{
    if (self.scale ==1) {
        return photo;
    }
    if (_debug) NSLog(@"Starting scale of image %@",photo);
    
    CGSize size = CGSizeMake(photo.size.width*self.scale, photo.size.height*self.scale);
    return [self imageWithImage:photo scaledToSize:size];
    
}

-(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)size {

    // Comenzamos un contexto gráfico  (UIKit). El primer parámetro marca el tamaño que
    // tendrá dicho contexto. Segundo parámetro BOOL indica si el contenido es o no opaco.
    // El tercer parámetro nos permite definir la escala. Si en este último, indicamos 0,
    // se aplicará la escala correspondiente a la resolución de nuestro dispositivo (retina o no).
    // Si indicamos 1, se aplicará el tamaño exacto indicado en el primer parámetro.
    UIGraphicsBeginImageContextWithOptions(size, NO, 1.0);

    // Dibujamos la imagen en el tamaño deseado dentro del contexto actual
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];

    // Recuperamos el contenido generado en el contexto y lo almacenamos
    // en una nueva UIImage
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();

    // Finalizamos el contexto gráfico
    UIGraphicsEndImageContext();

    // Devolvemos como parámetro la UIImage reescalada.
    if (_debug) NSLog(@"Scaled image %@",scaledImage);
    return scaledImage;

}
@end
