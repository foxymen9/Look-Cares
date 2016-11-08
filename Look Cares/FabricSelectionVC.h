//
//  FabricSelectionVC.h
//  Look Cares
//
//  Created by Fox Man on 06/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FabricSelectionVC : UIViewController

@property (weak, nonatomic) IBOutlet UIView *viewTextInput;
@property (weak, nonatomic) IBOutlet UIView *viewCodeReader;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
- (IBAction)segBtnTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtSerialNumber;

@property (weak, nonatomic) IBOutlet UIButton *btnCodeReader;
- (IBAction)onBtnCodeReader:(id)sender;

- (IBAction)onBtnDone:(id)sender;
@end
