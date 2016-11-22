//
//  WebConnector.m
//  Look Cares
//
//  Created by Fox Man on 06/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import "WebConnector.h"
#import "Global.h"
#import "Utility.h"

@implementation WebConnector

- (id)init {
    if (self = [super init]) {
        baseUrl = [NSString stringWithFormat:@"%@/api/", BASE_URL];
        
        NSURL *url = [NSURL URLWithString:baseUrl];
        
        httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:url];
    }
    
    return self;
}
- (void)login:(NSString *)username password:(NSString *)password completionHandler:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:username forKey:@"username"];
    [parameters setObject:password forKey:@"password"];
    
    [httpManager POST:@"Auth/Login" parameters:parameters success:completed failure:errorBlock];
    
}
- (void)getAllClients:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock {
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *token = [NSString stringWithFormat:@"base %@", [Utility getAccessToken]];
    
    [httpManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    [httpManager GET:@"Clients" parameters:nil success:completed failure:errorBlock];
}
- (void)getLocationsWithClient:(NSString*)clientKey completionHandler:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock {
    
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *token = [NSString stringWithFormat:@"base %@", [Utility getAccessToken]];
    NSString *url = [NSString stringWithFormat:@"ClientLocations/ByClientKey/%@", clientKey];
    [httpManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    [httpManager GET:url parameters:nil success:completed failure:errorBlock];
}
- (void)getFrame:(NSString*)serialNumber  completionHandler:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock {
    
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *token = [NSString stringWithFormat:@"base %@", [Utility getAccessToken]];
    [httpManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSString *url = [NSString stringWithFormat:@"Frames/%@", serialNumber];
    [httpManager GET:url parameters:nil success:completed failure:errorBlock];
}
- (void)getStoreLocations:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock {
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *token = [NSString stringWithFormat:@"base %@", [Utility getAccessToken]];
    
    [httpManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    [httpManager GET:@"StoreLocations" parameters:nil success:completed failure:errorBlock];
}
- (void)getFabric:(NSString*)serialNumber  completionHandler:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock {
    
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *token = [NSString stringWithFormat:@"base %@", [Utility getAccessToken]];
    [httpManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    NSString *url = [NSString stringWithFormat:@"Frames/Fabric/%@", serialNumber];
    [httpManager GET:url parameters:nil success:completed failure:errorBlock];
}
- (void)addFabric:(NSString *)clientKey clientLocationKey:(NSString *)clientLocationKey frameKey:(NSString*)frameKey height:(NSString*)height width:(NSString*)width extrusion:(NSString*)extrusion image:(UIImage*)image completionHandler:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:clientKey forKey:@"ClientKey"];
    [parameters setObject:clientLocationKey forKey:@"ClientLocationKey"];
    [parameters setObject:frameKey forKey:@"FrameKey"];
    [parameters setObject:height forKey:@"Height"];
    [parameters setObject:width forKey:@"Width"];
    [parameters setObject:extrusion forKey:@"Extrusion"];
    
    httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
    NSString *token = [NSString stringWithFormat:@"base %@", [Utility getAccessToken]];
    [httpManager.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
    [httpManager POST:@"Frames/Fabric" parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:imageData name:@"image"];
    } success:completed failure:errorBlock];
    
}
@end
