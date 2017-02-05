//
//  FrameSelectionVC.m
//  Look Cares
//
//  Created by Fox Man on 05/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import "FrameSelectionVC.h"
#import "InstoreLocationSelectionVC.h"
#import "RemoveFabricVC.h"
#import "RemoveFabricSingleVC.h"
#import "MTBBarcodeScanner.h"
#import "TakePictureVC.h"
#import "MBProgressHUD.h"
#import "Global.h"
#import "WebConnector.h"

@interface FrameSelectionVC ()
{
    NSString *inputType, *serialNumber;
    NSMutableDictionary *frame;
    NSArray *fabrics;
}
@property (nonatomic, strong) MTBBarcodeScanner *scanner;
@property (nonatomic, strong) NSMutableArray *uniqueCodes;
@property (nonatomic, assign) BOOL captureIsFrozen;
@property (nonatomic, assign) BOOL didShowCaptureWarning;


@end

@implementation FrameSelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.viewCodeReader setHidden:NO];
    [self.viewTextInput setHidden:YES];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleTapSubView:)];
    [self.viewTextInput addGestureRecognizer:singleTap];
    if ([self.type isEqualToString:@"frame"]) {
        [self.txtSerialNumber setText:@"SN06281600013"];
        [self.lbl_title setText:@"Frame Selection"];
    }
    else if ([self.type isEqualToString:@"fabric"]) {
        [self.txtSerialNumber setText:@"SN07191600488"];
        [self.lbl_title setText:@"Fabric Selection"];
    }
    
    inputType = [[NSString alloc] initWithFormat:@"nfc"];
    [self.viewCodeReader setHidden:YES];
    [self.viewTextInput setHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(previewTapped)];
    [self.viewCodeReader addGestureRecognizer:tapGesture];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.scanner stopScanning];
    [super viewWillDisappear:animated];
}

#pragma mark - Scanner

- (MTBBarcodeScanner *)scanner {
    if (!_scanner) {
        _scanner = [[MTBBarcodeScanner alloc] initWithPreviewView:self.viewCodeReader];
    }
    return _scanner;
}

#pragma mark - Scanning

- (void)startScanning {
    self.uniqueCodes = [[NSMutableArray alloc] init];
    
    NSError *error = nil;
    [self.scanner startScanningWithResultBlock:^(NSArray *codes) {
        for (AVMetadataMachineReadableCodeObject *code in codes) {
            if (code.stringValue && [self.uniqueCodes indexOfObject:code.stringValue] == NSNotFound) {
                [self.uniqueCodes addObject:code.stringValue];
                
                NSLog(@"Found unique code: %@", code.stringValue);
                // Update the tableview
                [self.lblSerialNumber setText:code.stringValue];
                serialNumber = code.stringValue;
            }
        }
    } error:&error];
    
    if (error) {
        NSLog(@"An error occurred: %@", error.localizedDescription);
    }
    
}

- (void)stopScanning {
    [self.scanner stopScanning];

    self.captureIsFrozen = NO;
}

#pragma mark - Helper Methods

