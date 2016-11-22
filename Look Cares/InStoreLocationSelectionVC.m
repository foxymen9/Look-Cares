//
//  InStoreLocationSelectionVC.m
//  Look Cares
//
//  Created by Fox Man on 05/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import "InStoreLocationSelectionVC.h"
#import "LocationTableViewCell.h"
#import "FabricSelectionVC.h"
#import "FrameSelectionVC.h"
#import "MBProgressHUD.h"
#import "Global.h"
#import "WebConnector.h"
@interface InStoreLocationSelectionVC ()
{
    NSDictionary *selectedStoreLocation;
    NSMutableArray *storeLocations;
    NSInteger selectedID;
}
@end

@implementation InStoreLocationSelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.viewPopup setHidden:YES];
    selectedID = -1;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getStoreLocations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Self methods

- (void)saveToGlobal{
    [Global sharedInstance].selectedStoreLocation = selectedStoreLocation;
}

- (void)getStoreLocations{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WebConnector *webConnector = [[WebConnector alloc] init];
    [webConnector getStoreLocations:^(NSURLSessionTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
        NSLog(@"clients:@%@", result);
        if (result) {
            storeLocations = [[NSMutableArray alloc] initWithArray:[result mutableCopy]];
        }
        [self.tableView reloadData];
    } errorHandler:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}



#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return storeLocations.count;
}

- (LocationTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LocationTableViewCell";
    LocationTableViewCell *cell = (LocationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[LocationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    [cell.imgCell setImage:[UIImage imageNamed:@"pin"]];
    [cell.lblCell setText:[[storeLocations objectAtIndex:indexPath.row] objectForKey:@"vcInStoreLocation"]];
    
    return cell;
}

#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    if ([[UIDevice currentDevice].model containsString:@"iPad"]) {
        height = 62;
    }
    else {
        height = 40;
    }
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedID = indexPath.row;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)onBtnCancel:(id)sender {
    [self.viewPopup setHidden:YES];
}

- (IBAction)onBtnSelectPopup:(id)sender {
    selectedStoreLocation = [storeLocations objectAtIndex:selectedID];
    [self.lbl_storeTitle setText:[selectedStoreLocation objectForKey:@"vcInStoreLocation"]];
    [self.viewPopup setHidden:YES];
}
- (IBAction)onBtnSelectLocation:(id)sender {
    [self.viewPopup setHidden:NO];
}

- (IBAction)onSelect:(id)sender{
    [self saveToGlobal];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FrameSelectionVC *fsvc = [storyboard instantiateViewControllerWithIdentifier:@"FrameSelectionVC"];
    fsvc.type = @"fabric";
    [self.navigationController pushViewController:fsvc animated:YES];
}

- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
