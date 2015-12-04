//
//  DVAPopupViewController
//  DVAPopupViewController
//
//  Created by Pablo Romeu on 23/10/15.
//  Copyright © 2015 DVAPopupViewButton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVAPopupViewConfigurator.h"

@interface DVAPopupViewController : UIViewController
@property (nonatomic,strong)    UIView                  *containerView;
@property (nonatomic,strong)    UIStackView             *stackView;

-(instancetype)initWithConfigurator:(DVAPopupViewConfigurator*)configurator;
+(instancetype)controllerWithConfigurator:(DVAPopupViewConfigurator*)configurator;
-(void)setupWithConfigurator:(DVAPopupViewConfigurator*)configurator;
@end
