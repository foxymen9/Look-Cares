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
    NSString *fabricKey1, *fabricKey2;
    NSArray *fabrics;
    NSInteger stage_status;
}
@end

@implementation RemoveFabricVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    isFirstImage = false;
    isSecondImage = false;
    [self updateImageStatus];
    fabrics = [Global sharedInstance].fabrics;
    if (fabrics.count > 0)
    {
        NSString *strFileName = [[[Global sharedInstance].fabrics objectAtIndex:0] objectForKey:@"vcFileName"];
        NSString *imgUrl = [NSString stringWithFormat:@"http://files.lookcares.com/files/%@", strFileName];
        NSURL *url = [NSURL URLWithString:imgUrl];
        NSData *data = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:data];
        self.img1.image = image;
        fabricKey1 = [fabrics[0] objectForKey:@"kFabric"];
        
        if (fabrics.count > 1)
        {
            fabricKey2 = [fabrics[1] objectForKey:@"kFabric"];
            NSString *strFileName2 = [[[Global sharedInstance].fabrics objectAtIndex:0] objectForKey:@"vcFileName"];
            NSString *imgUrl2 = [NSString stringWithFormat:@"http://files.lookcares.com/files/%@", strFileName2];
            NSURL *url2 = [NSURL URLWithString:imgUrl2];
            NSData *data2 = [NSData dataWithContentsOfURL:url2];
            UIImage *image = [UIImage imageWithData:data2];
            self.img2.image = image;
        }
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

-(void) removeFabric:(NSString*)fabricKey {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WebConnector *webConnector = [[WebConnector alloc] init];
    [webConnector removeFabric:fabricKey completionHandler:^(NSURLSessionTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
        NSLog(@"clients:@%@", result);
        if (result) {
            [self toNextController];
        }

    } errorHandler:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self toNextController];
    }];
}
-(void) toNextController {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FrameSelectionVC *fsvc = [storyboard instantiateViewControllerWithIdentifier:@"FrameSelectionVC"];
    fsvc.type = @"fabric";
    NSString *vcExtrusion = [[Global sharedInstance].frame objectForKey:@"vcExtrusion"];
    if ([vcExtrusion  isEqual: @"120mm"] || [vcExtrusion  isEqual: @"36mm"] || [vcExtrusion  isEqual: @"50mm"])
    {
        fsvc.frame_size = stage_status;
    }
    else{
        fsvc.frame_size = 1;
    }
    [self.navigationController pushViewController:fsvc animated:YES];
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
    
    NSInteger fabric_count = fabrics.count;
    if (fabric_count == 2 && isFirstImage && isSecondImage) {
        stage_status = 2;
        WebConnector *webConnector = [[WebConnector alloc] init];
        [webConnector removeFabric:fabricKey1 completionHandler:^(NSURLSessionTask *task, id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
            NSLog(@"clients:@%@", result);
            if (result) {
                [self removeFabric:fabricKey2];
            }
            
        } errorHandler:^(NSURLSessionTask *operation, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    else if (fabric_count == 2 && isFirstImage) {
        stage_status = 1;
        [self removeFabric:fabricKey1];
    }
    else if (fabric_count == 2 && isSecondImage) {
        stage_status = 1;
        [self removeFabric:fabricKey2];
    }
    else if (isFirstImage) {
        stage_status = 1;
        [self removeFabric:fabricKey1];
        
    }
    else if (isSecondImage) {
        stage_status = 1;
        [self removeFabric:fabricKey2];
    }
}

- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
