//
//  InStoreLocationSelectionVC.h
//  Look Cares
//
//  Created by Bendt Jensen on 05/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InStoreLocationSelectionVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewPopup;
- (IBAction)onBtnCancel:(id)sender;
- (IBAction)onBtnSelectPopup:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)onBtnSelectLocation:(id)sender;
- (IBAction)onSelect:(id)sender;

@end
