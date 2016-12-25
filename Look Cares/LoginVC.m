//
//  ViewController.m
//  Look Cares
//
//  Created by Fox Man on 04/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import "LoginVC.h"
#import "LocationSelectionVC.h"
#import "MBProgressHUD.h"
#import "WebConnector.h"
#import "Global.h"

@interface LoginVC ()

@property (nonatomic) bool isChecked;

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                action:@selector(handleTapSubView:)];
    [self.viewSub addGestureRecognizer:singleTap];
    self.isChecked = false;
    [self updateCheckBox];
    
}

- (void)viewWillAppear:(BOOL)animated {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([[prefs objectForKey:@"RememberMe"] boolValue] == true) {
        NSDictionary *owner = [prefs objectForKey:@"CurrentUser"][0];
    }
    else
    {
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)handleTapSubView:(UITapGestureRecognizer *)tap {
    [self.txtEmail resignFirstResponder];
    [self.txtPassword resignFirstResponder];
}

#pragma mark - Self Methods

- (void)updateCheckBox {
    if (self.isChecked == false)
        [_imgTick setImage:nil];
    else
        [_imgTick setImage:[UIImage imageNamed:@"tick_big"]];
}
- (void)loginProcess:(NSString *)email password:(NSString *)password {

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WebConnector *webConnector = [[WebConnector alloc] init];
    [webConnector login:email password:password completionHandler:^(NSURLSessionTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
        if (result[@"token"] ) {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            [prefs setObject:result forKey:@"CurrentUser"];
            
                        
            if (self.isChecked) {
                [prefs setObject:[NSNumber numberWithBool:true] forKey:@"RememberMe"];
            } else {
                [prefs removeObjectForKey:@"RememberMe"];
            }
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            LocationSelectionVC *lsVC = [storyboard instantiateViewControllerWithIdentifier:@"LocationSelectionVC"];
            [self.navigationController pushViewController:lsVC animated:YES];
            
            
            self.txtEmail.text = @"";
            self.txtPassword.text = @"";
            self.isChecked = false;
            [self updateCheckBox];
            [self.view endEditing:YES];
        }
        else {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Failed to login" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    } errorHandler:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Failed to login" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }];
}

- (IBAction)onBtnCheck:(id)sender {
    self.isChecked = !self.isChecked;
    [self updateCheckBox];
}

- (IBAction)onBtnLogin:(id)sender {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:[NSNumber numberWithBool:self.isChecked] forKey:@"RememberMe"];
    NSString *email = self.txtEmail.text;
    NSString *password = self.txtPassword.text;
    
    if ([email isEqualToString:@""] || [password isEqualToString:@""]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please fill all fields!" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self loginProcess:email password:password];
    
    
//    [self loginProcess:@"installer1" password:@"installer1"];
}

@end
