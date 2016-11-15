//
//  FabricSelectionVC.m
//  Look Cares
//
//  Created by Fox Man on 06/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import "FabricSelectionVC.h"
#import "TakePictureVC.h"

@interface FabricSelectionVC ()

@end

@implementation FabricSelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.viewCodeReader setHidden:NO];
    [self.viewTextInput setHidden:YES];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleTapSubView:)];
    [self.viewTextInput addGestureRecognizer:singleTap];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleTapSubView:(UITapGestureRecognizer *)tap {
    [self.txtSerialNumber resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)segBtnTapped:(id)sender {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self.viewCodeReader setHidden:NO];
        [self.viewTextInput setHidden:YES];
        [self.btnCodeReader setImage:[UIImage imageNamed:@"icon_barcode"] forState:UIControlStateNormal];
        
    }
    else if (self.segmentedControl.selectedSegmentIndex == 1) {
        [self.viewCodeReader setHidden:NO];
        [self.viewTextInput setHidden:YES];
        [self.btnCodeReader setImage:[UIImage imageNamed:@"icon_barcode"] forState:UIControlStateNormal];
    }
    else if (self.segmentedControl.selectedSegmentIndex == 2) {
        [self.viewCodeReader setHidden:YES];
        [self.viewTextInput setHidden:NO];
    }
}

- (IBAction)onBtnCodeReader:(id)sender {
}

- (IBAction)onBtnDone:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TakePictureVC *ilsvc = [storyboard instantiateViewControllerWithIdentifier:@"TakePictureVC"];
    [self.navigationController pushViewController:ilsvc animated:YES];  
}

@end
