//
//  RemoveFabricSingleVC.h
//  Look Cares
//
//  Created by Denis Ratkov on 2/5/17.
//  Copyright © 2017 The Lookup Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RemoveFabricSingleVC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *img1;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect1;
- (IBAction)onBtnSelect1:(id)sender;
- (IBAction)onBtnRemove:(id)sender;
- (IBAction)onBtnBack:(id)sender;

@end
