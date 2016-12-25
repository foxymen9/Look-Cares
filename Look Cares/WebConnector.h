//
//  WebConnector.h
//  Look Cares
//
//  Created by Fox Man on 06/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"


@interface WebConnector : NSObject {
    AFHTTPSessionManager *httpManager;
    NSString *baseUrl;
}

typedef void (^CompleteBlock)(NSURLSessionTask *task, id responseObject);
typedef void (^ErrorBlock)(NSURLSessionTask *operation, NSError *error);

- (void)login:(NSString *)email password:(NSString *)password completionHandler:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock;
- (void)getAllClients:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock;
- (void)getLocationsWithClient:(NSString*)clientKey completionHandler:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock;
- (void)getFrame:(NSString*)serialNumber  completionHandler:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock;
- (void)getStoreLocations:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock;
- (void)getFabric:(NSString*)serialNumber  completionHandler:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock;
- (void)addFabric:(NSString*) serialNumber clientKey:(NSString *)clientKey clientLocationKey:(NSString *)clientLocationKey frameKey:(NSString*)frameKey completionHandler:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock;
- (void)removeFabric:(NSString*)fabricKey  completionHandler:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock;
//- (void)addFabric:(NSString *)clientKey clientLocationKey:(NSString *)clientLocationKey frameKey:(NSString*)frameKey height:(NSString*)height width:(NSString*)width extrusion:(NSString*)extrusion image:(UIImage*)image completionHandler:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock;
@end
