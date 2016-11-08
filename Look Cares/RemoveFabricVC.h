//
//  RemoveFabricVC.h
//  Look Cares
//
//  Created by Fox Man on 06/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemoveFabricVC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIImageView *img2;

@property (weak, nonatomic) IBOutlet UIButton *btnSelect1;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect2;

- (IBAction)onBtnSelect1:(id)sender;
- (IBAction)onBtnSelect2:(id)sender;
- (IBAction)onBtnRemove:(id)sender;

@end
