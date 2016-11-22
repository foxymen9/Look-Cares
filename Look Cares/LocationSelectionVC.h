//
//  LocationSelectionVC.h
//  Look Cares
//
//  Created by Fox Man on 05/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationSelectionVC : UIViewController

- (IBAction)onBtnClient:(id)sender;
- (IBAction)onBtnLocation:(id)sender;
- (IBAction)onBtnSelect:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *viewPopup;
- (IBAction)onBtnCancel:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)onBtnSelectPopup:(id)sender;
- (IBAction)onBtnBack:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblClient;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;

@end
