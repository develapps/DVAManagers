//
//  DVAViewController.m
//  DVAManagers
//
//  Created by Pablo Romeu on 11/27/2015.
//  Copyright (c) 2015 Pablo Romeu. All rights reserved.
//

#import "DVAViewController.h"
#import <DVAManagers/DVALocationManager.h>
@interface DVAViewController ()

@end

@implementation DVAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    if ([[DVALocationManager sharedInstance] dva_currentAuthStatus] < [[DVALocationManager sharedInstance] dva_LocationAuthType]) [[DVALocationManager sharedInstance] dva_requestLocation:^(NSArray<CLLocation *> *validLocations, NSError *error) {
        ;
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
