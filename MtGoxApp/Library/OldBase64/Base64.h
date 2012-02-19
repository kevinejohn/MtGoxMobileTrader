//
//  Base64.h
//  NCA-App
//
//  Created by Kevin Johnson on 11/15/11.
//  Copyright (c) 2011 Home. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject

+(NSString *)encode:(NSData *)plainText;
+ (NSString *)decodeBase64:(NSString *)input;

@end
