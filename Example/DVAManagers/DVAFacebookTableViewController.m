//
//  DVAFacebookTableViewController.m
//  DVAManagers
//
//  Created by Pablo Romeu on 4/12/15.
//  Copyright © 2015 Pablo Romeu. All rights reserved.
//

#import "DVAFacebookTableViewController.h"
#import <DVAManagers/DVAFacebookManager.h>
#import <DVAPopupViewController/DVAPopupViewController+BasicAlerts.h>
#import <DVAPopupViewController/DVAPopupViewController+BasicLoading.h>
#import <DVAPopupViewController/DVAPopupViewConfigurator+PredefinedConfigurators.h>
#import <DVAPopupViewController/UILabel+AlertLabels.h>
#import <DVAPopupViewController/DVAPopupViewButton+BasicButtons.h>

@interface DVAFacebookTableViewController ()

@end

@implementation DVAFacebookTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[DVAFacebookManager shared] setDebug:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DVAPopupViewController *loading = [DVAPopupViewController dva_loadingSpinnerAlertWithText:@"Calling facebook..."];
    loading.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:loading animated:YES completion:^{
        [self makeCallWithIndexPath:indexPath];
    }];
   
    
}
-(void)makeCallWithIndexPath:(NSIndexPath*)indexPath{
    DVAFacebookManagerCompletionBlock completion = ^(id userData, NSError *error, BOOL cachedData){
        [self dismissViewControllerAnimated:YES completion:^{
            UITextView *tv = [UITextView new];
            tv.editable = NO;
            tv.showsHorizontalScrollIndicator = NO;
            tv.text = error?[error description]:[userData description];
            NSArray*constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[tv(>=400)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(tv)];
            
            [tv addConstraints:constraints];
            DVAPopupViewConfigurator *configurator = [DVAPopupViewConfigurator dva_configuratorRoundedCornersAndViews:@[
                                                                                                                                [UILabel dva_titleLabelWithText:(error?@"ERROR":@"SUCCESS")],
                                                                                                                                tv,
                                                                                                                                [DVAPopupViewButton dva_buttonWithText:@"OK" withBlock:^(DVAPopupViewButton *button) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }]]];
            DVAPopupViewController*controller = [DVAPopupViewController controllerWithConfigurator:configurator];
            controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:controller animated:YES completion:nil];
        }];
    };
    DVAFacebookManagerSuccessBlock success = ^(BOOL success, NSError *error){
        [self dismissViewControllerAnimated:YES completion:^{
            
            DVAPopupViewController*controller = [DVAPopupViewController dva_alertWithTitle:(!success?@"ERROR":@"SUCCESS")
                                                                                   andBody:success?@"Did it!":[error description] buttonsText:@[@"OK"] andBlock:^(DVAPopupViewButton *buttonPressed) {
                                                                                       [self dismissViewControllerAnimated:YES completion:nil];
                                                                                   }];
            controller.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:controller animated:YES completion:nil];
        }];
    };
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0: // Login
                [[DVAFacebookManager shared] dva_loginWithCompletionBlock:success];
                break;
            case 1: // Userinfo
                [[DVAFacebookManager shared] dva_userInfo:@[kDVAFBManagerFacebookName,kDVAFBManagerFacebookLastName] withCompletionBlock:completion];
                break;
            case 2: // Extra perms
                [[DVAFacebookManager shared] dva_askForExtraPermissions:@[kDVAFBManagerFacebookPhotos]
                                                    withCompletionBlock:success];
                break;
            case 3: // Logout
                [[DVAFacebookManager shared] dva_logout];
                success(YES,nil);
                break;
                
            default:
                break;
        }
    }
    else if (indexPath.section == 1){
        switch (indexPath.row) {
            case 0: // User Picture
            {
                [[DVAFacebookManager shared] dva_userInfo:@[kDVAFBManagerFacebookObjectId] withCompletionBlock:^(id userData, NSError *error, BOOL cachedData) {
                    if (error) {
                        completion(userData,error,cachedData);
                        return ;
                    };
                    [[DVAFacebookManager shared] dva_pictureForUserId:[userData objectForKey:kDVAFBManagerFacebookObjectId]
                                                       withCompletion:completion];
                }];
            }
                break;
            case 1: // User Albums
                [[DVAFacebookManager shared] dva_albumsWithCompletionBlock:completion];
                break;
            case 2: // Profile Albums pictures
                [[DVAFacebookManager shared] dva_picturesFromProfileAlbumWithCompletionBlock:completion];
                break;
            case 3: // Other Albums pictures
                [[DVAFacebookManager shared] dva_albumsWithCompletionBlock:completion];
                break;
            case 4: // User friends
                [[DVAFacebookManager shared] dva_friendsWithCompletionBlock:completion];
                break;
                
                
            default:
                break;
        }
    }
    else{
        // Custom call
        [[DVAFacebookManager shared] dva_userInfo:@[kDVAFBManagerFacebookObjectId] withCompletionBlock:^(id userData, NSError *error, BOOL cachedData) {
            if (error) {
                completion(userData,error,cachedData);
                return ;
            };
            NSDictionary *params = @{kDVAFBManagerFacebookType      : kDVAFBManagerFacebookImageTypeNormal,
                                     kDVAFBManagerFacebookFields    : [@[kDVAFBManagerFacebookData,kDVAFBManagerFacebookUrl] componentsJoinedByString:@","]}; /* enum{thumbnail,small,album} */

            [[DVAFacebookManager shared] dva_requestWithGraphPath:[NSString stringWithFormat:kDVAFBManagerFacebookGraphMePicture,[userData objectForKey:kDVAFBManagerFacebookObjectId]]
                             andParameters:params
                        andCompletionBlock:completion];
        }];
    }
}


@end
