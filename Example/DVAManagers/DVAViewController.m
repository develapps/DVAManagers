//
//  DVAViewController.m
//  DVAManagers
//
//  Created by Pablo Romeu on 11/27/2015.
//  Copyright (c) 2015 Pablo Romeu. All rights reserved.
//

#import "DVAViewController.h"
#import <DVAManagers/DVALocationManager.h>
#import <MapKit/MapKit.h>
@interface DVAViewController ()
@property (weak, nonatomic) IBOutlet MKMapView *map;
@end

@implementation DVAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[DVALocationManager sharedInstance] dva_requestLocation:^(NSArray<CLLocation *> *validLocations, NSError *error) {
        MKCoordinateRegion mapRegion;
        mapRegion.center = [validLocations lastObject].coordinate;
        mapRegion.span.latitudeDelta = 0.02;
        mapRegion.span.longitudeDelta = 0.02;
        
        [self.map setRegion:mapRegion animated: YES];
    }];

    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
