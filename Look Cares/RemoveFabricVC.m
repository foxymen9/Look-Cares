//
//  RemoveFabricVC.m
//  Look Cares
//
//  Created by Bendt Jensen on 06/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import "RemoveFabricVC.h"
#import "FabricSelectionVC.h"

@interface RemoveFabricVC ()
{
    BOOL isFirstImage, isSecondImage;
}
@end

@implementation RemoveFabricVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isFirstImage = false;
    isSecondImage = false;
    [self updateImageStatus];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)updateImageStatus {
    if (isFirstImage)
        [self.btnSelect1 setImage:[UIImage imageNamed:@"chb_rounded"] forState:UIControlStateNormal];
    else
        [self.btnSelect1 setImage:nil forState:UIControlStateNormal];
    if (isSecondImage)
        [self.btnSelect2 setImage:[UIImage imageNamed:@"chb_rounded"] forState:UIControlStateNormal];
    else
        [self.btnSelect2 setImage:nil forState:UIControlStateNormal];
}


- (IBAction)onBtnSelect1:(id)sender {
    isFirstImage = !isFirstImage;
    [self updateImageStatus];
}

- (IBAction)onBtnSelect2:(id)sender {
    isSecondImage = !isSecondImage;
    [self updateImageStatus];
}

- (IBAction)onBtnRemove:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    //    InStoreLocationSelectionVC *ilsvc = [storyboard instantiateViewControllerWithIdentifier:@"InStoreLocationSelectionVC"];
    //    [self.navigationController pushViewController:ilsvc animated:YES];
    
    FabricSelectionVC *fsvc = [storyboard instantiateViewControllerWithIdentifier:@"FabricSelectionVC"];
    [self.navigationController pushViewController:fsvc animated:YES];
}
@end
