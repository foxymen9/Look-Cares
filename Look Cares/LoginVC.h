//
//  ViewController.h
//  Look Cares
//
//  Created by Bendt Jensen on 04/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"

@interface LoginVC : UIViewController

- (IBAction)onBtnCheck:(id)sender;
- (IBAction)onBtnLogin:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtPassword;
@property (weak, nonatomic) IBOutlet UIImageView *imgTick;
@property (weak, nonatomic) IBOutlet UIView *viewSub;

@end

