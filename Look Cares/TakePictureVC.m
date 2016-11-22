//
//  TakePictureVC.m
//  Look Cares
//
//  Created by Fox Man on 06/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import "TakePictureVC.h"
#import "FrameSelectionVC.h"
#import "LoginVC.h"
#import "MBProgressHUD.h"
#import "Global.h"
#import "WebConnector.h"


@interface TakePictureVC ()
{
    UIImagePickerController *ipc;
}
@end

@implementation TakePictureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)onBtnOpenCamera:(id)sender {
    
}

#pragma mark - Self Methods

-(void) takePhoto:(UIImagePickerControllerSourceType)sourceType {
    if ([UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.sourceType = sourceType;
        picker.delegate = self;
        picker.editing = NO;
        picker.allowsEditing = YES;
        
        [self.navigationController presentViewController:picker animated:YES completion:nil];
    }
}

#pragma mark - ImagePickerController Delegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
//    UIImage *scaledImage = [DataManager scaleAndRotateImage:editedImage resolution:256];
    self.imgPhoto.image = editedImage;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)onBtnTakePicture:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Choose a Photo" message:@"Please choose a photo." preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        [self takePhoto:sourceType];
    }];
    UIAlertAction *galleryAction = [UIAlertAction actionWithTitle:@"Choose Photo from Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self takePhoto:sourceType];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alert addAction:cameraAction];
    [alert addAction:galleryAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)onBtnDone:(id)sender {
    if (!self.imgPhoto.image)
    {
        return;
    }
    NSString *clientKey =  [[Global sharedInstance].selectedClient objectForKey:@"kLookClient"];
    NSString *clientLocationKey = [[Global sharedInstance].selectedLocation objectForKey:@"kLookClientCustomer"];
    NSString *frameKey = [[Global sharedInstance].frame objectForKey:@"kFrame"];
    NSString *width = [NSString stringWithFormat:@"%f", self.imgPhoto.image.size.width];
    NSString *height = [NSString stringWithFormat:@"%f", self.imgPhoto.image.size.height];
    NSString *extrusion = @"Stretch";
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Make more changes?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        FrameSelectionVC *fsvc = [storyboard instantiateViewControllerWithIdentifier:@"FrameSelectionVC"];
        
        [self.navigationController pushViewController:fsvc animated:YES];
        fsvc.type = @"frame";
    }];
    UIAlertAction *noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        LoginVC *lVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginVC"];
        [self.navigationController pushViewController:lVC animated:YES];
    }];
    [alert addAction:yesAction];
    [alert addAction:noAction];
    
        
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WebConnector *webConnector = [[WebConnector alloc] init];
    [webConnector addFabric:clientKey clientLocationKey:clientLocationKey frameKey:frameKey height:height width:width extrusion:extrusion image:self.imgPhoto.image completionHandler:^(NSURLSessionTask *task, id responseObject){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
        NSLog(@"AddFabric:@%@", result);
        if (result) {
            
        }
    } errorHandler:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Failed to upload." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
