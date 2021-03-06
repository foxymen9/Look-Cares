//
//  Global.h
//  Look Cares
//
//  Created by Fox Man on 06/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import <Foundation/Foundation.h>

//#define BASE_URL         @"http://192.168.0.82:56789/"
//#define FILE_SERVER_URL     @"";

//#define BASE_URL         @"http://tlcapi-proddeployment.azurewebsites.net/"
#define BASE_URL         @"http://tlcassetmanagement.azurewebsites.net/"
//#define BASE_URL         @"http://tlcassetmanagement-prod.azurewebsites.net/"
#define FILE_SERVER_URL     @"http://files.lookcares.com/files/";

@interface Global : NSObject

+ (Global *)sharedInstance;
@property (strong, nonatomic, readwrite) NSDictionary *selectedClient, *selectedLocation, *frame, *selectedStoreLocation;
@property (strong, nonatomic, readwrite) NSArray *fabrics;
@property (strong, nonatomic, readwrite) NSString *fabricSerialNumber;
@end
