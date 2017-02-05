//
//  RemoveFabricSingleVC.m
//  Look Cares
//
//  Created by Denis Ratkov on 2/5/17.
//  Copyright © 2017 The Lookup Company. All rights reserved.
//

#import "RemoveFabricSingleVC.h"
#import "FabricSelectionVC.h"
#import "FrameSelectionVC.h"
#import "MBProgressHUD.h"
#import "Global.h"
#import "WebConnector.h"
#import "UIImageView+AFNetworking.h"
@interface RemoveFabricSingleVC ()
{
    BOOL isFirstImage;
    NSString *fabricKey1;
    NSArray *fabrics;
    NSInteger stage_status;
}
@end

@implementation RemoveFabricSingleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isFirstImage = false;

    [self updateImageStatus];
    fabrics = [Global sharedInstance].fabrics;
    if (fabrics.count > 0)
    {
        NSString *strFileName = [[[Global sharedInstance].fabrics objectAtIndex:0] objectForKey:@"vcFileName"];
        NSString *imgUrl = [NSString stringWithFormat:@"http://files.lookcares.com/files/%@",strFileName];
//        NSString *imgUrl = [NSString stringWithFormat:@"%@", strFileName];
        [self.img1 setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"image_placeholder"]];
        fabricKey1 = [fabrics[0] objectForKey:@"kFabric"];
        
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
}

-(void) removeFabric:(NSString*)fabricKey {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WebConnector *webConnector = [[WebConnector alloc] init];
    [webConnector removeFabric:fabricKey completionHandler:^(NSURLSessionTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
        NSLog(@"clients:@%@", result);
        [self toNextController];
        
    } errorHandler:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [self toNextController];
    }];
}
-(void) toNextController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FrameSelectionVC *fsvc = [storyboard instantiateViewControllerWithIdentifier:@"FrameSelectionVC"];
    fsvc.type = @"fabric";
    fsvc.frame_size = 1;
    [self.navigationController pushViewController:fsvc animated:YES];
}

- (IBAction)onBtnSelect1:(id)sender {
    isFirstImage = !isFirstImage;
    [self updateImageStatus];
}


- (IBAction)onBtnRemove:(id)sender {
    if (isFirstImage) {
        stage_status = 2;
        [self removeFabric:fabricKey1];
    }
}

- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