- (void)displayPermissionMissingAlert {
    NSString *message = nil;
    if ([MTBBarcodeScanner scanningIsProhibited]) {
        message = @"This app does not have permission to use the camera.";
    } else if (![MTBBarcodeScanner cameraIsPresent]) {
        message = @"This device does not have a camera.";
    } else {
        message = @"An unknown error occurred.";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Scanning Unavailable" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Gesture Handlers
- (void)handleTapSubView:(UITapGestureRecognizer *)tap {
    [self.txtSerialNumber resignFirstResponder];
}

- (void)previewTapped {
    if (![self.scanner isScanning] && !self.captureIsFrozen) {
        return;
    }
    
    if (!self.didShowCaptureWarning) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Capture Frozen" message:@"The capture is now frozen. Tap the preview again to unfreeze." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        self.didShowCaptureWarning = YES;
    }
    
    if (self.captureIsFrozen) {
        [self.scanner unfreezeCapture];
    } else {
        [self.scanner freezeCapture];
    }
    
    self.captureIsFrozen = !self.captureIsFrozen;
}

#pragma mark - Setters

- (void)setUniqueCodes:(NSMutableArray *)uniqueCodes {
    _uniqueCodes = uniqueCodes;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - self methods
- (void)saveToGlobal{
    [Global sharedInstance].frame = frame;
    [Global sharedInstance].fabrics = fabrics;
}

- (void)getFrame:(NSString*) number{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WebConnector *webConnector = [[WebConnector alloc] init];
    [webConnector getFrame:number completionHandler:^(NSURLSessionTask *task, id responseObject)  {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
        if (result) {
            frame = [result objectForKey:@"frame"];
            fabrics = [result objectForKey:@"fabrics"];
            NSString *checkInstall = [frame objectForKey:@"vcInstalled"];
            NSString *vcExtrusion = [frame objectForKey:@"vcExtrusion"];

            [self saveToGlobal];
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            NSLog(@"frame:%@", frame);
            NSLog(@"fabrics:%@", fabrics);
            if ([checkInstall isEqualToString:@"Uninstalled"])
            {
                InStoreLocationSelectionVC *ilsvc = [storyboard instantiateViewControllerWithIdentifier:@"InStoreLocationSelectionVC"];
                [self.navigationController pushViewController:ilsvc animated:YES];
            }
            else
            {
                if ([vcExtrusion  isEqual: @"120mm"] || [vcExtrusion  isEqual: @"36mm"] || [vcExtrusion  isEqual: @"50mm"]){
                    RemoveFabricVC *rfvc = [storyboard instantiateViewControllerWithIdentifier:@"RemoveFabricVC"];
                    [self.navigationController pushViewController:rfvc animated:YES];
                }
                else{
                    RemoveFabricSingleVC *rfvc = [storyboard instantiateViewControllerWithIdentifier:@"RemoveFabricSingleVC"];
                    [self.navigationController pushViewController:rfvc animated:YES];
                }
            }
        }
    } errorHandler:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Invalid Serial Number." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (void)getFabric:(NSString*) number{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WebConnector *webConnector = [[WebConnector alloc] init];
    [webConnector getFabric:number completionHandler:^(NSURLSessionTask *task, id responseObject)  {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
        if (result) {
            NSString *clientKey =  [[Global sharedInstance].selectedClient objectForKey:@"kLookClient"];
            NSString *clientLocationKey = [[Global sharedInstance].selectedLocation objectForKey:@"kLookClientCustomer"];
            NSString *frameKey = [[Global sharedInstance].frame objectForKey:@"kFrame"];
            WebConnector *webConnector = [[WebConnector alloc] init];
            [webConnector addFabric:number clientKey:clientKey clientLocationKey:clientLocationKey frameKey:frameKey completionHandler:^(NSURLSessionTask *task, id responseObject){
                [MBProgressHUD hideHUDForView:self.view animated:YES];
        
                NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
                NSLog(@"AddFabric:@%@", result);
                if (result) {
                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                    if (_frame_size == 2) {
                        FrameSelectionVC *fsvc = [storyboard instantiateViewControllerWithIdentifier:@"FrameSelectionVC"];
                        fsvc.type = @"fabric";
                        fsvc.frame_size = 1;
                        [self.navigationController pushViewController:fsvc animated:YES];
                    }
                    else
                    {
                        TakePictureVC *ilsvc = [storyboard instantiateViewControllerWithIdentifier:@"TakePictureVC"];
                        [self.navigationController pushViewController:ilsvc animated:YES];
                    }
                }
            } errorHandler:^(NSURLSessionTask *operation, NSError *error) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Failed to upload." preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:defaultAction];
                [self presentViewController:alert animated:YES completion:nil];
            }];
        }
    } errorHandler:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Invalid Serial Number." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (IBAction)segBtnTapped:(id)sender {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self.viewCodeReader setHidden:YES];
        [self.viewTextInput setHidden:YES];
        [self.btnCodeReader setImage:[UIImage imageNamed:@"icon_barcode"] forState:UIControlStateNormal];
        [self.lblSerialNumber setHidden:YES];
        
    }
    else if (self.segmentedControl.selectedSegmentIndex == 1) {
        [self.viewCodeReader setHidden:NO];
        [self.viewTextInput setHidden:YES];
        [self.btnCodeReader setImage:[UIImage imageNamed:@"icon_barcode"] forState:UIControlStateNormal];
        [self.lblSerialNumber setHidden:NO];
    }
    else if (self.segmentedControl.selectedSegmentIndex == 2) {
        [self.viewCodeReader setHidden:YES];
        [self.viewTextInput setHidden:NO];
        [self.lblSerialNumber setHidden:YES];
    }
}

- (IBAction)onBtnCodeReader:(id)sender {
    if ([self.scanner isScanning] || self.captureIsFrozen) {
        [self stopScanning];
    } else {
        [MTBBarcodeScanner requestCameraPermissionWithSuccess:^(BOOL success) {
            if (success) {
                [self startScanning];
            } else {
                [self displayPermissionMissingAlert];
            }
        }];
    }
}

- (IBAction)onBtnDone:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (self.segmentedControl.selectedSegmentIndex == 1)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please select the serial number. NFC is not available for now." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (self.segmentedControl.selectedSegmentIndex == 2)
        serialNumber = self.txtSerialNumber.text;
    if ([self.type isEqualToString:@"frame"])
    {
        [self getFrame:serialNumber];
    }
    else
    {
        [self getFabric:serialNumber];
        [Global sharedInstance].fabricSerialNumber = serialNumber;
        
    }
}

- (IBAction)onBtnReverse:(id)sender {
    [self.scanner flipCamera];
}
- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
