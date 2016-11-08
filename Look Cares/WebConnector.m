//
//  WebConnector.m
//  Look Cares
//
//  Created by Fox Man on 06/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import "WebConnector.h"
#import "Global.h"

@implementation WebConnector

- (id)init {
    if (self = [super init]) {
        baseUrl = [NSString stringWithFormat:@"%@index.php/mobile/Mobile", BASE_URL];
        
        NSURL *url = [NSURL URLWithString:baseUrl];
        
        httpManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    
    return self;
}
- (void)login:(NSString *)email password:(NSString *)password completionHandler:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock {
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:password forKey:@"password"];
    
    [httpManager POST:@"login" parameters:parameters success:completed failure:errorBlock];
}
@end
