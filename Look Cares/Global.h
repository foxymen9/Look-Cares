//
//  Global.h
//  Look Cares
//
//  Created by Fox Man on 06/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BASE_URL         @"http://tlcapi-proddeployment.azurewebsites.net/"
//#define BASE_URL         @"http://192.168.0.111:56789/"

@interface Global : NSObject

+ (Global *)sharedInstance;
@property (strong, nonatomic, readwrite) NSDictionary *selectedClient, *selectedLocation, *frame, *selectedStoreLocation;
@property (strong, nonatomic, readwrite) NSArray *fabrics;
@property (strong, nonatomic, readwrite) NSString *fabricSerialNumber;
@end
