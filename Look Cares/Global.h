//
//  Global.h
//  Look Cares
//
//  Created by Fox Man on 06/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BASE_URL         @"http://pdtowerapp.com/"
//#define BASE_URL         @"http://192.168.0.87/porsche/"

@interface Global : NSObject

+ (Global *)sharedInstance;

@end
