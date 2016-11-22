//
//  RemoveFabricVC.m
//  Look Cares
//
//  Created by Fox Man on 06/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import "RemoveFabricVC.h"
#import "FabricSelectionVC.h"
#import "FrameSelectionVC.h"
#import "MBProgressHUD.h"
#import "Global.h"
#import "WebConnector.h"

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
    if ([Global sharedInstance].fabrics.count > 0)
    {
        NSString *imgUrl = [[[Global sharedInstance].fabrics objectAtIndex:0] objectForKey:@"vcFileName"];
        NSURL *url = [NSURL URLWithString:imgUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        self.img1.image = image;
//        dispatch_async(dispatch_get_global_queue(0,0), ^{
//            NSData * data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imgUrl]];
//            if ( data == nil )
//                return;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // WARNING: is the cell still using the same data by this point??
//                self.img1.image = [UIImage imageWithData: data];
//            });
//        });
        
//        NSData * imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:imgUrl]];
//        self.img1.image = [UIImage imageWithData: imageData];
    }
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
#pragma mark - Self Methods
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

-(void) removeFabric {
    
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
    
    FrameSelectionVC *fsvc = [storyboard instantiateViewControllerWithIdentifier:@"FrameSelectionVC"];
    fsvc.type = @"fabric";
    [self.navigationController pushViewController:fsvc animated:YES];
}

- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
