//
//  DVAPopupViewButton
//  DVAPopupViewButton
//
//  Created by Pablo Romeu on 23/10/15.
//  Copyright © 2015 DVAPopupViewButton. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DVAPopupViewButton : UIButton
@property (nonatomic, copy) void (^completionBlock)();
@end
