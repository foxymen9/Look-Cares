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
    AFHTTPRequestOperationManager *httpManager;
    NSString *baseUrl;
}

typedef void (^CompleteBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void (^ErrorBlock)(AFHTTPRequestOperation *operation, NSError *error);

- (void)login:(NSString *)email password:(NSString *)password completionHandler:(CompleteBlock)completed errorHandler:(ErrorBlock)errorBlock;
@end
