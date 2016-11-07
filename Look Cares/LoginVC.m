//
//  ViewController.m
//  Look Cares
//
//  Created by Bendt Jensen on 04/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import "LoginVC.h"
#import "LocationSelectionVC.h"

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
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LocationSelectionVC *lsVC = [storyboard instantiateViewControllerWithIdentifier:@"LocationSelectionVC"];
    [self.navigationController pushViewController:lsVC animated:YES];
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
    
//    if ([email isEqualToString:@""] || [password isEqualToString:@""]) {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please fill all fields!" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//        [alert addAction:defaultAction];
//        
//        [self presentViewController:alert animated:YES completion:nil];
//        return;
//    }
//    
//    if ([Utility validateEmailWithString:email]) {
//        
//    }
//    else
//    {
//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Invalid e-mail address!" preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
//        [alert addAction:defaultAction];
//        [self presentViewController:alert animated:YES completion:nil];
//        return;
//    }
    
    [self loginProcess:email password:password];
}

@end
