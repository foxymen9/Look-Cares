//
//  InStoreLocationSelectionVC.m
//  Look Cares
//
//  Created by Bendt Jensen on 05/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import "InStoreLocationSelectionVC.h"
#import "LocationTableViewCell.h"
#import "FabricSelectionVC.h"

@interface InStoreLocationSelectionVC ()

@end

@implementation InStoreLocationSelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.viewPopup setHidden:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (LocationTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LocationTableViewCell";
    LocationTableViewCell *cell = (LocationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[LocationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    [cell.imgCell setImage:[UIImage imageNamed:@"pin"]];
    [cell.lblCell setText:@"abc"];
    
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
    [self.viewPopup setHidden:YES];
}
- (IBAction)onBtnSelectLocation:(id)sender {
    [self.viewPopup setHidden:NO];
}

- (IBAction)onSelect:(id)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FabricSelectionVC *fsvc = [storyboard instantiateViewControllerWithIdentifier:@"FabricSelectionVC"];
    [self.navigationController pushViewController:fsvc animated:YES];
}
@end
