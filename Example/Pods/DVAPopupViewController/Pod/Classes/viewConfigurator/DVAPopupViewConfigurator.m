//
//  DVAPopupViewConfigurator.m
//  Pods
//
//  Created by Pablo Romeu on 20/11/15.
//
//

#import "DVAPopupViewConfigurator.h"

@implementation DVAPopupViewConfigurator
-(NSString *)description{
    return [NSString stringWithFormat:@"%@ \r Dismissable: %u\r containerView%@\r spacing%f\r background%lu\r containerMode%lu\r",[super description],_dismissable,_containerView,_spacing,(unsigned long)_background,(unsigned long)_containerMode];
}
@end
