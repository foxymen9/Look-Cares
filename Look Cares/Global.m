//
//  Global.m
//  Look Cares
//
//  Created by Fox Man on 06/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import "Global.h"


@implementation Global

+ (Global *)sharedInstance {
    static dispatch_once_t onceToken;
    static Global *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[Global alloc] init];
    });
    return instance;
}

- (id)init {
    self = [super init];
    return self;
}
@end
