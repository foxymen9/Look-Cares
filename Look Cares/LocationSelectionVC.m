//
//  LocationSelectionVC.m
//  Look Cares
//
//  Created by Fox Man on 05/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import "LocationSelectionVC.h"
#import "LocationTableViewCell.h"
#import "FrameSelectionVC.h"
#import "MBProgressHUD.h"
#import "WebConnector.h"
#import "Global.h"

@interface LocationSelectionVC ()
{
    NSMutableArray *clients;
    NSMutableArray *locationsByClient;
    NSDictionary *selectedClient, *selectedLocation;
    NSInteger selectedID, selectedOption;
}
@end

@implementation LocationSelectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.viewPopup setHidden:YES];
    clients = [[NSMutableArray alloc] init];
    locationsByClient = [[NSMutableArray alloc] init];
    selectedID = -1;
    selectedOption = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getAllClients];
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

- (IBAction)onBtnClient:(id)sender {
    selectedOption = 0;
    selectedLocation = nil;
    if (clients)
        [self.tableView reloadData];
    [self.viewPopup setHidden:NO];
}

- (IBAction)onBtnLocation:(id)sender {
    selectedOption = 1;
    if (!selectedClient) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please select the client." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        [self getLocationsWithClient:[selectedClient objectForKey:@"kLookClient"]];
    }
}

- (IBAction)onBtnSelect:(id)sender {
    if (!selectedLocation)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Please select the client & location." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    [self saveToGlobal];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    FrameSelectionVC *fsVC = [storyboard instantiateViewControllerWithIdentifier:@"FrameSelectionVC"];
    fsVC.type = @"frame";
    [self.navigationController pushViewController:fsVC animated:YES];
}
- (IBAction)onBtnCancel:(id)sender {
    [self.viewPopup setHidden:YES];
}
- (IBAction)onBtnSelectPopup:(id)sender {
    if (selectedID <0)
        return;
    if (selectedOption == 0)
    {
        selectedClient = [clients objectAtIndex:selectedID];
        [self.lblClient setText:[selectedClient objectForKey:@"vcClientName"]];
    }
    else
    {
        selectedLocation = [locationsByClient objectAtIndex:selectedID];
        NSString *vcShipToStateProvince = [selectedLocation objectForKey:@"vcShipToStateProvince"];
        NSString *vcShipToPostal = [selectedLocation objectForKey:@"vcShipToPostal"];
        NSString *vcShipToName = [selectedLocation objectForKey:@"vcShipToName"];
        NSString *vcShipToCountry = [selectedLocation objectForKey:@"vcShipToCountry"];
        NSString *vcShipToContact = [selectedLocation objectForKey:@"vcShipToContact"];
        NSString *vcShipToCity = [selectedLocation objectForKey:@"vcShipToCity"];
        NSString *vcShipToAddress1 = [selectedLocation objectForKey:@"vcShipToAddress1"];
        
        NSString *locationString = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@", vcShipToStateProvince, vcShipToPostal, vcShipToName, vcShipToCountry, vcShipToContact, vcShipToCity,vcShipToAddress1];
        [self.lblLocation setText:locationString];
    }
    selectedID = 0;
    [self.viewPopup setHidden:YES];
}

- (IBAction)onBtnBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Self Methods

- (void)saveToGlobal{
    [Global sharedInstance].selectedLocation = selectedLocation;
    [Global sharedInstance].selectedClient = selectedClient;
}

- (void)getAllClients{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WebConnector *webConnector = [[WebConnector alloc] init];
    [webConnector getAllClients:^(NSURLSessionTask *task, id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
        NSLog(@"clients:@%@", result);
        if (result) {
            clients = [[NSMutableArray alloc] initWithArray:[result mutableCopy]];
        }
        [self.tableView reloadData];
    } errorHandler:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
- (void)getLocationsWithClient:(NSString*) clientKey{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    WebConnector *webConnector = [[WebConnector alloc] init];
    [webConnector getLocationsWithClient:clientKey completionHandler:^(NSURLSessionTask *task, id responseObject)  {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSMutableDictionary *result = (NSMutableDictionary *)responseObject;
        NSLog(@"locations:%@", result);
        if (result) {
            locationsByClient = [[NSMutableArray alloc] initWithArray:[result mutableCopy]];
            [self.tableView reloadData];
        }
        [self.viewPopup setHidden:NO];
    } errorHandler:^(NSURLSessionTask *operation, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}
#pragma mark - UITableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (selectedOption == 0)
        return clients.count;
    else
        return locationsByClient.count;
}

- (LocationTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"LocationTableViewCell";
    LocationTableViewCell *cell = (LocationTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil)
        cell = [[LocationTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    
    [cell.imgCell setImage:[UIImage imageNamed:@"pin"]];
    if (selectedOption == 0)
        [cell.lblCell setText:[[clients objectAtIndex:indexPath.row] objectForKey:@"vcClientName"]];
    else
    {
        NSString *vcShipToStateProvince = [[locationsByClient objectAtIndex:indexPath.row] objectForKey:@"vcShipToStateProvince"];
        NSString *vcShipToPostal = [[locationsByClient objectAtIndex:indexPath.row] objectForKey:@"vcShipToPostal"];
        NSString *vcShipToName = [[locationsByClient objectAtIndex:indexPath.row] objectForKey:@"vcShipToName"];
        NSString *vcShipToCountry = [[locationsByClient objectAtIndex:indexPath.row] objectForKey:@"vcShipToCountry"];
        NSString *vcShipToContact = [[locationsByClient objectAtIndex:indexPath.row] objectForKey:@"vcShipToContact"];
        NSString *vcShipToCity = [[locationsByClient objectAtIndex:indexPath.row] objectForKey:@"vcShipToCity"];
        NSString *vcShipToAddress1 = [[locationsByClient objectAtIndex:indexPath.row] objectForKey:@"vcShipToAddress1"];
        
        NSString *locationString = [NSString stringWithFormat:@"%@ %@ %@ %@ %@ %@ %@", vcShipToStateProvince, vcShipToPostal, vcShipToName, vcShipToCountry, vcShipToContact, vcShipToCity,vcShipToAddress1];
        [cell.lblCell setText:locationString];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedID = indexPath.row;
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

@end
