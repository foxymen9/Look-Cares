//
//  Utility.h
//  Look Cares
//
//  Created by Bendt Jensen on 06/11/16.
//  Copyright © 2016 The Lookup Company. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utility : NSObject

// Handling files
+ (NSString *)createEditableCopyOfFileIfNeeded:(NSString *)filename;
+ (NSString *)getDocumentsDir;
+ (NSString *)getDocumentsSubDir:(NSString*)subDirName;
+ (NSString *) getDBPath;

// Check if Valid Email
+ (BOOL)validateEmailWithString:(NSString*)email;

+ (BOOL) isEnglishUser;
+ (BOOL) isGermanUser;
+ (BOOL) isSpanishUser;
+ (BOOL) isItalianUser;

//alert
//+ (void) showMessage: (NSString *) message title:(NSString *) title cancel:(NSString *)cancel;
//UUID
+(NSString*) genUUID;

//Network
+(NSDictionary *)getUserInformation;
+(NSString *)getExternalIPAddress;

@end
