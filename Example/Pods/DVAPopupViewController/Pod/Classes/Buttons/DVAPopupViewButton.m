//
//  DVAPopupViewButton
//  DVAPopupViewButton
//
//  Created by Pablo Romeu on 23/10/15.
//  Copyright © 2015 DVAPopupViewButton. All rights reserved.
//

#import "DVAPopupViewButton.h"

@interface DVAPopupViewButton ()
@end

@implementation DVAPopupViewButton


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addTarget:self action:@selector(buttonTouched) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


-(void)buttonTouched{
    if (_completionBlock) self.completionBlock();
}

@end
