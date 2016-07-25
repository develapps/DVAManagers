//
//  DVAPhotoPickerTableViewController.m
//  DVAManagers
//
//  Created by Pablo Romeu on 30/11/15.
//  Copyright © 2015 Pablo Romeu. All rights reserved.
//

#import "DVAPhotoPickerTableViewController.h"
#import <DVAManagers/DVAPhotoPickerManager.h>
#import <DVAManagers/DVAPhotoPickerPostProcessCompress.h>
#import <DVAManagers/DVAPhotoPickerPostProcessScale.h>
#import <DVAManagers/DVAPhotoPickerPostProcessRotate.h>
#import <DVAPopupViewController/DVAPopupViewController+BasicAlerts.h>

@interface DVAPhotoPickerTableViewController ()
@property (weak, nonatomic) IBOutlet UISegmentedControl *dva_originSelector;
@property (weak, nonatomic) IBOutlet UISwitch *dva_editSwith;
@property (weak, nonatomic) IBOutlet UISwitch *dva_showControlsSwitch;

@property (weak, nonatomic) IBOutlet UILabel *dva_compressLabel;

@property (weak, nonatomic) IBOutlet UISlider *dva_resizeSlidere;
@property (weak, nonatomic) IBOutlet UISlider *dva_compressSlider;

@property (weak, nonatomic) IBOutlet UILabel *dva_resizeLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *dva_RotateSelector;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UISwitch *dva_saveToPhotoAlbumSwitch;
@property (strong, nonatomic) DVAPhotoPickerManager *manager;


@end

@implementation DVAPhotoPickerTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)compressValueDidChange:(id)sender {
    [self.dva_compressLabel setText:[NSString stringWithFormat:@"%.1f",self.dva_compressSlider.value]];
    [self.dva_resizeLabel setText:[NSString stringWithFormat:@"%.1f",self.dva_resizeSlidere.value]];

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.dva_originSelector selectedSegmentIndex]!=0) {
        switch ([self.dva_originSelector selectedSegmentIndex]) {
            case 0: // Select
            {
                self.manager = [DVAPhotoPickerManager dva_showPhotoPickerOnViewController:self
                                                                                 withType:DVAPhotoPickerManagerSourceTypeAsk withCompletionBlock:^(UIImage *image, NSError *error) {
                                                                                     if (error) {
                                                                                         [DVAPopupViewController dva_alertWithText:[error localizedDescription]];
                                                                                         return ;
                                                                                     }
                                                                                     [self.imageView setImage:image];
                                                                                 }];
            }
                break;

            case 1: // CAmera
            {
                self.manager = [DVAPhotoPickerManager dva_showPhotoPickerOnViewController:self
                                                                                 withType:DVAPhotoPickerManagerSourceTypeCamera withCompletionBlock:^(UIImage *image, NSError *error) {
                                                                                     if (error) {
                                                                                         [DVAPopupViewController dva_alertWithText:[error localizedDescription]];
                                                                                         return ;
                                                                                     }
                                                                                     [self.imageView setImage:image];
                                                                                 }];
            }
                break;
            case 2: // Saved
            {
                self.manager = [DVAPhotoPickerManager dva_showPhotoPickerOnViewController:self
                                                                                 withType:DVAPhotoPickerManagerSourceTypePhotoLibrary withCompletionBlock:^(UIImage *image, NSError *error) {
                                                                                     if (error) {
                                                                                         [DVAPopupViewController dva_alertWithText:[error localizedDescription]];
                        return ;
                    }
                    [self.imageView setImage:image];
                }];
            }
                break;
            default:
                break;
        }
    }
    else{
        [self showCustomPicker];
    }
}

-(void)showCustomPicker{
    self.manager = [[DVAPhotoPickerManager alloc] initWithViewController:self andCompletionBlock:^(UIImage *image, NSError *error) {
        if (error) {
            [DVAPopupViewController dva_alertWithText:[error localizedDescription]];
            return ;
        }
        [self.imageView setImage:image];
    }];
    self.manager.debug = YES;
    self.manager.dva_allowsEditing = [self.dva_editSwith isOn];
    self.manager.dva_savesToPhotoAlbum = [self.dva_saveToPhotoAlbumSwitch isOn];
    self.manager.dva_showsControlls = [self.dva_showControlsSwitch isOn];
    NSMutableArray *newArray = [NSMutableArray new];
    if (self.dva_compressSlider.value != 1.0) {
        [newArray addObject:[DVAPhotoPickerPostProcessCompress dva_actionWithCompresion:[self.dva_compressSlider value]]];
    }
    if ([self.dva_RotateSelector selectedSegmentIndex]!=0){
            [newArray addObject:[DVAPhotoPickerPostProcessRotate dva_actionWithFixRotation]];
    }
    if (self.dva_resizeSlidere.value != 1.0) {
        [newArray addObject:[DVAPhotoPickerPostProcessScale dva_actionWithScale:[self.dva_resizeSlidere value]]];
    }

    [self.manager setDva_postProcessActions:newArray];
    [self.manager dva_showActionSheetPhotoOptions];

}



@end
