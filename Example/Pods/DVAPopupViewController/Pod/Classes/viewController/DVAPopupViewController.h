//
//  DVAPopupViewController
//  DVAPopupViewController
//
//  Created by Pablo Romeu on 23/10/15.
//  Copyright © 2015 DVAPopupViewButton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DVAPopupViewConfigurator.h"
/*!
 @author Pablo Romeu, 15-11-25 11:11:40
 
 This view controller can show a view with some views inside properly setup.
 
 ## Structure

 The structure of the view is this:
 
 DVAPopupViewController --> View --> containerView --> stackView --> (Your views)
 
 ## Configuration
 
 This view has to be configured with a `DVAPopupViewConfigurator` object. This way, the configuration is set in the correct order. 
 
 ## Examples
 
    - Simple alert:
 
        DVAPopupViewController *controller = [DVAPopupViewController dva_alertWithText:@"This a simple alert"] ;
        [self presentViewController:controller animated:YES completion:nil];
 
    - A loading view with cancel button:
 
        DVAPopupViewController *controller = [DVAPopupViewController 
                                                dva_loadingSpinnerAlertWithText:@"Loading"
                                                                      andButton:[DVAPopupViewButton dva_buttonWithText:@"Cancel"]
                                                                      withBlock:^(DVAPopupViewButton *button) {
                [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
            }]];
 
        [self presentViewController:controller animated:YES completion:nil];

    - A full-screen-blurred blocking view:
 
        UILabel *title = [UILabel dva_titleLabelWithText:@"Alert title"];
        UILabel *body = [UILabel dva_bodyLabelWithText:@"This is a big blocking alert view"];
 
        DVAPopupViewConfigurator *configurator = [DVAPopupViewConfigurator dva_configuratorRoundedCornersDarkBlurAndViews:@[title,image,body]];
        DVAPopupViewController *controller = [DVAPopupViewController controllerWithConfigurator:configurator];
        [self presentViewController:controller animated:YES completion:nil];

 
 See the example project for more examples
 
 @since 1.1.0
 @see DVAPopupViewConfigurator
 */
@interface DVAPopupViewController : UIViewController
@property (nonatomic,strong)    UIView                  *containerView;
@property (nonatomic,strong)    UIStackView             *stackView;

-(instancetype)initWithConfigurator:(DVAPopupViewConfigurator*)configurator;
+(instancetype)controllerWithConfigurator:(DVAPopupViewConfigurator*)configurator;
-(void)setupWithConfigurator:(DVAPopupViewConfigurator*)configurator;
@end
